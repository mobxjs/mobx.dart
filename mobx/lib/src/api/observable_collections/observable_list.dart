part of '../observable_collections.dart';

Atom _listAtom<T>(ReactiveContext context) {
  final ctx = context ?? mainContext;
  return Atom(name: ctx.nameFor('ObservableList<$T>'), context: ctx);
}

/// Create a list of [T].
///
/// The ObservableList tracks the various read-methods (eg: [List.first], [List.last]) and
/// write-methods (eg: [List.add], [List.insert]) making it easier to use it inside reactions.
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

  String get name => _atom.name;

  @override
  int get length {
    _atom.reportObserved();
    return _list.length;
  }

  @override
  set length(int value) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.length = value;
    _notifyListUpdate(0, null, null);
  }

  @override
  List<T> operator +(List<T> other) {
    final newList = _list + other;
    _atom.reportObserved();
    return newList;
  }

  @override
  T operator [](int index) {
    _atom.reportObserved();
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final oldValue = _list[index];

    if (oldValue != value) {
      _list[index] = value;
      _notifyChildUpdate(index, value, oldValue);
    }
  }

  @override
  void add(T element) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.add(element);
    _notifyListUpdate(_list.length, [element], null);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.addAll(iterable);
    _notifyListUpdate(0, iterable.toList(growable: false), null);
  }

  @override
  Iterator<T> get iterator {
    _atom.reportObserved();
    return _list.iterator;
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    _atom.reportObserved();
    return _list.lastIndexWhere(test, start);
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) {
    _atom.reportObserved();
    return _list.lastWhere(test, orElse: orElse);
  }

  @override
  T get single {
    _atom.reportObserved();
    return _list.single;
  }

  @override
  List<T> sublist(int start, [int end]) {
    _atom.reportObserved();
    return _list.sublist(start, end);
  }

  @override
  Map<int, T> asMap() => ObservableMap._wrap(_context, _list.asMap(), _atom);

  @override
  List<R> cast<R>() => ObservableList._wrap(_context, _atom, _list.cast<R>());

  @override
  List<T> toList({bool growable = true}) {
    _atom.reportObserved();
    return _list.toList(growable: growable);
  }

  @override
  set first(T value) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final oldValue = _list.first;

    _list.first = value;
    _notifyChildUpdate(0, value, oldValue);
  }

  @override
  void clear() {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final oldItems = _list.toList(growable: false);
    _list.clear();
    _notifyListUpdate(0, null, oldItems);
  }

  @override
  void fillRange(int start, int end, [T fill]) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.fillRange(start, end, fill);
    _notifyListUpdate(start, null, null);
  }

  @override
  void insert(int index, T element) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.insert(index, element);
    _notifyListUpdate(index, [element], null);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.insertAll(index, iterable);
    _notifyListUpdate(index, iterable.toList(growable: false), null);
  }

  @override
  bool remove(Object element) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final index = _list.indexOf(element);
    final didRemove = _list.remove(element);

    if (didRemove) {
      _notifyListUpdate(index, null, element == null ? null : [element]);
    }

    return didRemove;
  }

  @override
  T removeAt(int index) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final value = _list.removeAt(index);
    _notifyListUpdate(index, null, value == null ? null : [value]);
    return value;
  }

  @override
  T removeLast() {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final value = _list.removeLast();

    // Index is _list.length as it points to the index before the last element is removed
    _notifyListUpdate(_list.length, null, value == null ? null : [value]);

    return value;
  }

  @override
  void removeRange(int start, int end) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final removedItems = _list.sublist(start, end);
    _list.removeRange(start, end);
    _notifyListUpdate(start, null, removedItems);
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final removedItems = _list.where(test).toList(growable: false);
    _list.removeWhere(test);
    _notifyListUpdate(0, null, removedItems);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.replaceRange(start, end, newContents);
    _notifyListUpdate(start, null, null);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    final removedItems = _list.where((_) => !test(_)).toList(growable: false);

    _list.retainWhere(test);
    _notifyListUpdate(0, null, removedItems);
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.setAll(index, iterable);
    _notifyListUpdate(index, null, null);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.setRange(start, end, iterable, skipCount);
    _notifyListUpdate(start, null, null);
  }

  @override
  void shuffle([Random random]) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.shuffle(random);
    _notifyListUpdate(0, null, null);
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    _list.sort(compare);
    _notifyListUpdate(0, null, null);
  }

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

@visibleForTesting
ObservableList<T> wrapInObservableList<T>(Atom atom, List<T> list) =>
    ObservableList._wrap(mainContext, atom, list);
