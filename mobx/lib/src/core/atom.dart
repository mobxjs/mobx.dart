part of '../core.dart';

enum _ListenerKind { onBecomeObserved, onBecomeUnobserved }

class Atom with DebugCreationStack {
  /// Creates a simple Atom for tracking its usage in a reactive context. This is useful when
  /// you don't need the value but instead a way of knowing when it becomes active and inactive
  /// in a reaction.
  ///
  /// Use the [onObserved] and [onUnobserved] handlers to know when the atom is active and inactive
  /// respectively. Use a debug [name] to identify easily.
  factory Atom({
    String? name,
    Function()? onObserved,
    Function()? onUnobserved,
    ReactiveContext? context,
  }) => Atom._(
    context ?? mainContext,
    name: name,
    onObserved: onObserved,
    onUnobserved: onUnobserved,
  );

  Atom._(
    this._context, {
    String? name,
    Function()? onObserved,
    Function()? onUnobserved,
  }) : name = name ?? _context.nameFor('Atom') {
    if (onObserved != null) {
      onBecomeObserved(onObserved);
    }

    if (onUnobserved != null) {
      onBecomeUnobserved(onUnobserved);
    }
  }

  final ReactiveContext _context;
  ReactiveContext get context => _context;

  final String name;

  // ignore: prefer_final_fields
  bool _isPendingUnobservation = false;

  DerivationState _lowestObserverState = DerivationState.notTracking;

  bool get isBeingObserved => _isBeingObserved;

  // ignore: prefer_final_fields
  bool _isBeingObserved = false;

  final Set<Derivation> _observers = {};

  bool get hasObservers => _observers.isNotEmpty;

  final Map<_ListenerKind, Set<void Function()>?> _observationListeners = {};

  void reportObserved() {
    _context.reportObserved(this);
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
    _observers.remove(d);
    if (_observers.isEmpty) {
      _context._enqueueForUnobservation(this);
    }
  }

  void _notifyOnBecomeObserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeObserved];
    listeners?.forEach(_notifyListener);
  }

  static void _notifyListener(void Function() listener) => listener();

  void _notifyOnBecomeUnobserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeUnobserved];
    listeners?.forEach(_notifyListener);
  }

  void Function() onBecomeObserved(void Function() fn) =>
      _addListener(_ListenerKind.onBecomeObserved, fn);

  void Function() onBecomeUnobserved(void Function() fn) =>
      _addListener(_ListenerKind.onBecomeUnobserved, fn);

  void Function() _addListener(_ListenerKind kind, void Function() fn) {
    (_observationListeners[kind] ??= {}).add(fn);

    return () {
      final listeners = _observationListeners[kind];
      if (listeners == null) {
        return;
      }

      listeners.removeWhere((f) => f == fn);
      if (listeners.isEmpty) {
        _observationListeners[kind] = null;
      }
    };
  }

  @override
  String toString() => 'Atom(name: $name, identity: ${identityHashCode(this)})';
}

class WillChangeNotification<T> {
  WillChangeNotification({this.type, this.newValue, this.object});

  /// One of add | update | delete
  final OperationType? type;

  T? newValue;
  final dynamic object;

  static WillChangeNotification unchanged = WillChangeNotification();
}

enum OperationType { add, update, remove }

class ChangeNotification<T> {
  ChangeNotification({this.type, this.newValue, this.oldValue, this.object});

  /// One of add | update | delete
  final OperationType? type;

  final T? oldValue;
  T? newValue;

  dynamic object;
}
