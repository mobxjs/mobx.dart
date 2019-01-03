import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/utils.dart';

const ON_BECOME_OBSERVED = 'onBecomeObserved';
const ON_BECOME_UNOBSERVED = 'onBecomeUnobserved';

class Atom {
  String name;

  bool isPendingUnobservation = false;

  DerivationState lowestObserverState = DerivationState.NOT_TRACKING;

  bool isBeingObserved = false;

  Atom(String this.name, {Function onObserve, Function onUnobserve}) {
    if (onObserve != null) {
      onBecomeObserved(onObserve);
    }

    if (onUnobserve != null) {
      onBecomeUnobserved(onUnobserve);
    }
  }

  Set<Derivation> observers = Set();

  var _observationListeners = Map<String, Set<Function>>();

  reportObserved() {
    ctx.reportObserved(this);
  }

  reportChanged() {
    ctx.startBatch();
    ctx.propagateChanged(this);
    ctx.endBatch();
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
      ctx.enqueueForUnobservation(this);
    }
  }

  notifyOnBecomeObserved() {
    if (_observationListeners[ON_BECOME_OBSERVED] != null) {
      _observationListeners[ON_BECOME_OBSERVED]
          .forEach((listener) => listener());
    }
  }

  notifyOnBecomeUnobserved() {
    if (_observationListeners[ON_BECOME_UNOBSERVED] != null) {
      _observationListeners[ON_BECOME_UNOBSERVED]
          .forEach((listener) => listener());
    }
  }

  void Function() onBecomeObserved(Function fn) {
    return _addListener(ON_BECOME_OBSERVED, fn);
  }

  void Function() onBecomeUnobserved(Function fn) {
    return _addListener(ON_BECOME_UNOBSERVED, fn);
  }

  void Function() _addListener(String key, Function fn) {
    if (fn == null) {
      throw MobXException('${key} handler cannot be null');
    }

    if (_observationListeners[key] == null) {
      _observationListeners[key] = Set()..add(fn);
    } else {
      _observationListeners[key].add(fn);
    }

    return () {
      if (_observationListeners[key] == null) {
        return;
      }

      _observationListeners[key].removeWhere((f) => f == fn);
      if (_observationListeners[key].isEmpty) {
        _observationListeners[key] = null;
      }
    };
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

  onBecomeStale();
  suspend();
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

class MobXException implements Exception {
  String message;
  MobXException(this.message);
}

var ctx = ReactiveContext();
