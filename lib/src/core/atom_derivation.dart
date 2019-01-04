import 'package:mobx/src/core/context.dart';

enum _ListenerKind {
  onBecomeObserved,
  onBecomeUnobserved,
}

class Atom {
  Atom(this.name, {Function onObserve, Function onUnobserve}) {
    if (onObserve != null) {
      onBecomeObserved(onObserve);
    }

    if (onUnobserve != null) {
      onBecomeUnobserved(onUnobserve);
    }
  }

  String name;

  bool isPendingUnobservation = false;

  DerivationState lowestObserverState = DerivationState.notTracking;

  bool isBeingObserved = false;

  Set<Derivation> observers = Set();

  final Map<_ListenerKind, Set<Function()>> _observationListeners = {};

  void reportObserved() {
    ctx.reportObserved(this);
  }

  void reportChanged() {
    ctx
      ..startBatch()
      ..propagateChanged(this)
      ..endBatch();
  }

  void addObserver(Derivation d) {
    observers.add(d);

    if (lowestObserverState.index > d.dependenciesState.index) {
      lowestObserverState = d.dependenciesState;
    }
  }

  void removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
    if (observers.isEmpty) {
      ctx.enqueueForUnobservation(this);
    }
  }

  void notifyOnBecomeObserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeObserved];
    listeners?.forEach(_notifyListener);
  }

  static void _notifyListener(Function() listener) => listener();

  void notifyOnBecomeUnobserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeUnobserved];
    listeners?.forEach(_notifyListener);
  }

  void Function() onBecomeObserved(Function fn) =>
      _addListener(_ListenerKind.onBecomeObserved, fn);

  void Function() onBecomeUnobserved(Function fn) =>
      _addListener(_ListenerKind.onBecomeUnobserved, fn);

  void Function() _addListener(_ListenerKind kind, Function fn) {
    if (fn == null) {
      throw MobXException('$kind handler cannot be null');
    }

    if (_observationListeners[kind] == null) {
      _observationListeners[kind] = Set()..add(fn);
    } else {
      _observationListeners[kind].add(fn);
    }

    return () {
      if (_observationListeners[kind] == null) {
        return;
      }

      _observationListeners[kind].removeWhere((f) => f == fn);
      if (_observationListeners[kind].isEmpty) {
        _observationListeners[kind] = null;
      }
    };
  }
}

enum DerivationState {
  // before being run or (outside batch and not being observed)
  // at this point derivation is not holding any data about dependency tree
  notTracking,

  // no shallow dependency changed since last computation
  // won't recalculate derivation
  // this is what makes mobx fast
  upToDate,

  // some deep dependency changed, but don't know if shallow dependency changed
  // will require to check first if UP_TO_DATE or POSSIBLY_STALE
  // currently only ComputedValue will propagate POSSIBLY_STALE
  //
  // having this state is second big optimization:
  // don't have to recompute on every dependency change, but only when it's needed
  possiblyStale,

  // A shallow dependency has changed since last computation and the derivation
  // will need to recompute when it's needed next.
  stale
}

abstract class Derivation {
  String name;
  Set<Atom> observables;
  Set<Atom> newObservables;

  DerivationState dependenciesState;

  void onBecomeStale();
  void suspend();
}

class WillChangeNotification<T> {
  WillChangeNotification({this.type, this.newValue, this.object});

  /// One of add | update | delete
  String type;

  T newValue;
  dynamic object;

  static WillChangeNotification unchanged = WillChangeNotification();
}

class ChangeNotification<T> {
  ChangeNotification({this.type, this.newValue, this.oldValue, this.object});

  /// One of add | update | delete
  String type;

  T oldValue;
  T newValue;

  dynamic object;
}

class MobXException implements Exception {
  MobXException(this.message);

  String message;
}

final ReactiveContext ctx = ReactiveContext();
