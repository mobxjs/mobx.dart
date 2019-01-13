import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

/// Create an observable list of [T].
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
///
// ignore: prefer_mixin
class ObservableList<T> with ListMixin<T> {
  ObservableList({ReactiveContext context})
      : _atom = createAtom(name: 'ObservableList<$T>', context: context),
        _list = <T>[];

  ObservableList.of(Iterable<T> elements, {ReactiveContext context})
      : _atom = createAtom(name: 'ObservableList<$T>', context: context),
        _list = List<T>.of(elements, growable: true);

  @visibleForTesting
  ObservableList._wrap(this._list, this._atom);

  final Atom _atom;
  final List<T> _list;

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
  T operator [](int index) {
    _atom.reportObserved();
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
    _atom.reportChanged();
  }

  @override
  void add(T element) {
    _list.add(element);
    _atom.reportChanged();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    _atom.reportChanged();
  }

  @override
  List<T> sublist(int start, [int end]) {
    _atom.reportObserved();
    return _list.sublist(start, end);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
    _atom.reportChanged();
  }

  @override
  Map<int, T> asMap() {
    // TODO(katis): the map should be observable, with the same atom
    _atom.reportObserved();
    return _list.asMap();
  }

  @override
  List<R> cast<R>() => ObservableList._wrap(_list.cast<R>(), _atom);
}

@visibleForTesting
ObservableList<T> wrapInObservableList<T>(List<T> list, Atom atom) =>
    ObservableList._wrap(list, atom);
