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

  final Set<ReactionErrorHandler> _reactionErrorHandlers = {};

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

  _ReactiveState _state = _ReactiveState();

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

      for (var i = 0; i < _state.pendingUnobservations.length; i++) {
        final ob =
            _state.pendingUnobservations[i].._isPendingUnobservation = false;

        if (ob._observers.isEmpty) {
          if (ob._isBeingObserved) {
            // if this observable had reactive observers, trigger the hooks
            ob
              .._isBeingObserved = false
              .._notifyOnBecomeUnobserved();
          }

          if (ob is Computed) {
            ob._suspend();
          }
        }
      }

      _state.pendingUnobservations = [];
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
    derivation._newObservables = {};

    return prevDerivation;
  }

  void _endTracking(Derivation currentDerivation, Derivation? prevDerivation) {
    _state.trackingDerivation = prevDerivation;
    _bindDependencies(currentDerivation);
  }

  T? trackDerivation<T>(Derivation d, T Function() fn) {
    final prevDerivation = _startTracking(d);
    T? result;

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

    _endTracking(d, prevDerivation);
    return result;
  }

  @protected
  void reportObserved(Atom atom) {
    final derivation = _state.trackingDerivation;

    if (derivation != null) {
      derivation._newObservables!.add(atom);
      if (!atom._isBeingObserved) {
        atom
          .._isBeingObserved = true
          .._notifyOnBecomeObserved();
      }
    }
  }

  void _bindDependencies(Derivation derivation) {
    final staleObservables = derivation._observables.difference(
      derivation._newObservables!,
    );
    final newObservables = derivation._newObservables!.difference(
      derivation._observables,
    );
    var lowestNewDerivationState = DerivationState.upToDate;

    // Add newly found observables
    for (final observable in newObservables) {
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
    for (final ob in staleObservables) {
      ob._removeObserver(derivation);
    }

    if (lowestNewDerivationState != DerivationState.upToDate) {
      derivation
        .._dependenciesState = lowestNewDerivationState
        .._onBecomeStale();
    }

    derivation
      .._observables = derivation._newObservables!
      .._newObservables = {}; // No need for newObservables beyond this point
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
    final allReactions = _state.pendingReactions;

    // While running reactions, new reactions might be triggered.
    // Hence we work with two variables and check whether
    // we converge to no remaining reactions after a while.
    while (allReactions.isNotEmpty) {
      if (++iterations == config.maxIterations) {
        final failingReaction = allReactions[0];

        // Resetting ensures we have no bad-state left
        _resetState();

        throw MobXCyclicReactionException(
          "Reaction doesn't converge to a stable state after ${config.maxIterations} iterations. "
          "Probably there is a cycle in the reactive function: $failingReaction "
          "(creation stack: ${failingReaction.debugCreationStack})",
        );
      }

      final remainingReactions = allReactions.toList(growable: false);
      allReactions.clear();
      for (final reaction in remainingReactions) {
        reaction._run();
      }
    }

    _state
      ..pendingReactions = []
      ..isRunningReactions = false;
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
    derivation._observables = {};

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
    config._reactionErrorHandlers.add(handler);
    return () {
      config._reactionErrorHandlers.removeWhere((f) => f == handler);
    };
  }

  void _notifyReactionErrorHandlers(Object exception, Reaction reaction) {
    // ignore: avoid_function_literals_in_foreach_calls
    config._reactionErrorHandlers.forEach((f) {
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

  void _resetState() {
    _state =
        _ReactiveState()
          ..allowStateChanges =
              _config.writePolicy == ReactiveWritePolicy.never;
  }
}
