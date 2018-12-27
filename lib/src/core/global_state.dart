import 'package:mobx/src/core/action.dart';
import 'package:mobx/src/core/base_types.dart';
import 'package:mobx/src/core/reaction.dart';

class GlobalState {
  int _batch = 0;

  static int _nextIdCounter = 0;

  Derivation _trackingDerivation;
  List<Reaction> _pendingReactions = [];
  bool _isRunningReactions = false;
  List<Atom> _pendingUnobservations = [];

  int computationDepth = 0;

  get nextId => ++_nextIdCounter;

  startBatch() {
    _batch++;
  }

  T trackDerivation<T>(Derivation d, T Function() fn) {
    var prevDerivation = _trackingDerivation;
    _trackingDerivation = d;

    resetDerivationState(d);
    d.newObservables = Set();

    var result = fn();

    _trackingDerivation = prevDerivation;
    bindDependencies(d);

    return result;
  }

  reportObserved(Atom atom) {
    var derivation = _trackingDerivation;

    if (derivation != null) {
      derivation.newObservables.add(atom);
    }
  }

  endBatch() {
    if (--_batch == 0) {
      runReactions();

      for (var i = 0; i < _pendingUnobservations.length; i++) {
        var ob = _pendingUnobservations[i];
        ob.isPendingUnobservation = false;

        if (ob.observers.isEmpty) {
          if (ob is Derivation) {
            // An Atom that is also a Derivation is a ComputedValue
            (ob as Derivation).suspend();
          }
        }
      }

      _pendingUnobservations = [];
    }
  }

  bindDependencies(Derivation d) {
    var staleObservables = d.observables.difference(d.newObservables);
    var newObservables = d.newObservables.difference(d.observables);
    var lowestNewDerivationState = DerivationState.UP_TO_DATE;

    // Add newly found observables
    for (var observable in newObservables) {
      observable.addObserver(d);

      // ComputedValue = ObservableValue + Derivation
      if (observable is Derivation) {
        var drv = observable as Derivation;
        if (drv.dependenciesState.index > lowestNewDerivationState.index) {
          lowestNewDerivationState = drv.dependenciesState;
        }
      }
    }

    // Remove previous observables
    for (var ob in staleObservables) {
      ob.removeObserver(d);
    }

    if (lowestNewDerivationState != DerivationState.UP_TO_DATE) {
      d.dependenciesState = lowestNewDerivationState;
      d.onBecomeStale();
    }

    d.observables = d.newObservables;
    d.newObservables = Set(); // No need for newObservables beyond this point
  }

  addPendingReaction(Reaction reaction) {
    _pendingReactions.add(reaction);
  }

  runReactions() {
    if (_batch > 0 || _isRunningReactions) {
      return;
    }

    _isRunningReactions = true;

    for (var reaction in _pendingReactions) {
      reaction.run();
    }

    _pendingReactions = [];
    _isRunningReactions = false;
  }

  propagateChanged(Atom atom) {
    if (atom.lowestObserverState == DerivationState.STALE) {
      return;
    }

    atom.lowestObserverState = DerivationState.STALE;

    for (var observer in atom.observers) {
      if (observer.dependenciesState == DerivationState.UP_TO_DATE) {
        observer.onBecomeStale();
      }
      observer.dependenciesState = DerivationState.STALE;
    }
  }

  void propagatePossiblyChanged(Atom atom) {
    if (atom.lowestObserverState != DerivationState.UP_TO_DATE) {
      return;
    }

    atom.lowestObserverState = DerivationState.POSSIBLY_STALE;

    for (var observer in atom.observers) {
      if (observer.dependenciesState == DerivationState.UP_TO_DATE) {
        observer.dependenciesState = DerivationState.POSSIBLY_STALE;
        observer.onBecomeStale();
      }
    }
  }

  void propagateChangeConfirmed(Atom atom) {
    if (atom.lowestObserverState == DerivationState.STALE) {
      return;
    }

    atom.lowestObserverState = DerivationState.STALE;

    for (var observer in atom.observers) {
      if (observer.dependenciesState == DerivationState.POSSIBLY_STALE) {
        observer.dependenciesState = DerivationState.STALE;
      } else if (observer.dependenciesState == DerivationState.UP_TO_DATE) {
        atom.lowestObserverState = DerivationState.UP_TO_DATE;
      }
    }
  }

  clearObservables(Derivation derivation) {
    var observables = derivation.observables;
    derivation.observables = Set();

    for (var x in observables) {
      x.removeObserver(derivation);
    }

    derivation.dependenciesState = DerivationState.NOT_TRACKING;
  }

  void enqueueForUnobservation(Atom atom) {
    if (atom.isPendingUnobservation) {
      return;
    }

    atom.isPendingUnobservation = true;
    _pendingUnobservations.add(atom);
  }

  resetDerivationState(Derivation d) {
    if (d.dependenciesState == DerivationState.UP_TO_DATE) {
      return;
    }

    d.dependenciesState = DerivationState.UP_TO_DATE;
    for (var obs in d.observables) {
      obs.lowestObserverState = DerivationState.UP_TO_DATE;
    }
  }

  bool shouldCompute(Derivation derivation) {
    switch (derivation.dependenciesState) {
      case DerivationState.UP_TO_DATE:
        return false;

      case DerivationState.NOT_TRACKING:
      case DerivationState.STALE:
        return true;

      case DerivationState.POSSIBLY_STALE:
        return untracked(() {
          for (var obs in derivation.observables) {
            if (_isComputedValue(obs)) {
              // Force a computation
              // Must work without any type-errors as we are dealing with a ComputedValue<T>
              (obs as dynamic).value;

              if (derivation.dependenciesState == DerivationState.STALE) {
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

  bool isInBatch() {
    return _batch > 0;
  }

  bool isComputingDerivation() {
    return _trackingDerivation != null;
  }

  untrackedStart() {
    var prevDerivation = _trackingDerivation;
    _trackingDerivation = null;
    return prevDerivation;
  }

  untrackedEnd(Derivation prevDerivation) {
    _trackingDerivation = prevDerivation;
  }

  bool _isComputedValue(dynamic obj) {
    if (obj is Derivation) {
      return obj.isAComputedValue;
    }

    return false;
  }
}
