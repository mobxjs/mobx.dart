part of '../observable_collections.dart';

Atom _listAtom<T>(ReactiveContext context) {
  final ctx = context ?? mainContext;
  return Atom(name: ctx.nameFor('ObservableList<$T>'), context: ctx);
}

/// The ObservableList tracks the various read-methods (eg: [List.first], [List.last]) and
/// write-methods (eg: [List.add], [List.insert]) making it easier to use it inside reactions.
///
/// As the name suggests, this is the Observable-counterpart to the standard Dart `List<T>`.
///
/// ```dart
/// final list = ObservableList<int>.of([1]);
///
/// autorun((_) {
///   print(list.first);
/// }) // prints 1
///
/// list[0] = 100; // autorun prints 100
/// ```
class ObservableList<T>
    with
        // ignore: prefer_mixin
        ListMixin<T>
    implements
        Listenable<ListChange<T>> {
  ObservableList({ReactiveContext context})
      : this._wrap(context, _listAtom<T>(context), []);

  ObservableList.of(Iterable<T> elements, {ReactiveContext context})
      : this._wrap(context, _listAtom<T>(context),
            List<T>.of(elements, growable: true));

  ObservableList._wrap(ReactiveContext context, this._atom, this._list)
      : _context = context ?? mainContext;

  final ReactiveContext _context;
  final Atom _atom;
  final List<T> _list;

  Listeners<ListChange<T>> _listenersField;

  Listeners<ListChange<T>> get _listeners =>
      _listenersField ??= Listeners(_context);

  /// The name used to identify for debugging purposes
  String get name => _atom.name;

  @override
  int get length {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.length;
  }

  @override
  set length(int value) {
    /// There is no need to enforceWritePolicy since we are conditionally wrapping in an Action.
    _context.conditionallyRunInAction(() {
      _list.length = value;
      _notifyListUpdate(0, null, null);
    }, _atom);
  }

  @override
  List<T> operator +(List<T> other) {
    _context.enforceReadPolicy(_atom);

    final newList = _list + other;
    _atom.reportObserved();
    return newList;
  }

  @override
  T operator [](int index) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _context.conditionallyRunInAction(() {
      final oldValue = _list[index];

      if (oldValue != value) {
        _list[index] = value;
        _notifyChildUpdate(index, value, oldValue);
      }
    }, _atom);
  }

  @override
  void add(T element) {
    _context.conditionallyRunInAction(() {
      final index = _list.length;
      _list.add(element);
      _notifyListUpdate(index, [element], null);
    }, _atom);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      final index = _list.length;
      _list.addAll(iterable);
      _notifyListUpdate(index, iterable.toList(growable: false), null);
    }, _atom);
  }

  @override
  Iterator<T> get iterator {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.iterator;
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.lastIndexWhere(test, start);
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.lastWhere(test, orElse: orElse);
  }

  @override
  T get single {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.single;
  }

  @override
  List<T> sublist(int start, [int end]) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.sublist(start, end);
  }

  @override
  Map<int, T> asMap() => ObservableMap._wrap(_context, _list.asMap(), _atom);

  @override
  List<R> cast<R>() => ObservableList._wrap(_context, _atom, _list.cast<R>());

  @override
  List<T> toList({bool growable = true}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.toList(growable: growable);
  }

  @override
  set first(T value) {
    _context.conditionallyRunInAction(() {
      final oldValue = _list.first;

      _list.first = value;
      _notifyChildUpdate(0, value, oldValue);
    }, _atom);
  }

  @override
  void clear() {
    _context.conditionallyRunInAction(() {
      final oldItems = _list.toList(growable: false);
      _list.clear();
      _notifyListUpdate(0, null, oldItems);
    }, _atom);
  }

  @override
  void fillRange(int start, int end, [T fill]) {
    _context.conditionallyRunInAction(() {
      final oldContents = _list.sublist(start, end);

      _list.fillRange(start, end, fill);

      final newContents = _list.sublist(start, end);

      _notifyListUpdate(start, newContents, oldContents);
    }, _atom);
  }

  @override
  void insert(int index, T element) {
    _context.conditionallyRunInAction(() {
      _list.insert(index, element);
      _notifyListUpdate(index, [element], null);
    }, _atom);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      _list.insertAll(index, iterable);
      _notifyListUpdate(index, iterable.toList(growable: false), null);
    }, _atom);
  }

  @override
  bool remove(Object element) {
    var didRemove = false;

    _context.conditionallyRunInAction(() {
      final index = _list.indexOf(element);
      didRemove = _list.remove(element);

      if (didRemove) {
        _notifyListUpdate(index, null, element == null ? null : [element]);
      }
    }, _atom);

    return didRemove;
  }

  @override
  T removeAt(int index) {
    T value;

    _context.conditionallyRunInAction(() {
      value = _list.removeAt(index);
      _notifyListUpdate(index, null, value == null ? null : [value]);
    }, _atom);

    return value;
  }

  @override
  T removeLast() {
    T value;

    _context.conditionallyRunInAction(() {
      value = _list.removeLast();

      // Index is _list.length as it points to the index before the last element is removed
      _notifyListUpdate(_list.length, null, value == null ? null : [value]);
    }, _atom);

    return value;
  }

  @override
  void removeRange(int start, int end) {
    _context.conditionallyRunInAction(() {
      final removedItems = _list.sublist(start, end);
      _list.removeRange(start, end);
      _notifyListUpdate(start, null, removedItems);
    }, _atom);
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _context.conditionallyRunInAction(() {
      final removedItems = _list.where(test).toList(growable: false);
      _list.removeWhere(test);
      _notifyListUpdate(0, null, removedItems);
    }, _atom);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    _context.conditionallyRunInAction(() {
      final oldContents = _list.sublist(start, end);
      _list.replaceRange(start, end, newContents);
      _notifyListUpdate(start, newContents, oldContents);
    }, _atom);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _context.conditionallyRunInAction(() {
      final removedItems = _list.where((_) => !test(_)).toList(growable: false);

      _list.retainWhere(test);
      _notifyListUpdate(0, null, removedItems);
    }, _atom);
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      _list.setAll(index, iterable);
      _notifyListUpdate(index, null, null);
    }, _atom);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _context.conditionallyRunInAction(() {
      _list.setRange(start, end, iterable, skipCount);
      _notifyListUpdate(start, null, null);
    }, _atom);
  }

  @override
  void shuffle([Random random]) {
    _context.conditionallyRunInAction(() {
      _list.shuffle(random);
      _notifyListUpdate(0, null, null);
    }, _atom);
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    _context.conditionallyRunInAction(() {
      _list.sort(compare);
      _notifyListUpdate(0, null, null);
    }, _atom);
  }

  /// Attach a [listener] to the changes happening in the list.
  ///
  /// You can choose to receive the change notification immediately (with [fireImmediately])
  /// or on the first change
  @override
  Dispose observe(Listener<ListChange<T>> listener, {bool fireImmediately}) {
    if (fireImmediately == true) {
      final change = ListChange(
          object: this,
          index: 0,
          type: OperationType.add,
          added: toList(growable: false));
      listener(change);
    }

    return _listeners.add(listener);
  }

  void _notifyChildUpdate(int index, T newValue, T oldValue) {
    _atom.reportChanged();

    final change = ListChange(
        index: index,
        newValue: newValue,
        oldValue: oldValue,
        object: this,
        type: OperationType.update);

    _listeners.notifyListeners(change);
  }

  void _notifyListUpdate(int index, List<T> added, List<T> removed) {
    _atom.reportChanged();

    final change = ListChange(
        index: index,
        added: added,
        removed: removed,
        object: this,
        type: (added != null && added.isNotEmpty)
            ? OperationType.add
            : (removed != null && removed.isNotEmpty
                ? OperationType.remove
                : OperationType.update));

    _listeners.notifyListeners(change);
  }
}

typedef ListChangeListener<TNotification> = void Function(
    ListChange<TNotification>);

/// Stores the change related information when a list-item is modified, added or removed
class ListChange<T> {
  ListChange(
      {this.index,
      this.type,
      this.newValue,
      this.oldValue,
      this.object,
      this.added,
      this.removed});

  final OperationType type;

  final int index;
  final T newValue;
  final T oldValue;

  final List<T> added;
  final List<T> removed;

  final ObservableList<T> object;
}


/// Used during testing for wrapping a regular `List<T>` as an `ObservableList<T>`
@visibleForTesting
ObservableList<T> wrapInObservableList<T>(Atom atom, List<T> list) =>
    ObservableList._wrap(mainContext, atom, list);
