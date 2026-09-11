import 'dart:convert';
import 'package:mobx/mobx.dart';

int sink = 0;
int median(List<int> values) => (values..sort())[values.length ~/ 2];

void measure(
  String name,
  int size,
  List<int> Function() create,
  void Function(List<int>) mutate,
) {
  final times = <int>[];
  for (var i = 0; i < 9; i++) {
    final list = create();
    final watch = Stopwatch()..start();
    mutate(list);
    watch.stop();
    sink += list.length;
    if (i >= 2) times.add(watch.elapsedMicroseconds);
  }
  print(jsonEncode({'case': name, 'size': size, 'median_us': median(times)}));
}

void main() {
  for (final n in [10000, 50000, 100000]) {
    measure(
      'native_remove_alternating',
      n,
      () => List.generate(n, (i) => i),
      (list) => list.removeWhere((i) => i.isEven),
    );
    measure(
      'observable_remove_alternating',
      n,
      () => ObservableList.of(List.generate(n, (i) => i)),
      (list) => list.removeWhere((i) => i.isEven),
    );
  }
  for (final batch in [false, true]) {
    final map = ObservableMap<int, int>();
    final set = ObservableSet<int>();
    var mapRuns = 0;
    var setRuns = 0;
    final dm = autorun((_) {
      mapRuns++;
      sink += map.length;
    });
    final ds = autorun((_) {
      setRuns++;
      sink += set.length;
    });
    final values = List.generate(10000, (i) => i);
    final entries = Map.fromIterables(values, values);
    final watch = Stopwatch()..start();
    void work() {
      map.addAll(entries);
      set.addAll(values);
    }

    if (batch) {
      runInAction(work);
    } else {
      work();
    }
    watch.stop();
    print(
      jsonEncode({
        'case': 'bulk_map_set',
        'batched': batch,
        'map_reactions': mapRuns - 1,
        'set_reactions': setRuns - 1,
        'us': watch.elapsedMicroseconds,
      }),
    );
    dm();
    ds();
  }
  final map = ObservableMap<int, int>.of({for (var i = 0; i < 1000; i++) i: i});
  var runs = 0;
  final disposers = [
    for (var i = 0; i < 1000; i++)
      autorun((_) {
        sink += map[i]!;
        runs++;
      }),
  ];
  runs = 0;
  map[0] = -1;
  print(
    jsonEncode({
      'case': 'single_key_write',
      'observers': 1000,
      'reactions': runs,
    }),
  );
  for (final dispose in disposers) {
    dispose();
  }
  print('sink=$sink');
}
