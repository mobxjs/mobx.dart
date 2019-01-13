part of '../core.dart';

mixin ObservableListMixin<T> implements List<ObservableValue<T>> {
  final _atom = createAtom(name: 'ObservableArray');
  final _list = <ObservableValue<T>>[];

  @override
  ObservableValue<T> get first {
    _atom.reportObserved();
    return _list.first;
  }

  @override
  set first(ObservableValue<T> value) {
    _list.first = value;
    _atom.reportChanged();
  }

  @override
  ObservableValue<T> get last {
    _atom.reportObserved();
    return _list.last;
  }

  @override
  set last(ObservableValue<T> value) {
    _list.last = value;
    _atom.reportChanged();
  }

  @override
  int get length {
    _atom.reportObserved();
    return _list.length;
  }

  @override
  set length(int value) {
    _list.length = value;
    _atom.reportChanged();
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
  void operator []=(int index, ObservableValue<T> value) {
    final oldValue = _list[index];

    if (oldValue != value) {
      _list[index] = value;
      _atom.reportChanged();
    }
  }

  @override
  void add(ObservableValue<T> value) {
    _list.add(value);
    _atom.reportChanged();
  }

  @override
  void addAll(Iterable<ObservableValue<T>> iterable) {
    _list.addAll(iterable);
    _atom.reportChanged();
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
  void clear() {
    _list.clear();
    _atom.reportChanged();
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
  void fillRange(int start, int end, [ObservableValue<T> fillValue]) {
    _list.fillRange(start, end, fillValue);
    _atom.reportChanged();
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
  void insert(int index, ObservableValue<T> element) {
    _list.insert(index, element);
    _atom.reportChanged();
  }

  @override
  void insertAll(int index, Iterable<ObservableValue<T>> iterable) {
    _list.insertAll(index, iterable);
    _atom.reportChanged();
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
  bool remove(Object value) {
    final didRemove = _list.remove(value);
    _atom.reportChanged();

    return didRemove;
  }

  @override
  ObservableValue<T> removeAt(int index) {
    final value = _list.removeAt(index);
    _atom.reportChanged();

    return value;
  }

  @override
  ObservableValue<T> removeLast() {
    final value = _list.removeLast();
    _atom.reportChanged();

    return value;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    _atom.reportChanged();
  }

  @override
  void removeWhere(bool Function(ObservableValue<T> element) test) {
    _list.removeWhere(test);
    _atom.reportChanged();
  }

  @override
  void replaceRange(
      int start, int end, Iterable<ObservableValue<T>> replacement) {
    _list.replaceRange(start, end, replacement);
    _atom.reportChanged();
  }

  @override
  void retainWhere(bool Function(ObservableValue<T> element) test) {
    _list.retainWhere(test);
    _atom.reportChanged();
  }

  @override
  Iterable<ObservableValue<T>> get reversed {
    _atom.reportObserved();
    return _list.reversed;
  }

  @override
  void setAll(int index, Iterable<ObservableValue<T>> iterable) {
    _list.setAll(index, iterable);
    _atom.reportChanged();
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
    _atom.reportChanged();
  }

  @override
  ObservableValue<T> get single {
    _atom.reportObserved();
    return _list.single;
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
  void sort(
      [int Function(ObservableValue<T> a, ObservableValue<T> b) compare]) {
    _list.sort(compare);
    _atom.reportChanged();
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

  void _notifyChildUpdate(int index, T newValue, T oldValue) {
    _atom.reportChanged();
  }
}
