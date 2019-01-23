import 'package:mobx/mobx.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';

void main() {
  group('MapKeysIterable', () {
    test('length reports observed', () {
      final atom = MockAtom();

      verifyNever(atom.reportObserved());
      expect(MapKeysIterable(['a', 'b'], atom).length, equals(2));
      verify(atom.reportObserved());
    });

    test('contains reports observed', () {
      final atom = MockAtom();

      verifyNever(atom.reportObserved());
      expect(MapKeysIterable(['a', 'b'], atom).contains('a'), isTrue);
      verify(atom.reportObserved());
    });
  });

  group('ObservableList', () {
    test('Observing a map key works', () {
      final map = ObservableMap.of({'a': 1});

      var count = 0;
      autorun((_) {
        // ignore:unnecessary_statements
        map['a'];
        count++;
      });
      expect(count, equals(1));

      map['a']++;
      expect(count, equals(2));
    });

    test('Inserting a key is observed', () {
      final map = ObservableMap<String, int>();

      var count = 0;
      autorun((_) {
        // ignore:unnecessary_statements
        map.forEach((_, __) {});
        count++;
      });
      expect(count, equals(1));

      map['b'] = 2;
      expect(count, equals(2));
    });

    test('linkedHashMapFrom iterates on insertion order', () {
      final map = ObservableMap<String, int>.linkedHashMapFrom({});
      map['c'] = 3;
      map['b'] = 2;
      map['a'] = 1;

      expect(map.keys.toList(), equals(['c', 'b', 'a']));
    });

    test('splayTreeMapFrom iterates based on compare function', () {
      final map = ObservableMap<String, int>.splayTreeMapFrom({},
          compare: (a, b) => b.compareTo(a));
      map['a'] = 1;
      map['b'] = 2;
      map['c'] = 3;

      expect(map.keys.toList(), equals(['c', 'b', 'a']));
    });

    group('fires reportObserved() for read methods', () {
      <String, void Function(ObservableMap<String, int>)>{
        '[]': (m) => m['a'],
        'containsKey': (m) => m.containsKey('a'),
        'containsValue': (m) => m.containsKey(1),
        'forEach': (m) => m.forEach((_, __) {}),
        'putIfAbsent': (m) => m.putIfAbsent('a', () => 1),
        'length': (m) => m.length,
        'isEmpty': (m) => m.isEmpty,
        'isNotEmpty': (m) => m.isNotEmpty,
        'map': (m) => m.map((key, value) => MapEntry(key, value + 1)),
      }.forEach(runReadTest);
    });

    group(
        'fires reportObserved() for iterable transformation methods only when iterating',
        () {
      <String, Iterable Function(ObservableMap<String, int>)>{
        'keys': (m) => m.keys,
        'values': (m) => m.values,
        'entries': (m) => m.entries,
        'cast': (m) => m.cast().keys
      }.forEach(runIterableTest);
    });

    group('fires reportChanged() for write methods', () {
      <String, void Function(ObservableMap<String, int>)>{
        '[]=': (m) => m['d'] = 4,
        'addAll': (m) => m.addAll({'d': 4, 'e': 5}),
        'addEntries': (m) =>
            m.addEntries([const MapEntry('d', 4), const MapEntry('e', 5)]),
        'clear': (m) => m.clear(),
        'remove': (m) => m.remove('a'),
        'removeWhere': (m) => m.removeWhere((key, i) => i == 2),
        'update': (m) => m.update('a', (value) => value + 1),
        'update ifAbsent': (m) =>
            m.update('d', (value) => value + 1, ifAbsent: () => 4),
        'updateAll': (m) => m.updateAll((_, value) => value + 1),
        'putIfAbsent absent': (m) => m.putIfAbsent('d', () => 4),
      }.forEach(runWriteTest);
    });
  });
}

void runWriteTest(
    String description, void Function(ObservableMap<String, int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableMap(atom, {'a': 1, 'b': 2, 'c': 3});

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    body(map);

    verify(atom.reportChanged());
  });
}

void runReadTest(
    String description, void Function(ObservableMap<String, int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableMap(atom, {'a': 1, 'b': 2, 'c': 3});

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    body(map);

    verify(atom.reportObserved());
    verifyNever(atom.reportChanged());
  });
}

void runIterableTest(
    String description, Iterable Function(ObservableMap<String, int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableMap(atom, {'a': 1, 'b': 2, 'c': 3});

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
