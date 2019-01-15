import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart';

/// Create a list of [T].
///
/// The ObservableList tracks the various read-methods (eg: [List.first], [List.last]) and
/// write-methods (eg: [List.add], [List.insert]) making it easier to use it inside reactions.
///
/// ```dart
/// final list = ObservableList<int>();
///
/// list.add(observable(100));
///
/// print(list.first.value); // prints 100
/// ```
class ObservableList<T>
    implements List<T>, Listenable<ListChangeNotification<T>> {
  ObservableList({String name, ReactiveContext context}) {
    _context = context ?? mainContext;
    _name = name ?? _context.nameFor('ObservableList<$T>');
    _listeners = Listeners(_context);
  }

  String get name => _name;

  String _name;
  Listeners<ListChangeNotification<T>> _listeners;
  ReactiveContext _context;

  final _atom = createAtom(name: 'Atom@ObservableList<$T>');
  final _list = <T>[];

  //---------------------- Read Methods ---------------------------- //
  @override
  T get first {
    _atom.reportObserved();
    return _list.first;
  }

  @override
  T get last {
    _atom.reportObserved();
    return _list.last;
  }

  @override
  int get length {
    _atom.reportObserved();
    return _list.length;
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
  bool any(bool Function(T element) test) {
    _atom.reportObserved();
    return _list.any(test);
  }

  @override
  Map<int, T> asMap() {
    _atom.reportObserved();
    return _list.asMap();
  }

  @override
  List<R> cast<R>() {
    _atom.reportObserved();
    return _list.cast<R>();
  }

  @override
  bool contains(Object element) {
    _atom.reportObserved();
    return _list.contains(element);
  }

  @override
  T elementAt(int index) {
    _atom.reportObserved();
    return _list.elementAt(index);
  }

  @override
  bool every(bool Function(T element) test) {
    _atom.reportObserved();
    return _list.every(test);
  }

  @override
  Iterable<U> expand<U>(Iterable<U> Function(T element) f) {
    _atom.reportObserved();
    return _list.expand(f);
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) {
    _atom.reportObserved();
    return _list.firstWhere(test, orElse: orElse);
  }

  @override
  U fold<U>(U initialValue, U Function(U previousValue, T element) combine) {
    _atom.reportObserved();
    return _list.fold(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    _atom.reportObserved();
    return _list.followedBy(other);
  }

  @override
  void forEach(void Function(T element) f) {
    _atom.reportObserved();
    _list.forEach(f);
  }

  @override
  Iterable<T> getRange(int start, int end) {
    _atom.reportObserved();
    return _list.getRange(start, end);
  }

  @override
  int indexOf(T element, [int start = 0]) {
    _atom.reportObserved();
    return _list.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    _atom.reportObserved();
    return _list.indexWhere(test, start);
  }

  @override
  bool get isEmpty {
    _atom.reportObserved();
    return _list.isEmpty;
  }

  @override
  bool get isNotEmpty {
    _atom.reportObserved();
    return _list.isNotEmpty;
  }

  @override
  Iterator<T> get iterator {
    _atom.reportObserved();
    return _list.iterator;
  }

  @override
  String join([String separator = '']) {
    _atom.reportObserved();
    return _list.join(separator);
  }

  @override
  int lastIndexOf(T element, [int start]) {
    _atom.reportObserved();
    return _list.lastIndexOf(element, start);
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
  Iterable<U> map<U>(U Function(T e) f) {
    _atom.reportObserved();
    return _list.map(f);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    _atom.reportObserved();
    return _list.reduce(combine);
  }

  @override
  T get single {
    _atom.reportObserved();
    return _list.single;
  }

  @override
  Iterable<T> get reversed {
    _atom.reportObserved();
    return _list.reversed;
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) {
    _atom.reportObserved();
    return _list.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    _atom.reportObserved();
    return _list.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    _atom.reportObserved();
    return _list.skipWhile(test);
  }

  @override
  List<T> sublist(int start, [int end]) {
    _atom.reportObserved();
    return _list.sublist(start, end);
  }

  @override
  Iterable<T> take(int count) {
    _atom.reportObserved();
    return _list.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    _atom.reportObserved();
    return _list.takeWhile(test);
  }

  @override
  List<T> toList({bool growable = true}) {
    _atom.reportObserved();
    return _list.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    _atom.reportObserved();
    return _list.toSet();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    _atom.reportObserved();
    return _list.where(test);
  }

  @override
  Iterable<U> whereType<U>() {
    _atom.reportObserved();
    return _list.whereType<U>();
  }

  //------------------ Write Methods -------------------- //
  @override
  set first(T value) {
    final oldValue = _list.first;

    _list.first = value;
    _notifyChildUpdate(0, value, oldValue);
  }

  @override
  set last(T value) {
    final oldValue = _list.last;

    _list.last = value;
    _notifyChildUpdate(_list.length - 1, value, oldValue);
  }

  @override
  void operator []=(int index, T value) {
    final oldValue = _list[index];

    if (oldValue != value) {
      _list[index] = value;
      _notifyChildUpdate(index, value, oldValue);
    }
  }

  @override
  set length(int value) {
    _list.length = value;
    _notifyListUpdate(0, null, null);
  }

  @override
  void add(T value) {
    _list.add(value);
    _notifyListUpdate(_list.length, [value], null);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    _notifyListUpdate(0, iterable.toList(growable: false), null);
  }

  @override
  void clear() {
    final oldItems = _list.toList(growable: false);
    _list.clear();
    _notifyListUpdate(0, null, oldItems);
  }

  @override
  void fillRange(int start, int end, [T fillValue]) {
    _list.fillRange(start, end, fillValue);
    _notifyListUpdate(start, null, null);
  }

  @override
  void insert(int index, T element) {
    _list.insert(index, element);
    _notifyListUpdate(index, [element], null);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
    _notifyListUpdate(index, iterable.toList(growable: false), null);
  }

  @override
  bool remove(Object value) {
    final index = _list.indexWhere((_) => _ == value);
    final didRemove = _list.remove(value);

    if (didRemove) {
      _notifyListUpdate(index, null, value == null ? null : [value]);
    }

    return didRemove;
  }

  @override
  T removeAt(int index) {
    final value = _list.removeAt(index);
    _notifyListUpdate(index, null, value == null ? null : [value]);

    return value;
  }

  @override
  T removeLast() {
    final value = _list.removeLast();

    // Index is _list.length as it points to the index before the last element is removed
    _notifyListUpdate(_list.length, null, value == null ? null : [value]);

    return value;
  }

  @override
  void removeRange(int start, int end) {
    final removedItems = _list.sublist(start, end);
    _list.removeRange(start, end);
    _notifyListUpdate(start, null, removedItems);
  }

  @override
  void removeWhere(bool Function(T element) test) {
    final removedItems = _list.where(test).toList(growable: false);
    _list.removeWhere(test);
    _notifyListUpdate(0, null, removedItems);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    _list.replaceRange(start, end, replacement);
    _notifyListUpdate(start, null, null);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _list.retainWhere(test);
    _notifyListUpdate(0, null, null);
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _list.setAll(index, iterable);
    _notifyListUpdate(index, null, null);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    _notifyListUpdate(start, null, null);
  }

  @override
  void shuffle([Random random]) {
    _list.shuffle(random);
    _notifyListUpdate(0, null, null);
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    _list.sort(compare);

    _notifyListUpdate(0, null, null);
  }

  @override
  Dispose observe(Listener<ListChangeNotification<T>> listener,
      {bool fireImmediately}) {
    if (fireImmediately == true) {
      final change = ListChangeNotification(
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

    final change = ListChangeNotification(
        index: index,
        newValue: newValue,
        oldValue: oldValue,
        object: this,
        type: OperationType.update);

    _listeners.notifyListeners(change);
  }

  void _notifyListUpdate(int index, List<T> added, List<T> removed) {
    _atom.reportChanged();

    final change = ListChangeNotification(
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
    ListChangeNotification<TNotification>);

class ListChangeNotification<T> {
  ListChangeNotification(
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
