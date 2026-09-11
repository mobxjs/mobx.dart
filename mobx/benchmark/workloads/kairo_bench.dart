import 'kairo/utils.dart';
import 'utils/bench_repeat.dart';
import 'results.dart';
import 'reactive_framework.dart';
import 'kairo/avoidable.dart';
import 'kairo/broad.dart';
import 'kairo/deep.dart';
import 'kairo/diamond.dart';
import 'kairo/mux.dart';
import 'kairo/repeated.dart';
import 'kairo/triangle.dart';
import 'kairo/unstable.dart';

final cases = [
  (avoidablePropagation, 'avoidablePropagation'),
  (broadPropagation, 'broadPropagation'),
  (deepPropagation, 'deepPropagation'),
  (diamond, 'diamond'),
  (mux, 'mux'),
  (repeatedObservers, 'repeatedObservers'),
  (triangle, 'triangle'),
  (unstable, 'unstable'),
];

Future<List<WorkloadResult>> kairoBench(ReactiveFramework framework) async {
  final results = <WorkloadResult>[];
  for (final (testCase, name) in cases) {
    final iter = framework.withBuild(() {
      final iter = testCase(framework);
      return iter;
    });

    // warm up
    KairoState state = iter();

    final timingResult = await fastestTest(10, () {
      for (int i = 0; i < 1000; i++) {
        final itemState = iter();
        if (state == KairoState.success) {
          state = itemState;
        }
      }
      return null;
    });

    results.add(
      WorkloadResult(
        name: '$name (${state.name})',
        success: state == KairoState.success,
        elapsedMicroseconds: timingResult.timing.time,
      ),
    );
  }
  return results;
}
