import 'package:mobx/src/observable.dart';
import 'package:mobx/src/reaction.dart';

class _GlobalState {
  int _batch = 0;

  static int _nextIdCounter = 0;

  Derivation trackingDerivation;
  List<Reaction> _pendingReactions = [];
  bool _isRunningReactions = false;
  List<Atom> _pendingUnobservations = [];

  get nextId => ++_nextIdCounter;

  startBatch() {
    _batch++;
  }

  trackDerivation(Derivation d) {
    var prevDerivation = trackingDerivation;
    trackingDerivation = d;

    resetDerivationState(d);
    d.onBecomeStale();

    trackingDerivation = prevDerivation;
    bindDependencies(d);
  }

  reportObserved(Atom atom) {
    var derivation = trackingDerivation;

    if (derivation != null) {
      derivation.newObservables.add(atom);
    }
  }

  endBatch() {
    if (--_batch == 0) {
      runReactions();

      for (var ob in _pendingUnobservations) {
        ob.isPendingUnobservation = false;
      }

      _pendingUnobservations.clear();
    }
  }

  resetDerivationState(Derivation d) {
    d.newObservables = Set();
  }

  bindDependencies(Derivation d) {
    var oldObservables = d.observables.intersection(d.newObservables);
    var staleObservables = d.observables.difference(d.newObservables);
    var newObservables = d.newObservables.difference(d.observables);

    for (var ob in staleObservables) {
      ob.removeObserver(d);
    }

    for (var ob in newObservables) {
      ob.addObserver(d);
    }

    d.observables = oldObservables.union(newObservables);
  }

  enqueueReaction(Reaction reaction) {
    _pendingReactions.add(reaction);
  }

  runReactions() {
    if (_batch > 0 || _isRunningReactions) {
      return;
    }

    _isRunningReactions = true;

    var allReactions = _pendingReactions.toList(growable: false);
    for (var reaction in allReactions) {
      reaction.run();
    }

    _isRunningReactions = false;
  }

  propagateChanged(Atom atom) {
    for (var observer in atom.observers) {
      observer.onBecomeStale();
    }
  }

  clearObservables(Derivation derivation) {
    var observables = derivation.observables;
    derivation.observables = Set();

    for (var x in observables) {
      x.removeObserver(derivation);
    }
  }

  void enqueueForUnobservation(Atom atom) {
    if (atom.isPendingUnobservation) {
      return;
    }

    atom.isPendingUnobservation = true;
    _pendingUnobservations.add(atom);
  }
}

var global = _GlobalState();
