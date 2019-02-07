part of '../observable_collections.dart';

class ObservableSet<T>
    with
        // ignore:prefer_mixin
        SetMixin<T>
    implements
        Listenable<SetChange<T>> {
  ObservableSet({ReactiveContext context})
      : this._(context ?? mainContext, HashSet());

  ObservableSet.of(Iterable<T> other, {ReactiveContext context})
      : this._(context ?? mainContext, HashSet.of(other));

  ObservableSet.linkedHashSetFrom(Iterable<T> other,
      {bool Function(T, T) equals,
      int Function(T) hashCode,
      // ignore:avoid_annotating_with_dynamic
      bool Function(dynamic) isValidKey,
      ReactiveContext context})
      : this._(
            context ?? mainContext,
            LinkedHashSet(
                equals: equals, hashCode: hashCode, isValidKey: isValidKey)
              ..addAll(other));

  ObservableSet.splayTreeSetFrom(Iterable<T> other,
      {int Function(T, T) compare,
      // ignore:avoid_annotating_with_dynamic
      bool Function(dynamic) isValidKey,
      ReactiveContext context})
      : this._(context ?? mainContext,
            SplayTreeSet.of(other, compare, isValidKey));

  ObservableSet._wrap(this._context, this._atom, this._set);

  ObservableSet._(this._context, Set<T> wrapped)
      : _atom = Atom(
            name: _context.nameFor('ObservableSet<$T>'), context: _context),
        _set = wrapped;

  final ReactiveContext _context;
  final Atom _atom;
  final Set<T> _set;

  Listeners<SetChange<T>> _listenersField;

  Listeners<SetChange<T>> get _listeners =>
      _listenersField ??= Listeners(_context);

  bool get _hasListeners =>
      _listenersField != null && _listenersField.hasHandlers;

  @override
  bool add(T value) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final result = _set.add(value);
    if (result && _hasListeners) {
      _reportAdd(value);
    }
    _atom.reportChanged();
    return result;
  }

  @override
  bool contains(Object element) {
    _atom.reportObserved();
    return _set.contains(element);
  }

  @override
  Iterator<T> get iterator => ObservableIterator(_atom, _set.iterator);

  @override
  int get length {
    _atom.reportObserved();
    return _set.length;
  }

  @override
  T lookup(Object element) {
    _atom.reportObserved();
    return _set.lookup(element);
  }

  @override
  bool remove(Object value) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final removed = _set.remove(value);
    if (removed && _hasListeners) {
      _reportRemove(value);
    }
    _atom.reportChanged();
    return removed;
  }

  @override
  void clear() {
    _context.checkIfStateModificationsAreAllowed(_atom);

    if (_hasListeners) {
      final items = _set.toList(growable: false);
      _set.clear();
      items.forEach(_reportRemove);
    } else {
      _set.clear();
    }
    _atom.reportChanged();
  }

  @override
  Set<R> cast<R>() => ObservableSet<R>._wrap(_context, _atom, _set.cast<R>());

  @override
  Set<T> toSet() {
    _atom.reportObserved();
    return Set.from(_set);
  }

  @override
  Dispose observe(SetChangeListener<T> listener, {bool fireImmediately}) {
    final dispose = _listeners.add(listener);
    if (fireImmediately == true) {
      _set.forEach(_reportAdd);
    }
    return dispose;
  }

  void _reportAdd(T value) {
    _listeners
        .notifyListeners(SetChange(type: OperationType.add, value: value));
  }

  void _reportRemove(T value) {
    _listeners
        .notifyListeners(SetChange(type: OperationType.remove, value: value));
  }
}

@visibleForTesting
ObservableSet<T> wrapInObservableSet<T>(Atom atom, Set<T> _set) =>
    ObservableSet._wrap(mainContext, atom, _set);

class ObservableIterator<T> implements Iterator<T> {
  ObservableIterator(this._atom, this._iterator);

  final Iterator<T> _iterator;
  final Atom _atom;

  @override
  T get current {
    _atom.reportObserved();
    return _iterator.current;
  }

  @override
  bool moveNext() {
    _atom.reportObserved();
    return _iterator.moveNext();
  }
}

typedef SetChangeListener<T> = void Function(SetChange<T>);

class SetChange<T> {
  SetChange({@required this.type, this.value}) : assert(type != null);

  final OperationType type;
  final T value;
}
