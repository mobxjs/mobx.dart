import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart';

/// Create a list of [ObservableValue<T>].
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
    implements List<ObservableValue<T>>, Listenable<ListChangeNotification<T>> {
  ObservableList({String name, ReactiveContext context}) {
    _context = context ?? mainContext;
    _name = name ?? _context.nameFor('ObservableList');
    _listeners = Listeners(_context);
  }

  String get name => _name;

  String _name;
  Listeners<ListChangeNotification<T>> _listeners;
  ReactiveContext _context;

  final _atom = createAtom(name: 'ObservableArray');
  final _list = <ObservableValue<T>>[];

  //---------------------- Read Methods ---------------------------- //
  @override
  ObservableValue<T> get first {
    _atom.reportObserved();
    return _list.first;
  }

  @override
  ObservableValue<T> get last {
    _atom.reportObserved();
    return _list.last;
  }

  @override
  int get length {
    _atom.reportObserved();
    return _list.length;
  }

  @override
  List<ObservableValue<T>> operator +(List<ObservableValue<T>> other) {
    final newList = _list + other;
    _atom.reportObserved();

    return newList;
  }

  @override
  ObservableValue<T> operator [](int index) {
    _atom.reportObserved();
    return _list[index];
  }

  @override
  bool any(bool Function(ObservableValue<T> element) test) {
    _atom.reportObserved();
    return _list.any(test);
  }

  @override
  Map<int, ObservableValue<T>> asMap() {
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
  ObservableValue<T> elementAt(int index) {
    _atom.reportObserved();
    return _list.elementAt(index);
  }

  @override
  bool every(bool Function(ObservableValue<T> element) test) {
    _atom.reportObserved();
    return _list.every(test);
  }

  @override
  Iterable<U> expand<U>(Iterable<U> Function(ObservableValue<T> element) f) {
    _atom.reportObserved();
    return _list.expand(f);
  }

  @override
  ObservableValue<T> firstWhere(bool Function(ObservableValue<T> element) test,
      {ObservableValue<T> Function() orElse}) {
    _atom.reportObserved();
    return _list.firstWhere(test, orElse: orElse);
  }

  @override
  U fold<U>(U initialValue,
      U Function(U previousValue, ObservableValue<T> element) combine) {
    _atom.reportObserved();
    return _list.fold(initialValue, combine);
  }

  @override
  Iterable<ObservableValue<T>> followedBy(Iterable<ObservableValue<T>> other) {
    _atom.reportObserved();
    return _list.followedBy(other);
  }

  @override
  void forEach(void Function(ObservableValue<T> element) f) {
    _atom.reportObserved();
    _list.forEach(f);
  }

  @override
  Iterable<ObservableValue<T>> getRange(int start, int end) {
    _atom.reportObserved();
    return _list.getRange(start, end);
  }

  @override
  int indexOf(ObservableValue<T> element, [int start = 0]) {
    _atom.reportObserved();
    return _list.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(ObservableValue<T> element) test,
      [int start = 0]) {
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
  Iterator<ObservableValue<T>> get iterator {
    _atom.reportObserved();
    return _list.iterator;
  }

  @override
  String join([String separator = '']) {
    _atom.reportObserved();
    return _list.join(separator);
  }

  @override
  int lastIndexOf(ObservableValue<T> element, [int start]) {
    _atom.reportObserved();
    return _list.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(ObservableValue<T> element) test,
      [int start]) {
    _atom.reportObserved();
    return _list.lastIndexWhere(test, start);
  }

  @override
  ObservableValue<T> lastWhere(bool Function(ObservableValue<T> element) test,
      {ObservableValue<T> Function() orElse}) {
    _atom.reportObserved();
    return _list.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<U> map<U>(U Function(ObservableValue<T> e) f) {
    _atom.reportObserved();
    return _list.map(f);
  }

  @override
  ObservableValue<T> reduce(
      ObservableValue<T> Function(
              ObservableValue<T> value, ObservableValue<T> element)
          combine) {
    _atom.reportObserved();
    return _list.reduce(combine);
  }

  @override
  ObservableValue<T> get single {
    _atom.reportObserved();
    return _list.single;
  }

  @override
  Iterable<ObservableValue<T>> get reversed {
    _atom.reportObserved();
    return _list.reversed;
  }

  @override
  ObservableValue<T> singleWhere(bool Function(ObservableValue<T> element) test,
      {ObservableValue<T> Function() orElse}) {
    _atom.reportObserved();
    return _list.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<ObservableValue<T>> skip(int count) {
    _atom.reportObserved();
    return _list.skip(count);
  }

  @override
  Iterable<ObservableValue<T>> skipWhile(
      bool Function(ObservableValue<T> value) test) {
    _atom.reportObserved();
    return _list.skipWhile(test);
  }

  @override
  List<ObservableValue<T>> sublist(int start, [int end]) {
    _atom.reportObserved();
    return _list.sublist(start, end);
  }

  @override
  Iterable<ObservableValue<T>> take(int count) {
    _atom.reportObserved();
    return _list.take(count);
  }

  @override
  Iterable<ObservableValue<T>> takeWhile(
      bool Function(ObservableValue<T> value) test) {
    _atom.reportObserved();
    return _list.takeWhile(test);
  }

  @override
  List<ObservableValue<T>> toList({bool growable = true}) {
    _atom.reportObserved();
    return _list.toList(growable: growable);
  }

  @override
  Set<ObservableValue<T>> toSet() {
    _atom.reportObserved();
    return _list.toSet();
  }

  @override
  Iterable<ObservableValue<T>> where(
      bool Function(ObservableValue<T> element) test) {
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
  set first(ObservableValue<T> value) {
    final oldValue = _list.first;

    _list.first = value;
    _notifyChildUpdate(0, value.value, oldValue.value);
  }

  @override
  set last(ObservableValue<T> value) {
    final oldValue = _list.last;

    _list.last = value;
    _notifyChildUpdate(_list.length - 1, value.value, oldValue.value);
  }

  @override
  void operator []=(int index, ObservableValue<T> value) {
    final oldValue = _list[index];

    if (oldValue != value) {
      _list[index] = value;
      _notifyChildUpdate(index, value.value, oldValue.value);
    }
  }

  @override
  set length(int value) {
    _list.length = value;
    _notifyListUpdate(0, null, null);
  }

  @override
  void add(ObservableValue<T> value) {
    _list.add(value);
    _notifyListUpdate(_list.length, [value.value], null);
  }

  @override
  void addAll(Iterable<ObservableValue<T>> iterable) {
    _list.addAll(iterable);
    _notifyListUpdate(
        0, iterable.toList(growable: false).map((_) => _.value), null);
  }

  @override
  void clear() {
    _list.clear();
    _notifyListUpdate(0, null, null);
  }

  @override
  void fillRange(int start, int end, [ObservableValue<T> fillValue]) {
    _list.fillRange(start, end, fillValue);
    _notifyListUpdate(start, null, null);
  }

  @override
  void insert(int index, ObservableValue<T> element) {
    _list.insert(index, element);
    _notifyListUpdate(index, [element.value], null);
  }

  @override
  void insertAll(int index, Iterable<ObservableValue<T>> iterable) {
    _list.insertAll(index, iterable);
    _notifyListUpdate(
        index, iterable.toList(growable: false).map((_) => _.value), null);
  }

  @override
  bool remove(Object value) {
    final index = _list.indexWhere((_) => _.value == value);
    final didRemove = _list.remove(value);

    if (didRemove) {
      _notifyListUpdate(index, null, value == null ? null : [value]);
    }

    return didRemove;
  }

  @override
  ObservableValue<T> removeAt(int index) {
    final value = _list.removeAt(index);
    _notifyListUpdate(index, null, value == null ? null : [value.value]);

    return value;
  }

  @override
  ObservableValue<T> removeLast() {
    final value = _list.removeLast();

    // Index is _list.length as it points to the index before the last element is removed
    _notifyListUpdate(_list.length, null, value == null ? null : [value.value]);

    return value;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    _notifyListUpdate(start, null, null);
  }

  @override
  void removeWhere(bool Function(ObservableValue<T> element) test) {
    _list.removeWhere(test);
    _notifyListUpdate(0, null, null);
  }

  @override
  void replaceRange(
      int start, int end, Iterable<ObservableValue<T>> replacement) {
    _list.replaceRange(start, end, replacement);
    _notifyListUpdate(start, null, null);
  }

  @override
  void retainWhere(bool Function(ObservableValue<T> element) test) {
    _list.retainWhere(test);
    _notifyListUpdate(0, null, null);
  }

  @override
  void setAll(int index, Iterable<ObservableValue<T>> iterable) {
    _list.setAll(index, iterable);
    _notifyListUpdate(index, null, null);
  }

  @override
  void setRange(int start, int end, Iterable<ObservableValue<T>> iterable,
      [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    _atom.reportChanged();
  }

  @override
  void shuffle([Random random]) {
    _list.shuffle(random);
    _notifyListUpdate(0, null, null);
  }

  @override
  void sort(
      [int Function(ObservableValue<T> a, ObservableValue<T> b) compare]) {
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
