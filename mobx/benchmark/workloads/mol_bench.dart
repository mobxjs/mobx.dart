import 'utils/bench_repeat.dart';
import 'results.dart';
import 'reactive_framework.dart';

int fib(int n) {
  if (n < 2) return 1;
  return fib(n - 1) + fib(n - 2);
}

int hard(int n, String _) {
  return n + fib(16);
}

final numbers = List.generate(5, (i) => i);

Future<WorkloadResult> molBench(ReactiveFramework framework) async {
  final res = <int>[];
  final iter = framework.withBuild(() {
    final a = framework.signal(0);
    final b = framework.signal(0);
    final c = framework.computed(() => (a.read() % 2) + (b.read() % 2));
    final d = framework.computed(
      () =>
          numbers
              .map((i) => {'x': i + (a.read() % 2) - (b.read() % 2)})
              .toList(),
    );
    final e = framework.computed(
      () => hard(c.read() + a.read() + d.read()[0]['x']!, 'E'),
    );
    final f = framework.computed(() => hard(d.read()[2]['x'] ?? b.read(), 'F'));
    final g = framework.computed(
      () => c.read() + (c.read() + e.read() % 2) + d.read()[4]['x']! + f.read(),
    );

    framework.effect(() => res.add(hard(g.read(), 'H')));
    framework.effect(() => res.add(g.read()));
    framework.effect(() => res.add(hard(f.read(), 'J')));

    return (int i) {
      res.clear();
      framework.withBatch(() {
        b.write(1);
        a.write(1 + i * 2);
      });
      framework.withBatch(() {
        a.write(2 + i * 2);
        b.write(2);
      });
    };
  });

  iter(1);

  final timingResult = await fastestTest(10, () {
    for (int i = 0; i < 10000; i++) {
      iter(i);
    }
  });

  return WorkloadResult(
    name: 'molBench',
    elapsedMicroseconds: timingResult.timing.time,
  );
}
