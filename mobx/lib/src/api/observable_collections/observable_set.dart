part of '../observable_collections.dart';

Atom _observableSetAtom<T>(ReactiveContext context, String? name) =>
    Atom(name: name ?? context.nameFor('ObservableSet<$T>'), context: context);

/// ObservableSet provides a reactive set that notifies changes when a member is added or removed.
///
/// ```dart
/// final set = ObservableSet.of([1, 2, 3]);
///
/// const disposer = autorun((_){
///   print(set);
/// });
///
/// set.add(4); // prints {1, 2, 3, 4}
///
/// ```
class ObservableSet<T>
    with
        // ignore:prefer_mixin
        SetMixin<T>
    implements
        Listenable<SetChange<T>> {
  ObservableSet(
      {ReactiveContext? context, String? name, EqualityComparer<T>? equals})
      : this._(context ?? mainContext, <T>{}, name, equals);

  ObservableSet.of(Iterable<T> other,
      {ReactiveContext? context, String? name, EqualityComparer<T>? equals})
      : this._(context ?? mainContext, Set<T>.of(other), name, equals);

  ObservableSet.splayTreeSetFrom(Iterable<T> other,
      {int Function(T, T)? compare,
      // ignore:avoid_annotating_with_dynamic
      bool Function(dynamic)? isValidKey,
      ReactiveContext? context,
      String? name,
      EqualityComparer<T>? equals})
      : this._(context ?? mainContext,
            SplayTreeSet.of(other, compare, isValidKey), name, equals);

  ObservableSet._wrap(this._context, this._atom, this._set, this._equals);

  ObservableSet._(
      this._context, Set<T> wrapped, String? name, EqualityComparer<T>? equals)
      : _atom = _observableSetAtom(_context, name),
        _set = wrapped,
        _equals = equals;

  final ReactiveContext _context;
  final Atom _atom;
  final Set<T> _set;
  final EqualityComparer<T>? _equals;

  Set<T> get nonObservableInner => _set;

  String get name => _atom.name;

  Listeners<SetChange<T>>? _listenersField;

  Listeners<SetChange<T>> get _listeners =>
      _listenersField ??= Listeners(_context);

  bool get _hasListeners =>
      _listenersField != null && _listenersField!.hasHandlers;

  @override
  bool add(T value) {
    var result = false;

    _context.conditionallyRunInAction(() {
      final oldValue = _equals != null ? _findValue(value) : null;

      if (oldValue == null) {
        result = _tryAddValue(value);
      }
    }, _atom);

    return result;
  }

  T? _findValue(Object? value) {
    if (value is T?) {
      return _set.firstWhereOrNull((e) => _areEquals(e, value));
    } else {
      return null;
    }
  }

  bool _tryAddValue(T value) {
    var result = _set.add(value);
    if (result) {
      _reportChanges(value);
    }
    return result;
  }

  void _reportChanges(T value) {
    if (_hasListeners) {
      _reportAdd(value);
    }
    _atom.reportChanged();
  }

  @override
  bool contains(Object? element) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _equals == null
        ? _set.contains(element)
        : _findValue(element) != null;
  }

  @override
  Iterator<T> get iterator => ObservableIterator(_atom, _set.iterator);

  @override
  int get length {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _set.length;
  }

  @override
  T? lookup(Object? element) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _equals == null ? _set.lookup(element) : _findValue(element);
  }

  @override
  bool remove(Object? value) {
    var removed = false;

    _context.conditionallyRunInAction(() {
      final oldValue = _equals != null ? _findValue(value) : value;

      if (oldValue != null) {
        removed = _set.remove(oldValue);

        if (removed && _hasListeners) {
          _reportRemove(oldValue as T?);
        }

        if (removed) {
          _atom.reportChanged();
        }
      }
    }, _atom);

    return removed;
  }

  @override
  void clear() {
    _context.conditionallyRunInAction(() {
      if (_hasListeners) {
        final items = _set.toList(growable: false);
        _set.clear();
        items.forEach(_reportRemove);
      } else {
        _set.clear();
      }
      _atom.reportChanged();
    }, _atom);
  }

  @override
  Set<R> cast<R>([EqualityComparer<R>? equals]) => ObservableSet<R>._wrap(
      _context,
      _atom,
      _set.cast<R>(),
      equals ??
          (_equals == null
              ? null
              : (R? a, R? b) => _equals!(a as T?, b as T?)));

  @override
  Set<T> toSet() {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return Set.from(_set);
  }

  /// Attaches a listener to changes happening in the [ObservableSet]. You have
  /// the option to be notified immediately ([fireImmediately]) or wait for until the first change.
  @override
  Dispose observe(SetChangeListener<T> listener,
      {bool fireImmediately = false}) {
    if (fireImmediately == true) {
      for (final value in _set) {
        listener(SetChange(
          object: this,
          type: OperationType.add,
          value: value,
        ));
      }
    }
    return _listeners.add(listener);
  }

  void _reportAdd(T value) {
    _listeners.notifyListeners(SetChange(
      object: this,
      type: OperationType.add,
      value: value,
    ));
  }

  void _reportRemove(T? value) {
    _listeners.notifyListeners(SetChange(
      object: this,
      type: OperationType.remove,
      value: value,
    ));
  }

  bool _areEquals(T? a, T? b) {
    if (_equals != null) {
      return _equals!(a, b);
    } else {
      return equatable(a, b);
    }
  }
}

/// A convenience method used during unit testing. It creates an [ObservableSet] with a custom instance
/// of an [Atom]
@visibleForTesting
ObservableSet<T> wrapInObservableSet<T>(Atom atom, Set<T> set) =>
    ObservableSet._wrap(mainContext, atom, set, null);

/// An internal iterator used to ensure that every read is tracked as part of the
/// MobX reactivity system.
///
/// It does this be keeping an instance of an [Atom] and calling the [Atom.reportObserved]
/// method for every read.
class ObservableIterator<T> implements Iterator<T> {
  ObservableIterator(this._atom, this._iterator);

  final Iterator<T> _iterator;
  final Atom _atom;

  @override
  T get current {
    _atom.context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _iterator.current;
  }

  @override
  bool moveNext() {
    _atom.context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _iterator.moveNext();
  }
}

typedef SetChangeListener<T> = void Function(SetChange<T>);

/// Capture the change related information for an [ ObservableSet]. This is used
/// as the notification instance.
class SetChange<T> {
  SetChange({
    required this.object,
    required this.type,
    required this.value,
  });

  final ObservableSet<T> object;
  final OperationType type;
  final T? value;
}
