import 'package:mobx/mobx.dart';

List<Map<String, Object?>> collectionBench(int samples) {
  final rows = <Map<String, Object?>>[];
  for (final size in [10000, 50000, 100000]) {
    for (final observable in [false, true]) {
      final timings = <int>[];
      for (var sample = -1; sample < samples; sample++) {
        final values = List.generate(size, (i) => i);
        final list = observable ? ObservableList.of(values) : values;
        final watch = Stopwatch()..start();
        list.removeWhere((value) => value.isEven);
        watch.stop();
        if (list.length != size ~/ 2 ||
            list.indexed.any((entry) => entry.$2 != entry.$1 * 2 + 1)) {
          throw StateError('Incorrect list filtering');
        }
        if (sample >= 0) timings.add(watch.elapsedMicroseconds);
      }
      rows.add(
        _result(
          '${observable ? 'observable' : 'native'}_remove_alternating_$size',
          timings,
        ),
      );
    }
  }
  for (final batch in [false, true]) {
    final timings = <int>[];
    var mapRuns = 0;
    var setRuns = 0;
    for (var sample = -1; sample < samples; sample++) {
      final map = ObservableMap<int, int>();
      final set = ObservableSet<int>();
      mapRuns = 0;
      setRuns = 0;
      final dm = autorun((_) {
        map.length;
        mapRuns++;
      });
      final ds = autorun((_) {
        set.length;
        setRuns++;
      });
      final values = List.generate(10000, (i) => i);
      final entries = Map.fromIterables(values, values);
      try {
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
        if (map.length != values.length || set.length != values.length) {
          throw StateError('Incorrect bulk insertion');
        }
        if (sample >= 0) timings.add(watch.elapsedMicroseconds);
      } finally {
        dm();
        ds();
      }
    }
    rows.add(
      _result('bulk_map_set_${batch ? 'outer_action' : 'direct'}', timings)
        ..['map_reactions'] = mapRuns - 1
        ..['set_reactions'] = setRuns - 1,
    );
  }
  return rows;
}

Map<String, Object?> _result(String name, List<int> samples) {
  final sorted = [...samples]..sort();
  return {
    'name': name,
    'samples_us': samples,
    'median_us': sorted[sorted.length ~/ 2],
    'success': true,
  };
}
