import 'reactive_framework.dart';
import 'results.dart';

(int, List<int>, List<int>) _cellx(ReactiveFramework framework, int layers) {
  return framework.withBuild(() {
    final start = (
      prop1: framework.signal(1),
      prop2: framework.signal(2),
      prop3: framework.signal(3),
      prop4: framework.signal(4),
    );

    ({
      ISignal<int> prop1,
      ISignal<int> prop2,
      ISignal<int> prop3,
      ISignal<int> prop4,
    })
    layer = start;
    for (int i = layers; i > 0; i--) {
      final m = layer;
      final s = (
        prop1: framework.computed(() => m.prop2.read()),
        prop2: framework.computed(() => m.prop1.read() - m.prop3.read()),
        prop3: framework.computed(() => m.prop2.read() + m.prop4.read()),
        prop4: framework.computed(() => m.prop3.read()),
      );

      framework.effect(() => s.prop1.read());
      framework.effect(() => s.prop2.read());
      framework.effect(() => s.prop3.read());
      framework.effect(() => s.prop4.read());

      s.prop1.read();
      s.prop2.read();
      s.prop3.read();
      s.prop4.read();

      layer = s;
    }

    final end = layer;
    final stopwatch = Stopwatch()..start();
    final before = [
      end.prop1.read(),
      end.prop2.read(),
      end.prop3.read(),
      end.prop4.read(),
    ];

    framework.withBatch(() {
      start.prop1.write(4);
      start.prop2.write(3);
      start.prop3.write(2);
      start.prop4.write(1);
    });

    final after = [
      end.prop1.read(),
      end.prop2.read(),
      end.prop3.read(),
      end.prop4.read(),
    ];

    stopwatch.stop();

    return (stopwatch.elapsedMicroseconds, before, after);
  });
}

typedef _BenchmarkResults = (List<int>, List<int>);

List<WorkloadResult> cellxBench(ReactiveFramework framework) {
  final measurements = <WorkloadResult>[];
  const expected = <int, _BenchmarkResults>{
    1000: ([-3, -6, -2, 2], [-2, -4, 2, 3]),
    2500: ([-3, -6, -2, 2], [-2, -4, 2, 3]),
    5000: ([2, 4, -1, -6], [-2, 1, -4, -4]),
  };

  final results = <int, _BenchmarkResults>{};
  for (final layers in expected.keys) {
    int total = 0;
    for (int i = 0; i < 10; i++) {
      final (elapsed, before, after) = _cellx(framework, layers);
      results[layers] = (before, after);
      total += elapsed;
    }

    final (before, after) = results[layers]!;
    final (expectedBefore, expectedAfter) = expected[layers]!;
    final first =
        _listEqual(before, expectedBefore) ? 'first: pass' : 'first: fail';
    final last = _listEqual(after, expectedAfter) ? 'last: pass' : 'last: fail';

    measurements.add(
      WorkloadResult(
        name: 'cellx$layers ($first, $last)',
        success:
            _listEqual(before, expectedBefore) &&
            _listEqual(after, expectedAfter),
        elapsedMicroseconds: total,
      ),
    );
  }
  return measurements;
}

bool _listEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (final (i, v) in a.indexed) {
    if (v != b[i]) return false;
  }
  return true;
}
