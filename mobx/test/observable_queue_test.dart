import 'dart:collection';

import 'package:mobx/mobx.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

// ignore_for_file: unnecessary_lambdas

void main() {
  testSetup();

  group('ObservableQueue', () {
    test('generates a name if not given', () {
      final queue = ObservableQueue.of([]);
      expect(queue.name, matches(RegExp(r'ObservableQueue\<.*\>@')));
    });

    test('uses the name if given', () {
      final queue = ObservableQueue.of([], name: 'test');
      expect(queue.name, equals('test'));
    });

    test('basics work', () {
      final queue = ObservableQueue<int>();
      var count = -1;

      expect(queue.name, startsWith('ObservableQueue<int>@'));

      final d = autorun((_) {
        count = queue.length;
      });

      expect(count, equals(0));

      queue.add(20);
      expect(count, equals(1));
      d();
    });

    test('cast returns a live view to queue', () {
      final queue = ObservableQueue<num>.of(<num>[0, 1, 2, 3, 4, 5, 6]);
      final casted = queue.cast<int>();

      var count = 0;
      autorun((_) {
        // ignore:unnecessary_statements
        casted.first;
        count++;
      });
      expect(count, equals(1));

      queue.addFirst(99);
      expect(casted.first, equals(99));
      expect(count, equals(2));
    });

    test('Autorun should execute when items are added to an empty queue', () {
      final queue = ObservableQueue<int>();

      var count = 0;
      autorun((_) {
        // ignore: unused_local_variable
        for (final x in queue) {
          count++;
        }
      });
      expect(count, equals(0));

      queue.add(0);
      expect(count, equals(1));
    });

    test('observe basics work', () {
      final queue = ObservableQueue.of([0]);

      var count = 0;

      queue
        ..observe((change) {
          count++;
        })
        ..add(1);

      expect(count, equals(1));
    });

    test('observe with fireImmediately works', () {
      final queue = ObservableQueue.of([0]);

      var count = 0;

      queue
        ..observe((change) {
          count++;
        }, fireImmediately: true)
        ..add(1);

      // 1 + 1: fireImmediately + add
      expect(count, equals(2));
    });

    test('observe add item works', () {
      final queue = ObservableQueue.of([0]);

      var index = -1;
      var addedValues = <int>[];
      List<int>? removedValues = <int>[];

      queue
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges!.length, equals(1));
            index = change.rangeChanges!.first.index;
            addedValues = change.rangeChanges!.first.newValues!;
            removedValues = change.rangeChanges!.first.oldValues!;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges!.length, equals(1));
            index = change.elementChanges!.first.index;
            expect(
                change.elementChanges!.first.type, equals(OperationType.add));
            addedValues = [change.elementChanges!.first.newValue!];
            removedValues = null;
          }
        })
        ..add(1);

      expect(index, equals(1));
      expect(addedValues, equals([1]));
      expect(removedValues, equals(null));
    });

    test('observe addAll items works', () {
      final queue = ObservableQueue.of([0]);

      var index = -1;
      List<int>? addedValues;
      List<int>? removedValues;

      queue
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges?.first.newValues;
          removedValues = change.rangeChanges?.first.oldValues;
        })
        ..addAll([1, 2]);

      expect(index, equals(1));
      expect(addedValues, equals([1, 2]));
      expect(removedValues, equals(null));
    });

    test('observe add first works', () {
      final queue = ObservableQueue.of([0]);

      var index = -1;
      var addedValues = <int>[];
      List<int>? removedValues = <int>[];

      queue
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges!.length, equals(1));
            index = change.rangeChanges!.first.index;
            addedValues = change.rangeChanges!.first.newValues!;
            removedValues = change.rangeChanges!.first.oldValues!;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges!.length, equals(1));
            index = change.elementChanges!.first.index;
            expect(
                change.elementChanges!.first.type, equals(OperationType.add));
            addedValues = [change.elementChanges!.first.newValue!];
            removedValues = null;
          }
        })
        ..addFirst(1);

      expect(index, equals(0));
      expect(addedValues, equals([1]));
      expect(removedValues, equals(null));
    });

    test('observe clear works', () {
      final queue = ObservableQueue.of([0, 1, 2]);

      var index = -1;
      List<int>? addedValues;
      List<int>? removedValues;

      queue
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges?.first.newValues;
          removedValues = change.rangeChanges?.first.oldValues;
        })
        ..clear();

      expect(index, equals(0));
      expect(addedValues, equals(null));
      expect(removedValues, equals([0, 1, 2]));
    });

    test('observe remove works', () {
      final queue = ObservableQueue.of([0, 1, null]);

      var index = -1;
      List<int?>? addedValues = <int>[];
      List<int?> removedValues = <int>[];

      queue.observe((change) {
        if (change.rangeChanges != null) {
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges!.first.newValues!;
          removedValues = change.rangeChanges!.first.oldValues!;
        } else if (change.elementChanges != null) {
          expect(change.elementChanges!.length, equals(1));
          index = change.elementChanges!.first.index;
          expect(
              change.elementChanges!.first.type, equals(OperationType.remove));
          addedValues = null;
          removedValues = [change.elementChanges!.first.oldValue];
        }
      });

      expect(queue.remove(-1), equals(false));

      expect(queue.remove(1), equals(true));
      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([1]));

      expect(queue.remove(null), equals(true));
      expect(index, equals(1));
      expect(addedValues, equals(null));
      expect(removedValues, equals([null]));
    });

    test('observe removeLast works', () {
      final queue = ObservableQueue<int>.of([0, 1, 2, 3]);

      var index = -1;
      List<int>? addedValues = [];
      var removedValues = <int>[];

      queue
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges!.length, equals(1));
            index = change.rangeChanges!.first.index;
            addedValues = change.rangeChanges!.first.newValues!;
            removedValues = change.rangeChanges!.first.oldValues!;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges!.length, equals(1));
            index = change.elementChanges!.first.index;
            expect(change.elementChanges!.first.type,
                equals(OperationType.remove));
            addedValues = null;
            removedValues = [change.elementChanges!.first.oldValue!];
          }
        })
        ..removeLast();

      expect(index, equals(3));
      expect(addedValues, equals(null));
      expect(removedValues, equals([3]));
    });

    test('observe removeFirst works', () {
      final queue = ObservableQueue<int>.of([0, -1, -2, 3]);

      var index = -1;
      List<int>? addedValues;
      List<int>? removedValues;

      queue
        ..observe((change) {
          if (change.rangeChanges != null) {
            expect(change.rangeChanges!.length, equals(1));
            index = change.rangeChanges!.first.index;
            addedValues = change.rangeChanges!.first.newValues!;
            removedValues = change.rangeChanges!.first.oldValues!;
          } else if (change.elementChanges != null) {
            expect(change.elementChanges!.length, equals(1));
            index = change.elementChanges!.first.index;
            expect(change.elementChanges!.first.type,
                equals(OperationType.remove));
            addedValues = null;
            removedValues = [change.elementChanges!.first.oldValue!];
          }
        })
        ..removeFirst();

      expect(index, equals(0));
      expect(addedValues, equals(null));
      expect(removedValues, equals([0]));
    });

    test('observe removeWhere works', () {
      final queue = ObservableQueue<int>.of([0, -1, 2, -3]);

      final indexes = <int>[];
      final removedValues = <int>[];

      queue
        ..observe((change) {
          expect(change.elementChanges, isNotNull);
          for (var elementChange in change.elementChanges!) {
            expect(elementChange.type, equals(OperationType.remove));
            indexes.add(elementChange.index);
            removedValues.add(elementChange.oldValue!);
          }
        })
        ..removeWhere((element) => element < 0);

      expect(indexes, equals([1, 3]));
      expect(removedValues, equals([-1, -3]));
    });

    test('observe retainWhere works', () {
      final queue = ObservableQueue<int>.of([0, -1, 2, -3]);

      final indexes = <int>[];
      final removedValues = <int>[];

      queue
        ..observe((change) {
          expect(change.elementChanges, isNotNull);
          for (var elementChange in change.elementChanges!) {
            expect(elementChange.type, equals(OperationType.remove));
            indexes.add(elementChange.index);
            removedValues.add(elementChange.oldValue!);
          }
        })
        ..retainWhere((element) => element < 0);

      expect(indexes, equals([0, 2]));
      expect(removedValues, equals([0, 2]));
    });

    group('fires reportObserved() for read-methods', () {
      <String, Function(ObservableQueue<int>)>{
        'isEmpty': (_) => _.isEmpty,
        'isNotEmpty': (_) => _.isNotEmpty,
        'single': (_) => _ignoreException(() => _.single),
        'first': (_) => _ignoreException(() => _.first),
        'last': (_) => _ignoreException(() => _.last),
        'toSet': (_) => _.toSet(),
        'toList': (_) => _.toList(),
        'join': (_) => _.join(),
        'fold': (_) => _.fold(0, (sum, item) => sum),
        'elementAt': (_) => _ignoreException(() => _.elementAt(0)),
        'singleWhere': (_) => _ignoreException(
            () => _.singleWhere((_) => _ == 20, orElse: () => 0)),

        // ignore: avoid_function_literals_in_foreach_calls
        'forEach': (_) => _.forEach((a) {}),

        'contains': (_) => _.contains(null),
        'lastWhere': (_) => _.lastWhere((_) => true, orElse: () => 0),
        'firstWhere': (_) => _.firstWhere((_) => true, orElse: () => 0),
        'every': (_) => _.every((_) => true),
        'any': (_) => _.any((_) => true),
      }.forEach(_templateReadTest);
    });
  });

  group(
      'fires reportObserved() for iterable transformation methods only when iterating',
      () {
    <String, Iterable Function(ObservableQueue<int>)>{
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

  group('fires reportChanged() for write-methods', () {
    <String, bool Function(ObservableQueue<int>)>{
      'add': (_) {
        _.add(100);
        return true;
      },
      'addFirst': (_) {
        _.addFirst(100);
        return true;
      },
      'addLast': (_) {
        _.addLast(100);
        return true;
      },
      'addAll': (_) {
        _.addAll([100]);
        return true;
      },
      'clear': (_) {
        _.clear();
        return true;
      },
      'removeLast': (_) {
        _.removeLast();
        return true;
      },
      'remove': (_) {
        _.remove(0);
        return true;
      },
      'removeWhere': (_) {
        _.removeWhere((_) => true);
        return true;
      },
      'retainWhere': (_) {
        _.retainWhere((_) => false);
        return true;
      },
      '!addAll': (_) {
        _.addAll([]);
        return false;
      },
      '!remove': (_) {
        _.remove(-1);
        return false;
      },
      '!removeWhere': (_) {
        _.removeWhere((_) => false);
        return false;
      },
      '!retainWhere': (_) {
        _.retainWhere((_) => true);
        return false;
      },
    }.forEach(_templateWriteTest);
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
    String description, void Function(ObservableQueue<int>) fn) {
  test(description, () {
    final atom = MockAtom();
    final queue = wrapInObservableQueue(atom, Queue.of([0, 1, 2, 3]));

    verifyNever(() => atom.reportChanged());
    verifyNever(() => atom.reportObserved());

    fn(queue);

    verify(() => atom.reportObserved());
    verifyNever(() => atom.reportChanged());
  });
}

void _templateWriteTest(
    String description, bool Function(ObservableQueue<int>) fn) {
  test(description, () {
    final atom = MockAtom();
    final queue = wrapInObservableQueue(atom, Queue.of([0, 1, 2, 3]));

    verifyNever(() => atom.reportChanged());
    verifyNever(() => atom.reportObserved());

    // fire the method caused or not the reportChanged() to be invoked.
    fn(queue)
        ? verify(() => atom.reportChanged())
        : verifyNever(() => atom.reportChanged());
  });
}

void runIterableTest(
    String description, Iterable Function(ObservableQueue<int>) body) {
  test(description, () {
    final atom = MockAtom();
    final map = wrapInObservableQueue(atom, Queue.of([1, 2, 3, 4]));

    verifyNever(() => atom.reportChanged());
    verifyNever(() => atom.reportObserved());

    final iter = body(map);
    verifyNever(() => atom.reportChanged());
    verifyNever(() => atom.reportObserved());

    void noOp(_) {}
    iter.forEach(noOp);
    verify(() => atom.reportObserved());
    verifyNever(() => atom.reportChanged());
  });
}
