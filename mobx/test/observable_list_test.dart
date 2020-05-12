import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

void main() {
  testSetup();

  group('ObservableList', () {
    test('generates a name if not given', () {
      final list = ObservableList.of([]);
      expect(list.name, matches(RegExp(r'ObservableList\<.*\>@')));
    });

    test('uses the name if given', () {
      final list = ObservableList.of([], name: 'test');
      expect(list.name, equals('test'));
    });

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

    test('ListChange basics', () {
      expect(() => ElementChange(index: null), throwsA(const TypeMatcher<AssertionError>()));
      expect(() => RangeChange(index: null), throwsA(const TypeMatcher<AssertionError>()));
    });
  
    test('observe with fireImmediately works', () {
      final list = ObservableList.of([0]);

      var count = 0;

      list
        ..observe((change) {
          count++;
        }, fireImmediately: true)
        ..add(1);

      // 1 + 1: fireImmediately + add
      expect(count, equals(2));
    });

    test('observe set length works', () {
      final list = ObservableList.of([0]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..length = 5;
      expect(index, equals(1));
      expect(addedValues, equals(List.filled(4, null)));
      expect(removedValues, equals(null));

      list.length = 3;
      expect(index, equals(3));
      expect(addedValues, equals(null));
      expect(removedValues, equals(List.filled(2, null)));

      print('final size ${list.length}');
    });

    test('observe insert item works', () {
      final list = ObservableList.of([1]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges.length, equals(1));
            index = change.rangeChanges.first.index;
            addedValues = change.rangeChanges.first.newValues;
            removedValues = change.rangeChanges.first.oldValues;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges.length, equals(1));
            index = change.elementChanges.first.index;
            expect(change.elementChanges.first.type, equals(OperationType.add));
            addedValues = [change.elementChanges.first.newValue];
            removedValues = null;
          }
        })
        ..insert(0, 0);

      expect(index, equals(0));
      expect(addedValues, equals([0]));
      expect(removedValues, equals(null));
    });

    test('observe insertAll works', () {
      final list = ObservableList.of([0, 4]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..insertAll(1, [1, 2, 3]);

      expect(index, equals(1));
      expect(addedValues, equals([1, 2, 3]));
      expect(removedValues, equals(null));
    });

    test('observe add item works', () {
      final list = ObservableList.of([0]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges.length, equals(1));
            index = change.rangeChanges.first.index;
            addedValues = change.rangeChanges.first.newValues;
            removedValues = change.rangeChanges.first.oldValues;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges.length, equals(1));
            index = change.elementChanges.first.index;
            expect(change.elementChanges.first.type, equals(OperationType.add));
            addedValues = [change.elementChanges.first.newValue];
            removedValues = null;
          }
        })
        ..add(1);

      expect(index, equals(1));
      expect(addedValues, equals([1]));
      expect(removedValues, equals(null));
    });

    test('observe addAll items works', () {
      final list = ObservableList.of([0]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..addAll([1, 2]);

      expect(index, equals(1));
      expect(addedValues, equals([1, 2]));
      expect(removedValues, equals(null));
      print('final size ${list.length}');
    });

    test('observe first works', () {
      final list = ObservableList.of([0]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges.length, equals(1));
            index = change.rangeChanges.first.index;
            addedValues = change.rangeChanges.first.newValues;
            removedValues = change.rangeChanges.first.oldValues;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges.length, equals(1));
            index = change.elementChanges.first.index;
            expect(change.elementChanges.first.type, equals(OperationType.update));
            addedValues = [change.elementChanges.first.newValue];
            removedValues = [change.elementChanges.first.oldValue];
          }
        })
        ..first = 1;

      expect(index, equals(0));
      expect(addedValues, equals([1]));
      expect(removedValues, equals([0]));
    });

    test('observe clear works', () {
      final list = ObservableList.of([0, 1, 2]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..clear();

      expect(index, equals(0));
      expect(addedValues, equals(null));
      expect(removedValues, equals([0, 1, 2]));
    });

    test('observe fillRange works', () {
      final list = ObservableList.of([0, 1, 2]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..fillRange(1, 3, 7);

      expect(index, equals(1));
      expect(addedValues, equals([7, 7]));
      expect(removedValues, equals([1, 2]));
    });

    test('observe remove works', () {
      final list = ObservableList.of([0, 1, null]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list.observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges.length, equals(1));
            index = change.rangeChanges.first.index;
            addedValues = change.rangeChanges.first.newValues;
            removedValues = change.rangeChanges.first.oldValues;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges.length, equals(1));
            index = change.elementChanges.first.index;
            expect(change.elementChanges.first.type, equals(OperationType.remove));
            addedValues = null;
            removedValues = [change.elementChanges.first.oldValue];
          }
        });
        
      expect(list.remove(-1), equals(false));

      expect(list.remove(1), equals(true));
      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([1]));

      expect(list.remove(null), equals(true));
      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([null]));
    });

    test('observe removeAt works', () {
      final list = ObservableList.of([0, null, 1]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list.observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges.length, equals(1));
            index = change.rangeChanges.first.index;
            addedValues = change.rangeChanges.first.newValues;
            removedValues = change.rangeChanges.first.oldValues;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges.length, equals(1));
            index = change.elementChanges.first.index;
            expect(change.elementChanges.first.type, equals(OperationType.remove));
            addedValues = null;
            removedValues = [change.elementChanges.first.oldValue];
          }
        });

      expect(list.removeAt(1), equals(null));
      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([null]));

      expect(list.removeAt(1), equals(1));
      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([1]));
    });

    test('observe removeLast works', () {
      final list = ObservableList<int>.of([0, 1, 2, 3]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges.length, equals(1));
            index = change.rangeChanges.first.index;
            addedValues = change.rangeChanges.first.newValues;
            removedValues = change.rangeChanges.first.oldValues;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges.length, equals(1));
            index = change.elementChanges.first.index;
            expect(change.elementChanges.first.type, equals(OperationType.remove));
            addedValues = null;
            removedValues = [change.elementChanges.first.oldValue];
          }
        })
        ..removeLast();

      expect(index, equals(3));
      expect(addedValues, equals(null));
      expect(removedValues, equals([3]));
    });

    test('observe removeRange works', () {
      final list = ObservableList<int>.of([0, -1, -2, 3]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..removeRange(1, 3);

      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([-1, -2]));
    });

    test('observe replaceRange works', () {
      final list = ObservableList<int>.of([0, -1, -2, 3]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];
      final replacement = [1, 2];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..replaceRange(1, 3, replacement);

      expect(index, equals(1));
      expect(addedValues, equals(replacement));
      expect(removedValues, equals([-1, -2]));
    });

    test('observe removeWhere works', () {
      final list = ObservableList<int>.of([0, -1, 2, -3]);

      final indexes = <int>[];
      final removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.elementChanges, isNotNull);
          for (var elementChange in change.elementChanges) {
            expect(elementChange.type, equals(OperationType.remove));
            indexes.add(elementChange.index);
            removedValues.add(elementChange.oldValue);
          }
        })
        ..removeWhere((element) => element < 0);

      expect(indexes, equals([1, 3]));
      expect(removedValues, equals([-1, -3]));
    });

    test('observe retainWhere works', () {
      final list = ObservableList<int>.of([0, -1, 2, -3]);

      final indexes = <int>[];
      final removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.elementChanges, isNotNull);
          for (var elementChange in change.elementChanges) {
            expect(elementChange.type, equals(OperationType.remove));
            indexes.add(elementChange.index);
            removedValues.add(elementChange.oldValue);
          }
        })
        ..retainWhere((element) => element < 0);

      expect(indexes, equals([0, 2]));
      expect(removedValues, equals([0, 2]));
    });

    test('observe setAll works', () {
      final list = ObservableList<int>.of([0, -1, -2, 3]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];
      final replacement = [1, 2];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..setAll(1, replacement);

      expect(index, equals(1));
      expect(addedValues, equals(replacement));
      expect(removedValues, equals([-1, -2]));
    });

    test('observe setRange works', () {
      final list = ObservableList<int>.of([0, -1, -2, 3]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges.length, equals(1));
          index = change.rangeChanges.first.index;
          addedValues = change.rangeChanges.first.newValues;
          removedValues = change.rangeChanges.first.oldValues;
        })
        ..setRange(1, 3, [0, 1, 2, 3], 1);

      expect(index, equals(1));
      expect(addedValues, equals([1, 2]));
      expect(removedValues, equals([-1, -2]));
    });

    test('observe sort works', () {
      final list = ObservableList<int>.of([0, -1, 2, -3]);

      final indexes = <int>[];
      final addedValues = <int>[];
      final removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.elementChanges, isNotNull);
          for (var elementChange in change.elementChanges) {
            expect(elementChange.type, equals(OperationType.update));
            indexes.add(elementChange.index);
            addedValues.add(elementChange.newValue);
            removedValues.add(elementChange.oldValue);
          }
        })
        ..sort();

      expect(indexes, equals([0, 2, 3]));
      expect(addedValues, equals([-3, 0, 2]));
      expect(removedValues, equals([0, 2, -3]));
    });

    test('shuffle do not produce excess changes', () {
      final list = ObservableList<int>.of([1, 1, 1]);

      var fired = false;

      list
        ..observe((change) { fired = true; })
        ..shuffle();

      // All elements of list are equal, so shuffling should have no effect.
      expect(fired, isFalse);
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
    <String, bool Function(ObservableList<int>)>{
      'length=': (_) { _.length = 0; return true; },
      'last=': (_) { _.last = 100; return true; },
      'first=': (_) { _.first = 100; return true; },
      'insertAll': (_) { _.insertAll(0, [100]); return true; },
      'insert': (_) { _.insert(0, 100); return true; },
      'sort': (_) { _.sort((l, r) => r.compareTo(l)); return true; },
      'setRange': (_) { _.setRange(0, 1, [100]); return true; },
      'fillRange': (_) { _.fillRange(0, 2, 100); return true; },
      'replaceRange': (_) { _.replaceRange(0, 1, [100]); return true; },
      'setAll': (_) { _.setAll(0, [100]); return true; },
      '[]=': (_) { _[0] = 100; return true; },
      'add': (_) { _.add(100); return true; },
      'addAll': (_) { _.addAll([100]); return true; },
      'clear': (_) { _.clear(); return true; },
      'removeLast': (_) { _.removeLast(); return true; },
      'remove': (_) { _.remove(0); return true; },
      'removeRange': (_) { _.removeRange(0, 1); return true; },
      'removeAt': (_) { _.removeAt(0); return true; },
      'removeWhere': (_) { _.removeWhere((_) => true); return true; },
      'shuffle': (_) { _.shuffle(); return true; },
      'retainWhere': (_) { _.retainWhere((_) => false); return true; },

      '!length=': (_) { _.length = 4; return false; },
      '!last=': (_) { _.last = 3; return false; },
      '!first=': (_) { _.first = 0; return false; },
      '!insertAll': (_) { _.insertAll(0, []); return false; },
      '!sort': (_) { _.sort(); return false; },
      '!setRange': (_) { _.setRange(1, 1, [100]); return false; },
      '!fillRange': (_) { _.fillRange(2, 2, 100); return false; },
      '!replaceRange': (_) { _.replaceRange(1, 1, []); return false; },
      '!setAll': (_) { _.setAll(0, []); return false; },
      '![]=': (_) { _[2] = 2; return false; },
      '!addAll': (_) { _.addAll([]); return false; },
      '!remove': (_) { _.remove(-1); return false; },
      '!removeRange': (_) { _.removeRange(1, 1); return false; },
      '!removeWhere': (_) { _.removeWhere((_) => false); return false; },
      '!retainWhere': (_) { _.retainWhere((_) => true); return false; },
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
    String description, bool Function(ObservableList<int>) fn) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    verifyNever(atom.reportChanged());
    verifyNever(atom.reportObserved());

    // fire the method caused or not the reportChanged() to be invoked.
    fn(list)
      ? verify(atom.reportChanged())
      : verifyNever(atom.reportChanged());
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
