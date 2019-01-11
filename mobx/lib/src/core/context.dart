part of '../core.dart';

class _ReactiveState {
  int batch = 0;

  int nextIdCounter = 0;

  Derivation trackingDerivation;
  List<Reaction> pendingReactions = [];
  bool isRunningReactions = false;
  List<Atom> pendingUnobservations = [];
}

typedef ReactionErrorHandler = void Function(Object error);

/// Configuration used by [ReactiveContext]
class ReactiveConfig {
  ReactiveConfig({this.disableErrorBoundaries});

  /// The main or default configuration used by [ReactiveContext]
  static final ReactiveConfig main =
      ReactiveConfig(disableErrorBoundaries: false);

  /// Whether MobX should throw exceptions instead of catching them and storing
  /// inside the [Reaction.errorValue] property of [Reaction].
  bool disableErrorBoundaries = false;

  final Set<ReactionErrorHandler> _reactionErrorHandlers = Set();
}

class ReactiveContext {
  ReactiveContext({ReactiveConfig config}) {
    this.config = config ?? ReactiveConfig.main;
  }

  ReactiveConfig config;

  final _ReactiveState _state = _ReactiveState();

  int get nextId => ++_state.nextIdCounter;

  String nameFor(String prefix) {
    assert(prefix != null);
    assert(prefix.isNotEmpty);
    return '$prefix@$nextId';
  }

  void startBatch() {
    _state.batch++;
  }

  void endBatch() {
    if (--_state.batch == 0) {
      runReactions();

      for (var i = 0; i < _state.pendingUnobservations.length; i++) {
        final ob = _state.pendingUnobservations[i]
          .._isPendingUnobservation = false;

        if (ob._observers.isEmpty) {
          if (ob._isBeingObserved) {
            // if this observable had reactive observers, trigger the hooks
            ob
              .._isBeingObserved = false
              .._notifyOnBecomeUnobserved();
          }

          if (ob is ComputedValue) {
            ob._suspend();
          }
        }
      }

      _state.pendingUnobservations = [];
    }
  }

  Derivation _startTracking(Derivation derivation) {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = derivation;

    _resetDerivationState(derivation);
    derivation._newObservables = Set();

    return prevDerivation;
  }

  void _endTracking(Derivation currentDerivation, Derivation prevDerivation) {
    _state.trackingDerivation = prevDerivation;
    _bindDependencies(currentDerivation);
  }

  T trackDerivation<T>(Derivation d, T Function() fn) {
    final prevDerivation = _startTracking(d);
    T result;

    if (config.disableErrorBoundaries == true) {
      result = fn();
    } else {
      try {
        result = fn();
        d._errorValue = null;
      } on Object catch (e) {
        d._errorValue = MobXCaughtException(e);
      }
    }

    _endTracking(d, prevDerivation);
    return result;
  }

  void _reportObserved(Atom atom) {
    final derivation = _state.trackingDerivation;

    if (derivation != null) {
      derivation._newObservables.add(atom);
      if (!atom._isBeingObserved) {
        atom
          .._isBeingObserved = true
          .._notifyOnBecomeObserved();
      }
    }
  }

  void _bindDependencies(Derivation derivation) {
    final staleObservables =
        derivation._observables.difference(derivation._newObservables);
    final newObservables =
        derivation._newObservables.difference(derivation._observables);
    var lowestNewDerivationState = DerivationState.upToDate;

    // Add newly found observables
    for (final observable in newObservables) {
      observable._addObserver(derivation);

      // ComputedValue = ObservableValue + Derivation
      if (observable is ComputedValue) {
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
      .._observables = derivation._newObservables
      .._newObservables = Set(); // No need for newObservables beyond this point
  }

  void addPendingReaction(Reaction reaction) {
    _state.pendingReactions.add(reaction);
  }

  void runReactions() {
    if (_state.batch > 0 || _state.isRunningReactions) {
      return;
    }

    _state.isRunningReactions = true;

    for (final reaction in _state.pendingReactions) {
      reaction.run();
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

  void _clearObservables(Derivation derivation) {
    final observables = derivation._observables;
    derivation._observables = Set();

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
            if (obs is ComputedValue) {
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

    return false;
  }

  bool _isInBatch() => _state.batch > 0;
  bool _isCaughtException(Derivation d) => d._errorValue is MobXCaughtException;

  bool isComputingDerivation() => _state.trackingDerivation != null;

  Derivation untrackedStart() {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = null;
    return prevDerivation;
  }

  // ignore: use_setters_to_change_properties
  void untrackedEnd(Derivation prevDerivation) {
    _state.trackingDerivation = prevDerivation;
  }

  T untracked<T>(T Function() action) {
    final prevDerivation = untrackedStart();
    try {
      return action();
    } finally {
      untrackedEnd(prevDerivation);
    }
  }

  Dispose onReactionError(ReactionErrorHandler handler) {
    config._reactionErrorHandlers.add(handler);
    return () {
      config._reactionErrorHandlers.removeWhere((f) => f == handler);
    };
  }

  void _notifyReactionErrorHandlers(Object exception) {
    // ignore: avoid_function_literals_in_foreach_calls
    config._reactionErrorHandlers.forEach((f) {
      f(exception);
    });
  }
}
