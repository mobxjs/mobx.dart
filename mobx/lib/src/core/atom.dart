part of '../core.dart';

enum _ListenerKind {
  onBecomeObserved,
  onBecomeUnobserved,
}

class Atom {
  Atom(this._context, {String name, Function onObserve, Function onUnobserve})
      : name = name ?? _context.nameFor('Atom') {
    if (onObserve != null) {
      onBecomeObserved(onObserve);
    }

    if (onUnobserve != null) {
      onBecomeUnobserved(onUnobserve);
    }
  }

  final ReactiveContext _context;

  final String name;

  // ignore: prefer_final_fields
  bool _isPendingUnobservation = false;

  DerivationState _lowestObserverState = DerivationState.notTracking;

  // ignore: prefer_final_fields
  bool _isBeingObserved = false;
  bool get isBeingObserved => _isBeingObserved;

  final Set<Derivation> _observers = Set();

  final Map<_ListenerKind, Set<Function()>> _observationListeners = {};

  void reportObserved() {
    _context._reportObserved(this);
  }

  void reportChanged() {
    _context
      ..startBatch()
      ..propagateChanged(this)
      ..endBatch();
  }

  void _addObserver(Derivation d) {
    _observers.add(d);

    if (_lowestObserverState.index > d._dependenciesState.index) {
      _lowestObserverState = d._dependenciesState;
    }
  }

  void _removeObserver(Derivation d) {
    _observers.removeWhere((ob) => ob == d);
    if (_observers.isEmpty) {
      _context._enqueueForUnobservation(this);
    }
  }

  void _notifyOnBecomeObserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeObserved];
    listeners?.forEach(_notifyListener);
  }

  static void _notifyListener(Function() listener) => listener();

  void _notifyOnBecomeUnobserved() {
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

class WillChangeNotification<T> {
  WillChangeNotification({this.type, this.newValue, this.object});

  /// One of add | update | delete
  final OperationType type;

  T newValue;
  final dynamic object;

  static WillChangeNotification unchanged = WillChangeNotification();
}

enum OperationType { add, update, delete }

class ChangeNotification<T> {
  ChangeNotification({this.type, this.newValue, this.oldValue, this.object});

  /// One of add | update | delete
  final OperationType type;

  final T oldValue;
  T newValue;

  dynamic object;
}
