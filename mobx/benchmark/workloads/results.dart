import 'framework_type.dart';
import 'utils/perf_tests.dart';

/// A measurement produced by a workload, independent of CLI or browser output.
class WorkloadResult {
  const WorkloadResult({
    required this.name,
    required this.elapsedMicroseconds,
    this.success = true,
  });
  final String name;
  final int elapsedMicroseconds;
  final bool success;
}

WorkloadResult dynamicResult(
  TestConfig config,
  TimingResult<TestResult> measured,
) {
  final expected = config.expected;
  final result = measured.result;
  final sumMatches = expected.sum == 0 || expected.sum == result.sum;
  final countMatches = expected.count == 0 || expected.count == result.count;
  final sum = sumMatches ? 'sum: pass' : 'sum: fail';
  final count = countMatches ? 'count: pass' : 'count: fail';
  return WorkloadResult(
    name: '${makeTitle(config)} (${config.name ?? ''}, $sum, $count)',
    elapsedMicroseconds: measured.timing.time,
    success: sumMatches && countMatches,
  );
}

String makeTitle(TestConfig config) {
  final dyn = config.staticFraction < 1 ? ' - dynamic' : '';
  final read =
      config.readFraction < 1
          ? ' - read ${(config.readFraction * 100).toStringAsFixed(1)}%'
          : '';
  return '${config.width}x${config.totalLayers} - ${config.nSources} sources$dyn$read';
}
