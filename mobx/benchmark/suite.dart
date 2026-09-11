import 'workloads/results.dart';

import 'adapter.dart';
import 'collections.dart';
import 'workloads/kairo/utils.dart';
import 'workloads/kairo_bench.dart' as kairo;
import 'workloads/run_framework_bench.dart';
import 'workloads/s_bench.dart';

Future<List<Map<String, Object?>>> runSuite({
  required String suite,
  int samples = 3,
  int iterations = 1000,
  String? caseName,
  void Function(String)? onProgress,
}) async {
  final rows = <Map<String, Object?>>[];
  if (suite == 'propagation') {
    for (final (make, name) in kairo.cases) {
      final framework = MobxFramework();
      try {
        final iterate = framework.withBuild(() => make(framework));
        var success = iterate() == KairoState.success;
        final timings = <int>[];
        for (var sample = 0; sample < samples; sample++) {
          final watch = Stopwatch()..start();
          for (var i = 0; i < iterations; i++) {
            if (iterate() != KairoState.success) success = false;
          }
          watch.stop();
          timings.add(watch.elapsedMicroseconds);
        }
        rows.add(result(name, timings, success));
        onProgress?.call(
          '$name: ${rows.last['median_us']} us; success=$success',
        );
      } finally {
        framework.dispose();
      }
    }
  } else if (suite == 'upstream' || suite == 'primitives' || suite == 'all') {
    final timings = <String, List<int>>{};
    final successful = <String, bool>{};
    for (var sample = 0; sample < samples; sample++) {
      final framework = MobxFramework();
      try {
        final measured =
            suite == 'primitives'
                ? (caseName == null
                    ? sbench(framework)
                    : [primitiveCase(framework, caseName)])
                : await runFrameworkBench(framework);
        for (final measurement in measured) {
          final name = measurement.name;
          final time = measurement.elapsedMicroseconds;
          timings.putIfAbsent(name, () => []).add(time);
          successful[name] = (successful[name] ?? true) && measurement.success;
          onProgress?.call('$name: $time us');
        }
      } finally {
        framework.dispose();
      }
    }
    final expectedCases =
        caseName != null ? 1 : (suite == 'primitives' ? 17 : 35);
    if (timings.length != expectedCases ||
        timings.values.any((values) => values.length != samples)) {
      throw StateError(
        'Expected $expectedCases complete upstream cases; got ${timings.length}',
      );
    }
    for (final entry in timings.entries) {
      rows.add(result(entry.key, entry.value, successful[entry.key]!));
    }
  }
  if (suite == 'collections' || suite == 'all') {
    rows.addAll(collectionBench(samples));
  }
  return rows;
}

Map<String, Object?> result(String name, List<int> samples, bool success) {
  final sorted = [...samples]..sort();
  return {
    'name': name,
    'samples_us': samples,
    'median_us': sorted[sorted.length ~/ 2],
    'success': success,
  };
}

WorkloadResult primitiveCase(MobxFramework framework, String name) {
  final int time;
  if (createTests[name] case final entry?) {
    time = runCreateTest(entry.$1, entry.$2, entry.$3, framework);
  } else if (computeTests[name] case final entry?) {
    time = runComputeTest(entry.$1, entry.$2, entry.$3, framework);
  } else if (updateTests[name] case final entry?) {
    time = runUpdateTest(entry.$1, entry.$2, entry.$3, framework);
  } else {
    throw ArgumentError('Unknown primitive case: $name');
  }
  return WorkloadResult(name: name, elapsedMicroseconds: time);
}
