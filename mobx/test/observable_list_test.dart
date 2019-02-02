import 'package:mobx/mobx.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';

void main() {
  group('ObservableList', () {
    test('basics work', () {
      final list = ObservableList<int>();
      var count = -1;

      expect(list.name, startsWith('ObservableList<int>@'));

      final d = autorun((_) {
        count = list.length;
      });

      expect(count, equals(0));

      list.add(20);
      expect(count, equals(1));
      d();
    });

    test('cast returns a live view to list', () {
      final list = ObservableList<num>.of(<num>[0, 1, 2, 3, 4, 5, 6]);
      final casted = list.cast<int>();

      var count = 0;
      autorun((_) {
        // ignore:unnecessary_statements
        casted[1];
        count++;
      });
      expect(count, equals(1));

      list[1] = 99;
      expect(casted[1], equals(99));
      expect(count, equals(2));
    });

    test('Autorun should execute when items are added to an empty list', () {
      final list = ObservableList<int>();

      var count = 0;
      autorun((_) {
        for (final _ in list) {
          count++;
        }
      });
      expect(count, equals(0));

      list.add(0);
      expect(count, equals(1));
    });

    test('observe basics work', () {
      final list = ObservableList.of([0]);

      var count = 0;

      list
        ..observe((change) {
          count++;
        })
        ..add(1);

      expect(count, equals(1));
    });

    test('asMap returns an observable and unmodifiable view to the list', () {
      final list = ObservableList.of([1, 2, 3]);
      final map = list.asMap();

      var mapChanges = 0;
      autorun((_) {
        mapChanges++;
        map.forEach((_, __) {});
      });
      expect(mapChanges, equals(1));

      list.add(4);
      expect(mapChanges, equals(2));
    });

    group('fires reportObserved() for read-methods', () {
      <String, Function(ObservableList<int>)>{
        'isEmpty': (_) => _.isEmpty,
        'isNotEmpty': (_) => _.isNotEmpty,
        'iterator': (_) => _.iterator,
        'single': (_) => _ignoreException(() => _.single),
        'first': (_) => _ignoreException(() => _.first),
        'last': (_) => _ignoreException(() => _.last),
        'toSet': (_) => _.toSet(),
        'toList': (_) => _.toList(),
        'join': (_) => _.join(),
        'fold': (_) => _.fold(0, (sum, item) => sum),
        'sublist': (_) => _.sublist(0),
        'elementAt': (_) => _ignoreException(() => _.elementAt(0)),
        'singleWhere': (_) => _ignoreException(
            () => _.singleWhere((_) => _ == 20, orElse: () => 0)),
        'lastIndexOf': (_) => _.lastIndexOf(20),
        'indexOf': (_) => _.indexOf(20),
        'getRange': (_) => _.getRange(0, 0),

        // ignore: avoid_function_literals_in_foreach_calls
        'forEach': (_) => _.forEach((_a) {}),

        'contains': (_) => _.contains(null),
        'indexWhere': (_) => _.indexWhere((_) => true),
        'lastWhere': (_) => _.lastWhere((_) => true, orElse: () => 0),
        'lastIndexWhere': (_) => _.lastIndexWhere((_) => true),
        'firstWhere': (_) => _.firstWhere((_) => true, orElse: () => 0),
        'every': (_) => _.every((_) => true),
        'any': (_) => _.any((_) => true),
        '[]': (_) => _[0],
        '+': (_) => _ + [100],
      }.forEach(_templateReadTest);
    });
  });

  group('fires reportChanged() for write-methods', () {
    <String, void Function(ObservableList<int>)>{
      'length=': (_) => _.length = 0,
      'last=': (_) => _.last = 100,
      'first=': (_) => _.first = 100,
      'insertAll': (_) => _.insertAll(0, [100]),
      'insert': (_) => _.insert(0, 100),
      'sort': (_) => _.sort(),
      'setRange': (_) => _.setRange(0, 1, [100]),
      'fillRange': (_) => _.fillRange(0, 2, 100),
      'replaceRange': (_) => _.replaceRange(0, 0, [100]),
      'setAll': (_) => _.setAll(0, [100]),
      '[]=': (_) => _[0] = 100,
      'add': (_) => _.add(100),
      'addAll': (_) => _.addAll([100]),
      'clear': (_) => _.clear(),
      'removeLast': (_) => _.removeLast(),
      'remove': (_) => _.remove(0),
      'removeRange': (_) => _.removeRange(0, 1),
      'removeAt': (_) => _.removeAt(0),
      'removeWhere': (_) => _.removeWhere((_) => true),
      'shuffle': (_) => _.shuffle(),
      'retainWhere': (_) => _.retainWhere((_) => false),
    }.forEach(_templateWriteTest);
  });

  group('fires reportObserved() lazily on iterator returning methods', () {
    <String, Iterable Function(ObservableList<int>)>{
      'map': (_) => _.map((v) => v + 3),
      'expand': (_) => _.expand((v) => [3, 2]),
      'where': (_) => _.where((v) => v < 30),
      'whereType': (_) => _.whereType<int>(),
      'skip': (_) => _.skip(0),
      'skipWhile': (_) => _.skipWhile((v) => v > 100),
      'followedBy': (_) => _.followedBy([30]),
      'take': (_) => _.take(1),
      'takeWhile': (_) => _.takeWhile((_) => true),
      'cast': (_) => _.cast<num>(),
      'reversed': (_) => _.reversed
    }.forEach(_templateIterableReadTest);
  });
}

dynamic _ignoreException(Function fn) {
  try {
    return fn();
  } on Object catch (_) {
    // Catching on Object since it takes care of both Error and Exception
    // Ignore
    return null;
  }
}

void _templateReadTest(
    String description, void Function(ObservableList<int>) fn) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    fn(list);

    verify(atom.reportObserved());
    verifyNever(atom.reportChanged());
  });
}

void _templateWriteTest(
    String description, void Function(ObservableList<int>) fn) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    // fire the write method, causing reportChanged() to be invoked.
    fn(list);

    verify(atom.reportChanged());
  });
}

void _templateIterableReadTest(
    String description, Iterable Function(ObservableList<int>) testCase) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    // No reports on iterator iterator transformation
    final iterable = testCase(list);

    verifyNever(atom.reportObserved());
    verifyNever(atom.reportChanged());

    // Observation reports happen when the iterator is iterated
    // ignore:avoid_function_literals_in_foreach_calls
    iterable.forEach((_) {});

    verify(atom.reportObserved());
    verifyNever(atom.reportChanged());
  });
}
