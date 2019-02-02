import 'package:mobx/src/api/observable_collections.dart';
import 'package:mobx/src/core.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  group('ObservableSet', () {
    test('linkedHashSetFrom creates a set that iterates at insertion order',
        () {
      final oset = ObservableSet<int>.linkedHashSetFrom([]);
      [3, 2, 1].forEach(oset.add);
      expect(oset.toList(), equals([3, 2, 1]));
    });

    test('splayTreeSet creates a set that iterates at sorted order', () {
      final oset = ObservableSet.splayTreeSetFrom([3, 2, 1]);
      expect(oset.toList(), equals([1, 2, 3]));
    });

    test('add with listeners reports a change', () {
      final oset = ObservableSet.of([1, 2, 3]);
      SetChange<int> change;
      oset
        ..observe((c) => change = c)
        ..add(4);

      expect(change.type, equals(OperationType.add));
      expect(change.value, equals(4));
    });

    test('remove with listeners reports a change', () {
      final oset = ObservableSet.of([1, 2, 3]);
      SetChange<int> change;
      oset
        ..observe((c) => change = c)
        ..remove(2);

      expect(change.type, equals(OperationType.remove));
      expect(change.value, equals(2));
    });

    test('clear with listeners reports a change', () {
      final oset = ObservableSet.of([1, 2]);
      final changes = <SetChange<int>>[];
      oset
        ..observe(changes.add)
        ..clear();

      expect(changes[0].type, equals(OperationType.remove));
      expect(changes[0].value, equals(1));
      expect(changes[1].type, equals(OperationType.remove));
      expect(changes[1].value, equals(2));
    });

    test('observe receives add events when fireImmediately is true', () {
      final oset = ObservableSet.of([1, 2]);
      final changes = <SetChange<int>>[];
      oset.observe(changes.add, fireImmediately: true);

      expect(changes[0].type, equals(OperationType.add));
      expect(changes[0].value, equals(1));
      expect(changes[1].type, equals(OperationType.add));
      expect(changes[1].value, equals(2));
    });

    group('fires reportObserved() for read methods', () {
      <String, void Function(ObservableSet<int>)>{
        'union': (m) => m.union(Set.of([2, 5, 6])),
        'toSet': (m) => m.toSet(),
        'length': (m) => m.length,
        'lookup': (m) => m.lookup(1),
        'reduce': (m) => m.reduce((a, b) => a + b),
        'singleWhere': (m) => m.singleWhere((i) => i == 2),
        'toList': (m) => m.toList(),
        'any': (m) => m.any((i) => i == 2),
        'contains': (m) => m.contains(3),
        'containsAll': (m) => m.containsAll([1, 2]),
        'difference': (m) => m.difference(Set.of([2, 3])),
        'elementAt': (m) => m.elementAt(2),
        'every': (m) => m.every((i) => i < 10),
        'first': (m) => m.first,
        'firstWhere': (m) => m.firstWhere((i) => i == 2),
        'fold': (m) => m.fold<int>(0, (a, b) => a + b),
        // ignore:avoid_function_literals_in_foreach_calls
        'forEach': (m) => m.forEach((i) {}),
        'intersection': (m) => m.intersection(Set.of([2, 10])),
        'isEmpty': (m) => m.isEmpty,
        'isNotEmpty': (m) => m.isNotEmpty,
        'join': (m) => m.join(', '),
        'last': (m) => m.last,
        'lastWhere': (m) => m.lastWhere((i) => i == 2),
      }.forEach(runReadTest);
    });

    group(
        'fires reportObserved() for iterable transformation methods only when iterating',
        () {
      <String, Iterable Function(ObservableSet<int>)>{
        'cast': (m) => m.cast<num>(),
        'expand': (m) => m.expand((i) => [3, 4]),
        'followedBy': (m) => m.followedBy([5, 6]),
        'map': (m) => m.map((i) => i + 1),
        'skip': (m) => m.skip(1),
        'skipWhile': (m) => m.skipWhile((i) => i < 2),
        'take': (m) => m.take(2),
        'takeWhile': (m) => m.takeWhile((i) => i < 3),
        'where': (m) => m.where((i) => i > 2),
        'whereType': (m) => m.whereType<num>(),
      }.forEach(runIterableTest);
    });

    group('fires reportChanged() for write methods', () {
      <String, void Function(ObservableSet<int>)>{
        'add': (m) => m.add(6),
        'addAll': (m) => m.addAll([6, 7]),
        'clear': (m) => m.clear(),
        'remove': (m) => m.remove(1),
        'removeAll': (m) => m.removeAll([1, 2]),
        'removeWhere': (m) => m.removeWhere((i) => i < 2),
        'retainAll': (m) => m.retainAll([1, 2]),
        'retainWhere': (m) => m.retainWhere((i) => i < 3),
      }.forEach(runWriteTest);
    });
  });
}

void runReadTest(String description, void Function(ObservableSet<int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableSet(atom, Set.of([1, 2, 3, 4]));

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    body(map);

    verify(atom.reportObserved());
    verifyNever(atom.reportChanged());
  });
}

void runWriteTest(String description, void Function(ObservableSet<int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableSet(atom, Set.of([1, 2, 3, 4]));

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    body(map);

    verify(atom.reportChanged());
  });
}

void runIterableTest(
    String description, Iterable Function(ObservableSet<int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableSet(atom, Set.of([1, 2, 3, 4]));

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    final iter = body(map);
    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    void noOp(_) {}
    iter.forEach(noOp);
    verify(atom.reportObserved());
    verifyNever(atom.reportChanged());
  });
}
