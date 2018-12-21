import 'package:mobx/mobx.dart';

class _GlobalState {
  int _batch = 0;
  Derivation currentDerivation;

  startBatch() {
    _batch++;
  }

  trackDerivation(Derivation d) {
    var prevDerivation = currentDerivation;
    currentDerivation = d;

    resetDerivationState(d);
    d.execute();

    currentDerivation = prevDerivation;
    bindDependencies(d);
  }

  reportObserved(Atom atom) {
    var derivation = currentDerivation;

    if (derivation != null) {
      derivation.newObserving.add(atom);
    }
  }

  endBatch() {
    if (--_batch == 0) {
      _runReactions();
    }
  }

  resetDerivationState(Derivation d) {
    d.newObserving = Set();
  }

  bindDependencies(Derivation d) {
    var oldObservables = d.observing.intersection(d.newObserving);
    var staleObservables = d.observing.difference(d.newObserving);
    var newObservables = d.newObserving.difference(d.observing);

    for (var ob in staleObservables) {
      ob.removeObserver(d);
    }

    for (var ob in newObservables) {
      ob.addObserver(d);
    }

    d.observing = oldObservables.union(newObservables);
  }

  _runReactions() {}
}

var global = _GlobalState();
