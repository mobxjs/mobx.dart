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

enum DerivationState {
  // before being run or (outside batch and not being observed)
  // at this point derivation is not holding any data about dependency tree
  NOT_TRACKING,

  // no shallow dependency changed since last computation
  // won't recalculate derivation
  // this is what makes mobx fast
  UP_TO_DATE,

  // some deep dependency changed, but don't know if shallow dependency changed
  // will require to check first if UP_TO_DATE or POSSIBLY_STALE
  // currently only ComputedValue will propagate POSSIBLY_STALE
  //
  // having this state is second big optimization:
  // don't have to recompute on every dependency change, but only when it's needed
  POSSIBLY_STALE,

  // A shallow dependency has changed since last computation and the derivation
  // will need to recompute when it's needed next.
  STALE
}

abstract class Derivation {
  String name;
  Set<Atom> observables;
  Set<Atom> newObservables;

  DerivationState dependenciesState;

  onBecomeStale() {}
  suspend() {}
}

class WillChangeNotification<T> {
  /// One of add | update | delete
  String type;

  T newValue;
  dynamic object;

  static WillChangeNotification UNCHANGED = WillChangeNotification();

  WillChangeNotification({this.type, this.newValue, this.object});
}

class ChangeNotification<T> {
  /// One of add | update | delete
  String type;

  T oldValue;
  T newValue;

  dynamic object;

  ChangeNotification({this.type, this.newValue, this.oldValue, this.object});
}

var global = GlobalState();
