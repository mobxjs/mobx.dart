part of '../core.dart';

class _ReactiveState {
  int batch = 0;

  int nextIdCounter = 0;

  Derivation trackingDerivation;
  List<Reaction> pendingReactions = [];
  bool isRunningReactions = false;
  List<Atom> pendingUnobservations = [];
}

class ReactiveContext {
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
          ..isPendingUnobservation = false;

        if (ob.observers.isEmpty) {
          if (ob.isBeingObserved) {
            // if this observable had reactive observers, trigger the hooks
            ob
              ..isBeingObserved = false
              ..notifyOnBecomeUnobserved();
          }

          if (ob is ComputedValue) {
            ob.suspend();
          }
        }
      }

      _state.pendingUnobservations = [];
    }
  }

  Derivation startTracking(Derivation derivation) {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = derivation;

    resetDerivationState(derivation);
    derivation._newObservables = Set();

    return prevDerivation;
  }

  void endTracking(Derivation currentDerivation, Derivation prevDerivation) {
    _state.trackingDerivation = prevDerivation;
    bindDependencies(currentDerivation);
  }

  T trackDerivation<T>(Derivation d, T Function() fn) {
    final prevDerivation = startTracking(d);
    final result = fn();
    endTracking(d, prevDerivation);
    return result;
  }

  void reportObserved(Atom atom) {
    final derivation = _state.trackingDerivation;

    if (derivation != null) {
      derivation._newObservables.add(atom);
      if (!atom.isBeingObserved) {
        atom
          ..isBeingObserved = true
          ..notifyOnBecomeObserved();
      }
    }
  }

  void bindDependencies(Derivation derivation) {
    final staleObservables =
        derivation._observables.difference(derivation._newObservables);
    final newObservables =
        derivation._newObservables.difference(derivation._observables);
    var lowestNewDerivationState = DerivationState.upToDate;

    // Add newly found observables
    for (final observable in newObservables) {
      observable.addObserver(derivation);

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
      ob.removeObserver(derivation);
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
    if (atom.lowestObserverState == DerivationState.stale) {
      return;
    }

    atom.lowestObserverState = DerivationState.stale;

    for (final observer in atom.observers) {
      if (observer._dependenciesState == DerivationState.upToDate) {
        observer._onBecomeStale();
      }
      observer._dependenciesState = DerivationState.stale;
    }
  }

  void propagatePossiblyChanged(Atom atom) {
    if (atom.lowestObserverState != DerivationState.upToDate) {
      return;
    }

    atom.lowestObserverState = DerivationState.possiblyStale;

    for (final observer in atom.observers) {
      if (observer._dependenciesState == DerivationState.upToDate) {
        observer
          .._dependenciesState = DerivationState.possiblyStale
          .._onBecomeStale();
      }
    }
  }

  void propagateChangeConfirmed(Atom atom) {
    if (atom.lowestObserverState == DerivationState.stale) {
      return;
    }

    atom.lowestObserverState = DerivationState.stale;

    for (final observer in atom.observers) {
      if (observer._dependenciesState == DerivationState.possiblyStale) {
        observer._dependenciesState = DerivationState.stale;
      } else if (observer._dependenciesState == DerivationState.upToDate) {
        atom.lowestObserverState = DerivationState.upToDate;
      }
    }
  }

  void clearObservables(Derivation derivation) {
    final observables = derivation._observables;
    derivation._observables = Set();

    for (final x in observables) {
      x.removeObserver(derivation);
    }

    derivation._dependenciesState = DerivationState.notTracking;
  }

  void enqueueForUnobservation(Atom atom) {
    if (atom.isPendingUnobservation) {
      return;
    }

    atom.isPendingUnobservation = true;
    _state.pendingUnobservations.add(atom);
  }

  void resetDerivationState(Derivation d) {
    if (d._dependenciesState == DerivationState.upToDate) {
      return;
    }

    d._dependenciesState = DerivationState.upToDate;
    for (final obs in d._observables) {
      obs.lowestObserverState = DerivationState.upToDate;
    }
  }

  bool shouldCompute(Derivation derivation) {
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
              obs.value;

              if (derivation._dependenciesState == DerivationState.stale) {
                return true;
              }
            }
          }

          resetDerivationState(derivation);
          return false;
        });
    }

    return false;
  }

  bool isInBatch() => _state.batch > 0;

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
}

class MobXException implements Exception {
  MobXException(this.message);

  String message;
}
