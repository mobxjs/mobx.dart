import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  for (final retain in [false, true]) {
    test(
      '${retain ? 'retainWhere' : 'removeWhere'} publishes one coherent original-index change',
      () {
        final list = ObservableList.of([0, 1, 2, 3, 4, 5]);
        final snapshots = <List<int>>[];
        final events = <ListChange<int>>[];
        final predicates = <int>[];
        final dispose = autorun((_) => snapshots.add(list.toList()));
        final stop = list.observe(events.add);
        addTearDown(dispose.call);
        addTearDown(stop);
        bool predicate(int value) {
          predicates.add(value);
          return retain ? value.isOdd : value.isEven;
        }

        if (retain) {
          list.retainWhere(predicate);
        } else {
          list.removeWhere(predicate);
        }
        expect(predicates, [5, 4, 3, 2, 1, 0]);
        expect(snapshots, [
          [0, 1, 2, 3, 4, 5],
          [1, 3, 5],
        ]);
        expect(events.single.elementChanges!.map((e) => e.index), [0, 2, 4]);
        expect(events.single.elementChanges!.map((e) => e.oldValue), [0, 2, 4]);
      },
    );

    test(
      '${retain ? 'retainWhere' : 'removeWhere'} leaves storage untouched on predicate failure',
      () {
        final list = ObservableList.of([1, 2, 3, 4]);
        var notifications = 0;
        list.observe((_) {
          notifications++;
        });
        bool predicate(int value) {
          if (value == 2) throw StateError('predicate');
          return retain ? value.isOdd : value.isEven;
        }

        expect(
          () =>
              retain
                  ? list.retainWhere(predicate)
                  : list.removeWhere(predicate),
          throwsStateError,
        );
        expect(list, [1, 2, 3, 4]);
        expect(notifications, 0);
      },
    );
  }

  test('map bulk methods batch reactions and retain per-entry events', () {
    final map = ObservableMap<int, int>();
    var runs = 0;
    var events = 0;
    final dispose = autorun((_) {
      map.toString();
      runs++;
    });
    final stop = map.observe((_) {
      events++;
    });
    addTearDown(dispose.call);
    addTearDown(stop);
    map.addAll({1: 1, 2: 2, 3: 3});
    expect(runs, 2);
    expect(events, 3);
    map.updateAll((key, value) => value * 2);
    expect(runs, 3);
    expect(events, 6);
    map.addEntries([const MapEntry(4, 8), const MapEntry(5, 10)]);
    expect(runs, 4);
    map.removeWhere((key, value) => key.isOdd);
    expect(runs, 5);
    expect(map, {2: 4, 4: 8});
  });

  test('set bulk methods batch reactions and retain membership events', () {
    final set = ObservableSet<int>();
    var runs = 0;
    var events = 0;
    final dispose = autorun((_) {
      set.length;
      runs++;
    });
    final stop = set.observe((_) {
      events++;
    });
    addTearDown(dispose.call);
    addTearDown(stop);
    set.addAll([1, 2, 2, 3, 4, 5]);
    expect(runs, 2);
    expect(events, 5);
    set.removeAll([1, 5]);
    expect(runs, 3);
    set.retainWhere((value) => value.isEven);
    expect(runs, 4);
    expect(set, {2, 4});
    set.retainAll([2]);
    expect(runs, 5);
  });

  test('listener errors do not hide map or set insertion', () {
    final map = ObservableMap<int, int>();
    final set = ObservableSet<int>();
    var total = 0;
    final dispose = autorun((_) {
      total = map.length + set.length;
    });
    addTearDown(dispose.call);
    map.observe((_) => throw StateError('map listener'));
    set.observe((_) => throw StateError('set listener'));
    expect(() => map[1] = 1, throwsStateError);
    expect(total, 1);
    expect(() => set.add(1), throwsStateError);
    expect(total, 2);
  });

  test('Object arguments to lookup and removal remain type-safe', () {
    final Object unrelated = 'not an int';
    expect(ObservableList.of([1]).remove(unrelated), isFalse);
    expect(ObservableMap<int, int>.of({1: 2})[unrelated], isNull);
  });
}
