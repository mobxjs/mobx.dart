import 'package:mobx/src/core/global_state.dart';

class Atom {
  String name;

  bool isPendingUnobservation = false;

  DerivationState lowestObserverState = DerivationState.NOT_TRACKING;

  Atom(String this.name);

  Set<Derivation> observers = Set();

  reportObserved() {
    global.reportObserved(this);
  }

  reportChanged() {
    global.startBatch();
    global.propagateChanged(this);
    global.endBatch();
  }

  addObserver(Derivation d) {
    observers.add(d);

    if (lowestObserverState.index > d.dependenciesState.index) {
      lowestObserverState = d.dependenciesState;
    }
  }

  removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
    if (observers.isEmpty) {
      global.enqueueForUnobservation(this);
    }
  }
}

enum DerivationState { NOT_TRACKING, UP_TO_DATE, POSSIBLY_STALE, STALE }

abstract class Derivation {
  String name;
  Set<Atom> observables;
  Set<Atom> newObservables;
  DerivationState dependenciesState;

  bool get isAComputedValue;

  void onBecomeStale() {}
}

var global = GlobalState();
