part of '../core.dart';

class _ReactiveState {
  /// Current batch depth. This is used to track the depth of `transaction` / `action`.
  /// When the batch ends, we execute all the [pendingReactions]
  int batch = 0;

  /// Monotonically increasing counter for assigning a name to an action/reaction/atom
  int nextIdCounter = 0;

  /// Tracks the currently executing derivation (reactions or computeds).
  /// The Observables used here are linked to this derivation.
  Derivation? trackingDerivation;

  /// The reactions that must be triggered at the end of a `transaction` or an `action`
  List<Reaction> pendingReactions = [];

  /// Are we in middle of executing the [pendingReactions].
  bool isRunningReactions = false;

  /// The atoms that must be disconnected from their observed reactions. This happens
  /// if a reaction has been disposed during a batch
  List<Atom> pendingUnobservations = [];
  bool isRunningUnobservations = false;

  /// Tracks if within a computed property evaluation
  int computationDepth = 0;

  /// Tracks if observables can be mutated
  bool allowStateChanges = true;

  /// Are we inside an action or transaction?
  bool get isWithinBatch => batch > 0;

  /// Are we inside a reaction or computed?
  bool get isWithinDerivation =>
      trackingDerivation != null || computationDepth > 0;

  List<SpyListener> spyListeners = [];
}

typedef ReactionErrorHandler = void Function(Object error, Reaction reaction);

/// Defines the behavior for observables read outside actions and reactions
///
/// `always`: If observables are read outside actions/reactions, throw an Exception
/// `never`: Allow unrestricted reading of observables everywhere. This is the default.
enum ReactiveReadPolicy { always, never }

/// Defines the behavior for observables mutated outside actions
///
/// `observed`: If there are observers for the mutated observable, then throw. Else allow mutation outside an action.
/// `always`: Always throw if an observable is mutated outside an action
/// `never`: Allow mutating observables outside actions
enum ReactiveWritePolicy { observed, always, never }

/// Configuration used by [ReactiveContext]
class ReactiveConfig {
  ReactiveConfig({
    this.disableErrorBoundaries = false,
    this.writePolicy = ReactiveWritePolicy.observed,
    this.readPolicy = ReactiveReadPolicy.never,
    this.maxIterations = 100,
    this.isSpyEnabled = false,
  });

  /// The main or default configuration used by [ReactiveContext]
  static final ReactiveConfig main = ReactiveConfig(
    disableErrorBoundaries: false,
    writePolicy: ReactiveWritePolicy.observed,
    readPolicy: ReactiveReadPolicy.never,
  );

  /// Whether MobX should throw exceptions instead of catching them and store
  /// as [Derivation.errorValue].
  final bool disableErrorBoundaries;

  /// Enforce mutation of observables inside an action
  final ReactiveWritePolicy writePolicy;

  /// Enforce the use of reactions for reading observables
  final ReactiveReadPolicy readPolicy;

  /// Max number of iterations before bailing out for a cyclic reaction
  final int maxIterations;

  final bool isSpyEnabled;

  ReactiveConfig clone({
    bool? disableErrorBoundaries,
    ReactiveWritePolicy? writePolicy,
    ReactiveReadPolicy? readPolicy,
    int? maxIterations,
    bool? isSpyEnabled,
  }) => ReactiveConfig(
    disableErrorBoundaries:
        disableErrorBoundaries ?? this.disableErrorBoundaries,
    writePolicy: writePolicy ?? this.writePolicy,
    readPolicy: readPolicy ?? this.readPolicy,
    maxIterations: maxIterations ?? this.maxIterations,
    isSpyEnabled: isSpyEnabled ?? this.isSpyEnabled,
  );
}

class ReactiveContext {
  ReactiveContext({ReactiveConfig? config}) {
    this.config = config ?? ReactiveConfig.main;
  }

  late ReactiveConfig _config;

  ReactiveConfig get config => _config;
  set config(ReactiveConfig newValue) {
    _config = newValue;
    _state.allowStateChanges = _config.writePolicy == ReactiveWritePolicy.never;
  }

  final _ReactiveState _state = _ReactiveState();

  int _nextTrackingId = 0;
  final Set<ReactionErrorHandler> _reactionErrorHandlers = {};

  int get nextId => ++_state.nextIdCounter;

  String nameFor(String prefix) {
    assert(prefix.isNotEmpty);
    return '$prefix@$nextId';
  }

  bool get isWithinBatch => _state.isWithinBatch;

  bool get isSpyEnabled =>
      _config.isSpyEnabled && _state.spyListeners.isNotEmpty;

  Dispose spy(SpyListener listener) {
    _state.spyListeners.add(listener);

    return _once(() {
      _state.spyListeners.remove(listener);
    });
  }

  void spyReport(SpyEvent event) {
    if (!isSpyEnabled) {
      return;
    }

    for (var i = 0; i < _state.spyListeners.length; i++) {
      _state.spyListeners[i](event);
    }
  }

  void startBatch() {
    _state.batch++;
  }

  void endBatch() {
    if (--_state.batch == 0) {
      runReactions();
      _runUnobservations();
    }
  }

  void _runUnobservations() {
    if (_state.isRunningUnobservations) return;
    _state.isRunningUnobservations = true;
    final pending = _state.pendingUnobservations;
    var processed = 0;
    try {
      while (processed < pending.length) {
        final ob = pending[processed++].._isPendingUnobservation = false;
        if (ob._observers.isNotEmpty) continue;
        if (ob._isBeingObserved) {
          ob
            .._isBeingObserved = false
            .._notifyOnBecomeUnobserved();
        }
        // A lifecycle callback may have created a replacement subscriber.
        if (ob._observers.isEmpty && ob is Computed) ob._suspend();
      }
    } finally {
      pending.removeRange(0, processed);
      _state.isRunningUnobservations = false;
    }
  }

  void enforceReadPolicy(Atom atom) {
    // ---
    // We are wrapping in an assert() since we don't want this code to execute at runtime.
    // The dart compiler removes assert() calls from the release build.
    // ---
    assert(() {
      switch (config.readPolicy) {
        case ReactiveReadPolicy.always:
          assert(
            _state.isWithinBatch || _state.isWithinDerivation,
            'Observable values cannot be read outside Actions and Reactions. Make sure to wrap them inside an action or a reaction. Tried to read: ${atom.name}',
          );
          break;

        case ReactiveReadPolicy.never:
          break;
      }

      return true;
    }());
  }

  void enforceWritePolicy(Atom atom) {
    // Cannot mutate observables inside a computed. This is required to maintain the consistency of the reactive system.
    if (_state.computationDepth > 0 && atom.hasObservers) {
      throw MobXException(
        'Computed values are not allowed to cause side effects by changing observables that are already being observed. Tried to modify: ${atom.name}',
      );
    }

    // ---
    // We are wrapping in an assert() since we don't want this code to execute at runtime.
    // The dart compiler removes assert() calls from the release build.
    // ---
    assert(() {
      switch (config.writePolicy) {
        case ReactiveWritePolicy.never:
          break;

        case ReactiveWritePolicy.observed:
          if (atom.hasObservers == false) {
            break;
          }

          assert(
            _state.isWithinBatch,
            'Side effects like changing state are not allowed at this point. Please wrap the code in an "action". Tried to modify: ${atom.name}',
          );
          break;

        case ReactiveWritePolicy.always:
          assert(
            _state.isWithinBatch,
            'Changing observable values outside actions is not allowed. Please wrap the code in an "action" if this change is intended. Tried to modify ${atom.name}',
          );
      }

      return true;
    }());
  }

  Derivation? _startTracking(Derivation derivation) {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = derivation;

    _resetDerivationState(derivation);
    derivation
      .._trackingId = ++_nextTrackingId
      .._trackingIndex = 0
      .._newObservables = null;

    return prevDerivation;
  }

  void _endTracking(Derivation currentDerivation, Derivation? prevDerivation) {
    _state.trackingDerivation = prevDerivation;
    _bindDependencies(currentDerivation);
  }

  T? trackDerivation<T>(Derivation d, T Function() fn) {
    final prevDerivation = _startTracking(d);
    T? result;

    try {
      if (config.disableErrorBoundaries == true) {
        result = fn();
      } else {
        try {
          result = fn();
          d._errorValue = null;
        } on Object catch (e, s) {
          d._errorValue = MobXCaughtException(e, stackTrace: s);
        }
      }
    } finally {
      _endTracking(d, prevDerivation);
    }
    return result;
  }

  @protected
  void reportObserved(Atom atom) {
    final derivation = _state.trackingDerivation;

    if (derivation != null) {
      if (atom._lastAccessedBy != derivation._trackingId) {
        atom._lastAccessedBy = derivation._trackingId;
        final newObservables = derivation._newObservables;
        if (newObservables != null) {
          newObservables.add(atom);
        } else {
          final index = derivation._trackingIndex;
          final previous = derivation._observables;
          if (index < previous.length && identical(previous[index], atom)) {
            derivation._trackingIndex = index + 1;
          } else {
            // Stable graphs reuse their dependency array. Only changed order
            // or membership needs a Set and dependency reconciliation.
            derivation._newObservables =
                previous.take(index).toSet()..add(atom);
          }
        }
      }
      if (!atom._isBeingObserved) {
        atom
          .._isBeingObserved = true
          .._notifyOnBecomeObserved();
      }
    }
  }

  void _bindDependencies(Derivation derivation) {
    final previous = derivation._observables;
    var next = derivation._newObservables;
    if (next == null) {
      if (derivation._trackingIndex == previous.length) return;
      next = previous.take(derivation._trackingIndex).toSet();
    }
    final previousSet = previous.isEmpty ? const <Atom>{} : previous.toSet();
    var lowestNewDerivationState = DerivationState.upToDate;

    // Add newly found observables
    for (final observable in next) {
      if (previousSet.contains(observable)) continue;
      observable._addObserver(derivation);

      // Computed = Observable + Derivation
      if (observable is Computed) {
        if (observable._dependenciesState.index >
            lowestNewDerivationState.index) {
          lowestNewDerivationState = observable._dependenciesState;
        }
      }
    }

    // Remove previous observables
    for (final ob in previous) {
      if (!next.contains(ob)) ob._removeObserver(derivation);
    }

    if (lowestNewDerivationState != DerivationState.upToDate) {
      derivation
        .._dependenciesState = lowestNewDerivationState
        .._onBecomeStale();
    }

    derivation
      .._observables = next.toList(growable: false)
      .._newObservables = null;
  }

  void addPendingReaction(Reaction reaction) {
    _state.pendingReactions.add(reaction);
  }

  void runReactions() {
    if (_state.batch > 0 || _state.isRunningReactions) {
      return;
    }

    _runReactionsInternal();
  }

  void _runReactionsInternal() {
    _state.isRunningReactions = true;
    var iterations = 0;
    var current = <Reaction>[];
    var index = 0;
    try {
      while (_state.pendingReactions.isNotEmpty) {
        if (++iterations == config.maxIterations) {
          final failingReaction = _state.pendingReactions[0];
          throw MobXCyclicReactionException(
            "Reaction doesn't converge to a stable state after ${config.maxIterations} iterations. "
            "Probably there is a cycle in the reactive function: $failingReaction "
            "(creation stack: ${failingReaction.debugCreationStack})",
          );
        }
        // Reuse two wave buffers; callbacks enqueue into the other buffer.
        final reusable = current;
        current = _state.pendingReactions;
        _state.pendingReactions = reusable;
        for (index = 0; index < current.length; index++) {
          current[index]._run();
        }
        current.clear();
        index = 0;
      }
    } catch (_) {
      // Queue membership and scheduling flags must be recovered together.
      // Keep the context, spy listeners, IDs, and independent graph intact.
      for (final reaction in current.skip(index)) {
        _resetQueuedReaction(reaction);
      }
      for (final reaction in _state.pendingReactions) {
        _resetQueuedReaction(reaction);
      }
      _state.pendingReactions.clear();
      rethrow;
    } finally {
      _state.isRunningReactions = false;
    }
  }

  void _resetQueuedReaction(Reaction reaction) {
    if (reaction is ReactionImpl) reaction._isScheduled = false;
    _resetDerivationState(reaction);
  }

  void propagateChanged(Atom atom) {
    if (atom._lowestObserverState == DerivationState.stale) {
      return;
    }

    atom._lowestObserverState = DerivationState.stale;

    for (final observer in atom._observers) {
      if (observer._dependenciesState == DerivationState.upToDate) {
        observer._onBecomeStale();
      }
      observer._dependenciesState = DerivationState.stale;
    }
  }

  void _propagatePossiblyChanged(Atom atom) {
    if (atom._lowestObserverState != DerivationState.upToDate) {
      return;
    }

    atom._lowestObserverState = DerivationState.possiblyStale;

    for (final observer in atom._observers) {
      if (observer._dependenciesState == DerivationState.upToDate) {
        observer
          .._dependenciesState = DerivationState.possiblyStale
          .._onBecomeStale();
      }
    }
  }

  void _propagateChangeConfirmed(Atom atom) {
    if (atom._lowestObserverState == DerivationState.stale) {
      return;
    }

    atom._lowestObserverState = DerivationState.stale;

    for (final observer in atom._observers) {
      if (observer._dependenciesState == DerivationState.possiblyStale) {
        observer._dependenciesState = DerivationState.stale;
      } else if (observer._dependenciesState == DerivationState.upToDate) {
        atom._lowestObserverState = DerivationState.upToDate;
      }
    }
  }

  @protected
  void clearObservables(Derivation derivation) {
    final observables = derivation._observables;
    derivation._observables = const [];

    for (final x in observables) {
      x._removeObserver(derivation);
    }

    derivation._dependenciesState = DerivationState.notTracking;
  }

  void _enqueueForUnobservation(Atom atom) {
    if (atom._isPendingUnobservation) {
      return;
    }

    atom._isPendingUnobservation = true;
    _state.pendingUnobservations.add(atom);
  }

  void _resetDerivationState(Derivation d) {
    if (d._dependenciesState == DerivationState.upToDate) {
      return;
    }

    d._dependenciesState = DerivationState.upToDate;
    for (final obs in d._observables) {
      obs._lowestObserverState = DerivationState.upToDate;
    }
  }

  bool _shouldCompute(Derivation derivation) {
    switch (derivation._dependenciesState) {
      case DerivationState.upToDate:
        return false;

      case DerivationState.notTracking:
      case DerivationState.stale:
        return true;

      case DerivationState.possiblyStale:
        return untracked(() {
          for (final obs in derivation._observables) {
            if (obs is Computed) {
              // Force a computation
              if (config.disableErrorBoundaries == true) {
                obs.value;
              } else {
                try {
                  obs.value;
                } on Object catch (_) {
                  return true;
                }
              }

              if (derivation._dependenciesState == DerivationState.stale) {
                return true;
              }
            }
          }

          _resetDerivationState(derivation);
          return false;
        });
    }
  }

  bool _hasCaughtException(Derivation d) =>
      d._errorValue is MobXCaughtException;

  bool isComputingDerivation() => _state.trackingDerivation != null;

  Derivation? startUntracked() {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = null;
    return prevDerivation;
  }

  // ignore: use_setters_to_change_properties
  void endUntracked(Derivation? prevDerivation) {
    _state.trackingDerivation = prevDerivation;
  }

  T untracked<T>(T Function() fn) {
    final prevDerivation = startUntracked();
    try {
      return fn();
    } finally {
      endUntracked(prevDerivation);
    }
  }

  Dispose onReactionError(ReactionErrorHandler handler) {
    _reactionErrorHandlers.add(handler);
    return () {
      _reactionErrorHandlers.remove(handler);
    };
  }

  void _notifyReactionErrorHandlers(Object exception, Reaction reaction) {
    // ignore: avoid_function_literals_in_foreach_calls
    _reactionErrorHandlers.toList(growable: false).forEach((f) {
      f(exception, reaction);
    });
  }

  bool startAllowStateChanges({bool allow = true}) {
    final prevValue = _state.allowStateChanges;
    _state.allowStateChanges = allow;

    return prevValue;
  }

  void endAllowStateChanges({bool allow = true}) {
    _state.allowStateChanges = allow;
  }

  @protected
  void pushComputation() {
    _state.computationDepth++;
  }

  @protected
  void popComputation() {
    _state.computationDepth--;
  }
}
