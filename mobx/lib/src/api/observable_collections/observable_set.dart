part of '../observable_collections.dart';

/// ObservbableSet provides a reactive set that notifies changes when a member is added or removed.
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
            // ignore: prefer_collection_literals
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
    var result = false;

    _context.conditionallyRunInAction(() {
      result = _set.add(value);

      if (result && _hasListeners) {
        _reportAdd(value);
      }

      if (result) {
        _atom.reportChanged();
      }
    }, _atom);

    return result;
  }

  @override
  bool contains(Object element) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _set.contains(element);
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
  T lookup(Object element) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _set.lookup(element);
  }

  @override
  bool remove(Object value) {
    var removed = false;

    _context.conditionallyRunInAction(() {
      removed = _set.remove(value);

      if (removed && _hasListeners) {
        _reportRemove(value);
      }

      if (removed) {
        _atom.reportChanged();
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
  Set<R> cast<R>() => ObservableSet<R>._wrap(_context, _atom, _set.cast<R>());

  @override
  Set<T> toSet() {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return Set.from(_set);
  }

  /// Attaches a listener to changes happening in the [ObservableSet]. You have
  /// the option to be notified immediately ([fireImmediately]) or wait for until the first change.
  @override
  Dispose observe(SetChangeListener<T> listener, {bool fireImmediately}) {
    final dispose = _listeners.add(listener);
    if (fireImmediately == true) {
      _set.forEach(_reportAdd);
    }
    return dispose;
  }

  void _reportAdd(T value) {
    _listeners.notifyListeners(SetChange(
      object: this,
      type: OperationType.add,
      value: value,
    ));
  }

  void _reportRemove(T value) {
    _listeners.notifyListeners(SetChange(
      object: this,
      type: OperationType.remove,
      value: value,
    ));
  }
}

/// A convenience method used during unit testing. It creates an [ObservableSet] with a custom instance
/// of an [Atom]
@visibleForTesting
ObservableSet<T> wrapInObservableSet<T>(Atom atom, Set<T> _set) =>
    ObservableSet._wrap(mainContext, atom, _set);

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
    @required this.object,
    @required this.type,
    @required this.value,
  })  : assert(object != null),
        assert(type != null);

  final ObservableSet<T> object;
  final OperationType type;
  final T value;
}
