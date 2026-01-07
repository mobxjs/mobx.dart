import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:mobx/src/api/observable_collections.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

// ignore_for_file: unnecessary_lambdas

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
        // ignore: unused_local_variable
        for (final x in list) {
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

    test(
      'observe with fireImmediately should not send events to already registered listeners',
      () {
        final list = ObservableList.of([0]);

        var count1 = 0;
        var count2 = 0;

        list.observe((change) {
          count1++;
        });

        list.observe((change) {
          count2++;
        }, fireImmediately: true);

        list.add(1);

        // 0 + 1: add
        expect(count1, equals(1));
        // 1 + 1: fireImmediately + add
        expect(count2, equals(2));
      },
    );

    test('observe set length works', () {
      // ignore: omit_local_variable_types
      final ObservableList<int?> list = ObservableList.of([0]);

      var index = -1;
      List<int?>? addedValues = [];
      List<int?>? removedValues = [];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges?.first.newValues;
          removedValues = change.rangeChanges?.first.oldValues;
        })
        ..length = 5;
      expect(index, equals(1));
      expect(addedValues, equals(List.filled(4, null)));
      expect(removedValues, equals(null));

      list.length = 3;
      expect(index, equals(3));
      expect(addedValues, equals(null));
      expect(removedValues, equals(List.filled(2, null)));
    });

    test('observe insert item works', () {
      final list = ObservableList.of([1]);

      var index = -1;
      var addedValues = <int>[];
      List<int>? removedValues = <int>[];

      list
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
              change.elementChanges!.first.type,
              equals(OperationType.add),
            );
            addedValues = [change.elementChanges!.first.newValue!];
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
      List<int>? addedValues;
      List<int>? removedValues;

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges?.first.newValues;
          removedValues = change.rangeChanges?.first.oldValues;
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
      List<int>? removedValues = <int>[];

      list
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
              change.elementChanges!.first.type,
              equals(OperationType.add),
            );
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
      final list = ObservableList.of([0]);

      var index = -1;
      List<int>? addedValues;
      List<int>? removedValues;

      list
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

    test('observe first works', () {
      final list = ObservableList.of([0]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
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
              change.elementChanges!.first.type,
              equals(OperationType.update),
            );
            addedValues = [change.elementChanges!.first.newValue!];
            removedValues = [change.elementChanges!.first.oldValue!];
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
      List<int>? addedValues;
      List<int>? removedValues;

      list
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

    test('observe fillRange works', () {
      final list = ObservableList.of([0, 1, 2]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges!.first.newValues!;
          removedValues = change.rangeChanges!.first.oldValues!;
        })
        ..fillRange(1, 3, 7);

      expect(index, equals(1));
      expect(addedValues, equals([7, 7]));
      expect(removedValues, equals([1, 2]));
    });

    test('observe remove works', () {
      final list = ObservableList.of([0, 1, null]);

      var index = -1;
      List<int?>? addedValues = <int>[];
      List<int?> removedValues = <int>[];

      list.observe((change) {
        if (change.rangeChanges != null) {
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges!.first.newValues!;
          removedValues = change.rangeChanges!.first.oldValues!;
        } else if (change.elementChanges != null) {
          expect(change.elementChanges!.length, equals(1));
          index = change.elementChanges!.first.index;
          expect(
            change.elementChanges!.first.type,
            equals(OperationType.remove),
          );
          addedValues = null;
          removedValues = [change.elementChanges!.first.oldValue];
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
      List<int?>? addedValues;
      List<int?>? removedValues;

      list.observe((change) {
        if (change.rangeChanges != null) {
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges?.first.newValues;
          removedValues = change.rangeChanges?.first.oldValues;
        } else if (change.elementChanges != null) {
          expect(change.elementChanges!.length, equals(1));
          index = change.elementChanges!.first.index;
          expect(
            change.elementChanges!.first.type,
            equals(OperationType.remove),
          );
          addedValues = null;
          removedValues = [change.elementChanges?.first.oldValue];
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
      List<int>? addedValues = [];
      var removedValues = <int>[];

      list
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
              change.elementChanges!.first.type,
              equals(OperationType.remove),
            );
            addedValues = null;
            removedValues = [change.elementChanges!.first.oldValue!];
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
      List<int>? addedValues;
      List<int>? removedValues;

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges?.first.newValues;
          removedValues = change.rangeChanges?.first.oldValues;
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
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges!.first.newValues!;
          removedValues = change.rangeChanges!.first.oldValues!;
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
      final list = ObservableList<int>.of([0, -1, 2, -3]);

      final indexes = <int>[];
      final removedValues = <int>[];

      list
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

    test('observe setAll works', () {
      final list = ObservableList<int>.of([0, -1, -2, 3]);

      var index = -1;
      var addedValues = <int>[];
      var removedValues = <int>[];
      final replacement = [1, 2];

      list
        ..observe((change) {
          expect(change.rangeChanges, isNotNull);
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges!.first.newValues!;
          removedValues = change.rangeChanges!.first.oldValues!;
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
          expect(change.rangeChanges!.length, equals(1));
          index = change.rangeChanges!.first.index;
          addedValues = change.rangeChanges!.first.newValues!;
          removedValues = change.rangeChanges!.first.oldValues!;
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
          for (var elementChange in change.elementChanges!) {
            expect(elementChange.type, equals(OperationType.update));
            indexes.add(elementChange.index);
            addedValues.add(elementChange.newValue!);
            removedValues.add(elementChange.oldValue!);
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
        ..observe((change) {
          fired = true;
        })
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
        'isEmpty': (list) => list.isEmpty,
        'isNotEmpty': (list) => list.isNotEmpty,
        'iterator': (list) => list.iterator,
        'single': (list) => _ignoreException(() => list.single),
        'first': (list) => _ignoreException(() => list.first),
        'last': (list) => _ignoreException(() => list.last),
        'toSet': (list) => list.toSet(),
        'toList': (list) => list.toList(),
        'join': (list) => list.join(),
        'fold': (list) => list.fold(0, (sum, item) => sum),
        'sublist': (list) => list.sublist(0),
        'elementAt': (list) => _ignoreException(() => list.elementAt(0)),
        'singleWhere':
            (list) => _ignoreException(
              () => list.singleWhere((x) => x == 20, orElse: () => 0),
            ),
        'lastIndexOf': (list) => list.lastIndexOf(20),
        'indexOf': (list) => list.indexOf(20),
        'getRange': (list) => list.getRange(0, 0),

        // ignore: avoid_function_literals_in_foreach_calls
        'forEach': (list) => list.forEach((a) {}),

        'contains': (list) => list.contains(null),
        'indexWhere': (list) => list.indexWhere((_) => true),
        'lastWhere': (list) => list.lastWhere((_) => true, orElse: () => 0),
        'lastIndexWhere': (list) => list.lastIndexWhere((_) => true),
        'firstWhere': (list) => list.firstWhere((_) => true, orElse: () => 0),
        'every': (list) => list.every((_) => true),
        'any': (list) => list.any((_) => true),
        '[]': (list) => list[0],
        '+': (list) => list + [100],
      }.forEach(_templateReadTest);

      test('bypass observable system', () {
        final list = ObservableList<int>();

        int? nonObservableInnerLength;
        autorun(
          (_) => nonObservableInnerLength = list.nonObservableInner.length,
        );

        expect(list.nonObservableInner.length, 0);
        expect(nonObservableInnerLength, equals(0));

        list.add(20);

        expect(list.nonObservableInner.length, 1);
        expect(
          nonObservableInnerLength,
          equals(0),
          reason: 'should not be observable',
        );
      });
    });
  });

  group('fires reportChanged() for write-methods', () {
    <String, bool Function(ObservableList<int>)>{
      'length=': (x) {
        x.length = 0;
        return true;
      },
      'last=': (x) {
        x.last = 100;
        return true;
      },
      'first=': (x) {
        x.first = 100;
        return true;
      },
      'insertAll': (x) {
        x.insertAll(0, [100]);
        return true;
      },
      'insert': (x) {
        x.insert(0, 100);
        return true;
      },
      'sort': (x) {
        x.sort((l, r) => r.compareTo(l));
        return true;
      },
      'setRange': (x) {
        x.setRange(0, 1, [100]);
        return true;
      },
      'fillRange': (x) {
        x.fillRange(0, 2, 100);
        return true;
      },
      'replaceRange': (x) {
        x.replaceRange(0, 1, [100]);
        return true;
      },
      'setAll': (x) {
        x.setAll(0, [100]);
        return true;
      },
      '[]=': (x) {
        x[0] = 100;
        return true;
      },
      'add': (x) {
        x.add(100);
        return true;
      },
      'addAll': (x) {
        x.addAll([100]);
        return true;
      },
      'clear': (x) {
        x.clear();
        return true;
      },
      'removeLast': (x) {
        x.removeLast();
        return true;
      },
      'remove': (x) {
        x.remove(0);
        return true;
      },
      'removeRange': (x) {
        x.removeRange(0, 1);
        return true;
      },
      'removeAt': (x) {
        x.removeAt(0);
        return true;
      },
      'removeWhere': (x) {
        x.removeWhere((x) => true);
        return true;
      },
      'shuffle': (x) {
        x.shuffle(Random(0));
        return true;
      },
      'retainWhere': (x) {
        x.retainWhere((x) => false);
        return true;
      },
      '!length=': (x) {
        x.length = 4;
        return false;
      },
      '!last=': (x) {
        x.last = 3;
        return false;
      },
      '!first=': (x) {
        x.first = 0;
        return false;
      },
      '!insertAll': (x) {
        x.insertAll(0, []);
        return false;
      },
      '!sort': (x) {
        x.sort();
        return false;
      },
      '!setRange': (x) {
        x.setRange(1, 1, [100]);
        return false;
      },
      '!fillRange': (x) {
        x.fillRange(2, 2, 100);
        return false;
      },
      '!replaceRange': (x) {
        x.replaceRange(1, 1, []);
        return false;
      },
      '!setAll': (x) {
        x.setAll(0, []);
        return false;
      },
      '![]=': (x) {
        x[2] = 2;
        return false;
      },
      '!addAll': (x) {
        x.addAll([]);
        return false;
      },
      '!remove': (x) {
        x.remove(-1);
        return false;
      },
      '!removeRange': (x) {
        x.removeRange(1, 1);
        return false;
      },
      '!removeWhere': (x) {
        x.removeWhere((x) => false);
        return false;
      },
      '!retainWhere': (x) {
        x.retainWhere((x) => true);
        return false;
      },
    }.forEach(_templateWriteTest);
  });

  group('fires reportObserved() lazily on iterator returning methods', () {
    <String, Iterable Function(ObservableList<int>)>{
      'map': (list) => list.map((v) => v + 3),
      'expand': (list) => list.expand((v) => [3, 2]),
      'where': (list) => list.where((v) => v < 30),
      'whereType': (list) => list.whereType<int>(),
      'skip': (list) => list.skip(0),
      'skipWhile': (list) => list.skipWhile((v) => v > 100),
      'followedBy': (list) => list.followedBy([30]),
      'take': (list) => list.take(1),
      'takeWhile': (list) => list.takeWhile((_) => true),
      'cast': (list) => list.cast<num>(),
      'reversed': (list) => list.reversed,
    }.forEach(_templateIterableReadTest);
  });

  group('checks for iterable use with ObservableList', () {
    test('ObservableList addAll runs Iterable only once', () {
      final list = ObservableList<String>();
      var op = '';

      list.addAll(
        [1, 2].map((e) {
          op += '$e';

          return '$e';
        }),
      );

      expect(op, '12');
      expect(list.join(''), '12');
    });

    test('ObservableList insertAll runs Iterable only once', () {
      final list = ObservableList<String>.of(['1']);
      var op = '';

      list.insertAll(
        1,
        [2, 3].map((e) {
          op += '$e';

          return '$e';
        }),
      );

      expect(op, '23');
      expect(list.join(''), '123');
    });

    test('ObservableList replaceRange runs Iterable only once', () {
      final list = ObservableList<String>.of(['1', '2', '3']);
      var op = '';

      list.replaceRange(
        0,
        2,
        [4, 5].map((e) {
          op += '$e';

          return '$e';
        }),
      );

      expect(op, '45');
      expect(list.join(''), '453');
    });

    test('ObservableList setAll runs Iterable only once', () {
      final list = ObservableList<String>.of(['1', '2', '3']);
      var op = '';

      list.setAll(
        0,
        [4, 5, 6].map((e) {
          op += '$e';

          return '$e';
        }),
      );

      expect(op, '456');
      expect(list.join(''), '456');
    });

    test('ObservableList setRange runs Iterable only once', () {
      final list = ObservableList<String>.of([
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
      ]);
      var op = '';

      list.setRange(
        1,
        4,
        [8, 9, 10].map((e) {
          op += '$e';

          return '$e';
        }),
      );

      expect(op, '8910');
    });
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
  String description,
  void Function(ObservableList<int>) fn,
) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    verifyNever(() => atom.reportChanged());
    verifyNever(() => atom.reportObserved());

    fn(list);

    verify(() => atom.reportObserved());
    verifyNever(() => atom.reportChanged());
  });
}

void _templateWriteTest(
  String description,
  bool Function(ObservableList<int>) fn,
) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    verifyNever(() => atom.reportChanged());
    verifyNever(() => atom.reportObserved());

    // fire the method caused or not the reportChanged() to be invoked.
    fn(list)
        ? verify(() => atom.reportChanged())
        : verifyNever(() => atom.reportChanged());
  });
}

void _templateIterableReadTest(
  String description,
  Iterable Function(ObservableList<int>) testCase,
) {
  test(description, () {
    final atom = MockAtom();
    final list = wrapInObservableList(atom, [0, 1, 2, 3]);

    // No reports on iterator iterator transformation
    final iterable = testCase(list);

    verifyNever(() => atom.reportObserved());
    verifyNever(() => atom.reportChanged());

    // Observation reports happen when the iterator is iterated
    // ignore:avoid_function_literals_in_foreach_calls
    iterable.forEach((_) {});

    verify(() => atom.reportObserved());
    verifyNever(() => atom.reportChanged());
  });
}
