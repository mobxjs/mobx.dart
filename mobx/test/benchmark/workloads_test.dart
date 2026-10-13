import 'package:test/test.dart';

import '../../benchmark/adapter.dart';
import '../../benchmark/workloads/config.dart';
import '../../benchmark/workloads/kairo_bench.dart' as graphs;
import '../../benchmark/workloads/kairo/utils.dart';
import '../../benchmark/workloads/results.dart';
import '../../benchmark/workloads/utils/perf_tests.dart';

void main() {
  group('graph workloads', () {
    for (final (build, name) in graphs.cases) {
      test(name, () {
        final framework = MobxFramework();
        addTearDown(framework.dispose);
        final iterate = framework.withBuild(() => build(framework));
        for (var i = 0; i < 5; i++) {
          expect(iterate(), KairoState.success);
        }
      });
    }
  });

  test(
    'dynamic workload failure is a typed result, independent of its label',
    () {
      final config = perfTests.first;
      final result = dynamicResult(
        config,
        TimingResult(
          TestResult(
            sum: config.expected.sum + 1,
            count: config.expected.count,
          ),
          const TestTiming(1),
        ),
      );
      expect(result.success, isFalse);
      expect(result.elapsedMicroseconds, 1);
    },
  );
}
