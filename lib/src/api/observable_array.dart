import 'dart:math';

import 'package:mobx/src/core/atom.dart';
import 'package:mobx/src/core/observable.dart';

class ObservableArray<T> implements List<ObservableValue<T>> {
  var _atom = Atom('ObservableArray');
  var _list = List<ObservableValue<T>>();

  @override
  ObservableValue<T> first;

  @override
  ObservableValue<T> last;

  @override
  int length;

  @override
  List<ObservableValue<T>> operator +(List<ObservableValue<T>> other) {
    // TODO: implement +
    return null;
  }

  @override
  ObservableValue<T> operator [](int index) {
    // TODO: implement []
    return null;
  }

  @override
  void operator []=(int index, ObservableValue<T> value) {
    // TODO: implement []=
  }

  @override
  void add(ObservableValue<T> value) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<ObservableValue<T>> iterable) {
    // TODO: implement addAll
  }

  @override
  bool any(bool Function(ObservableValue<T> element) test) {
    // TODO: implement any
    return null;
  }

  @override
  Map<int, ObservableValue<T>> asMap() {
    // TODO: implement asMap
    return null;
  }

  @override
  List<R> cast<R>() {
    // TODO: implement cast
    return null;
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  bool contains(Object element) {
    // TODO: implement contains
    return null;
  }

  @override
  ObservableValue<T> elementAt(int index) {
    // TODO: implement elementAt
    return null;
  }

  @override
  bool every(bool Function(ObservableValue<T> element) test) {
    // TODO: implement every
    return null;
  }

  @override
  ObservableValue<T> expand<ObservableValue<T>>(
      Iterable<ObservableValue<T>> Function(ObservableValue<T> element) f) {
    // TODO: implement expand
    return _list.expand(f);
  }

  @override
  void fillRange(int start, int end, [ObservableValue<T> fillValue]) {
    // TODO: implement fillRange
  }

  @override
  ObservableValue<T> firstWhere(bool Function(ObservableValue<T> element) test,
      {ObservableValue<T> Function() orElse}) {
    // TODO: implement firstWhere
    return null;
  }

  @override
  T fold<T>(T initialValue,
      T Function(T previousValue, ObservableValue<T> element) combine) {
    // TODO: implement fold
    return null;
  }

  @override
  Iterable<ObservableValue<T>> followedBy(Iterable<ObservableValue<T>> other) {
    // TODO: implement followedBy
    return null;
  }

  @override
  void forEach(void Function(ObservableValue<T> element) f) {
    // TODO: implement forEach
  }

  @override
  Iterable<ObservableValue<T>> getRange(int start, int end) {
    // TODO: implement getRange
    return null;
  }

  @override
  int indexOf(ObservableValue<T> element, [int start = 0]) {
    // TODO: implement indexOf
    return null;
  }

  @override
  int indexWhere(bool Function(ObservableValue<T> element) test,
      [int start = 0]) {
    // TODO: implement indexWhere
    return null;
  }

  @override
  void insert(int index, ObservableValue<T> element) {
    // TODO: implement insert
  }

  @override
  void insertAll(int index, Iterable<ObservableValue<T>> iterable) {
    // TODO: implement insertAll
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => null;

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => null;

  @override
  // TODO: implement iterator
  Iterator<ObservableValue<T>> get iterator => null;

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    return null;
  }

  @override
  int lastIndexOf(ObservableValue<T> element, [int start]) {
    // TODO: implement lastIndexOf
    return null;
  }

  @override
  int lastIndexWhere(bool Function(ObservableValue<T> element) test,
      [int start]) {
    // TODO: implement lastIndexWhere
    return null;
  }

  @override
  ObservableValue<T> lastWhere(bool Function(ObservableValue<T> element) test,
      {ObservableValue<T> Function() orElse}) {
    // TODO: implement lastWhere
    return null;
  }

  @override
  Iterable<T> map<T>(T Function(ObservableValue<T> e) f) {
    // TODO: implement map
    return null;
  }

  @override
  ObservableValue<T> reduce(
      ObservableValue<T> Function(
              ObservableValue<T> value, ObservableValue<T> element)
          combine) {
    // TODO: implement reduce
    return null;
  }

  @override
  bool remove(Object value) {
    // TODO: implement remove
    return null;
  }

  @override
  ObservableValue<T> removeAt(int index) {
    // TODO: implement removeAt
    return null;
  }

  @override
  ObservableValue<T> removeLast() {
    // TODO: implement removeLast
    return null;
  }

  @override
  void removeRange(int start, int end) {
    // TODO: implement removeRange
  }

  @override
  void removeWhere(bool Function(ObservableValue<T> element) test) {
    // TODO: implement removeWhere
  }

  @override
  void replaceRange(
      int start, int end, Iterable<ObservableValue<T>> replacement) {
    // TODO: implement replaceRange
  }

  @override
  void retainWhere(bool Function(ObservableValue<T> element) test) {
    // TODO: implement retainWhere
  }

  @override
  // TODO: implement reversed
  Iterable<ObservableValue<T>> get reversed => null;

  @override
  void setAll(int index, Iterable<ObservableValue<T>> iterable) {
    // TODO: implement setAll
  }

  @override
  void setRange(int start, int end, Iterable<ObservableValue<T>> iterable,
      [int skipCount = 0]) {
    // TODO: implement setRange
  }

  @override
  void shuffle([Random random]) {
    // TODO: implement shuffle
  }

  @override
  // TODO: implement single
  ObservableValue<T> get single => null;

  @override
  ObservableValue<T> singleWhere(bool Function(ObservableValue<T> element) test,
      {ObservableValue<T> Function() orElse}) {
    // TODO: implement singleWhere
    return null;
  }

  @override
  Iterable<ObservableValue<T>> skip(int count) {
    // TODO: implement skip
    return null;
  }

  @override
  Iterable<ObservableValue<T>> skipWhile(
      bool Function(ObservableValue<T> value) test) {
    // TODO: implement skipWhile
    return null;
  }

  @override
  void sort(
      [int Function(ObservableValue<T> a, ObservableValue<T> b) compare]) {
    // TODO: implement sort
  }

  @override
  List<ObservableValue<T>> sublist(int start, [int end]) {
    // TODO: implement sublist
    return null;
  }

  @override
  Iterable<ObservableValue<T>> take(int count) {
    // TODO: implement take
    return null;
  }

  @override
  Iterable<ObservableValue<T>> takeWhile(
      bool Function(ObservableValue<T> value) test) {
    // TODO: implement takeWhile
    return null;
  }

  @override
  List<ObservableValue<T>> toList({bool growable = true}) {
    // TODO: implement toList
    return null;
  }

  @override
  Set<ObservableValue<T>> toSet() {
    // TODO: implement toSet
    return null;
  }

  @override
  Iterable<ObservableValue<T>> where(
      bool Function(ObservableValue<T> element) test) {
    // TODO: implement where
    return null;
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
    return null;
  }
}
