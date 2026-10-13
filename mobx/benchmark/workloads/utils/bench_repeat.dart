import 'perf.dart';
import 'perf_tests.dart';

Future<TimingResult<T>> fastestTest<T>(int times, T Function() fn) async {
  final results = <TimingResult<T>>[];

  for (int i = 0; i < times; i++) {
    results.add(await _runTracked(fn));
  }

  return results.reduce((a, b) => a.timing.time < b.timing.time ? a : b);
}

Future<TimingResult<T>> _runTracked<T>(T Function() fn) async {
  final TimedResult<T>(:result, :time) = runTimed(fn);
  return TimingResult(result, TestTiming(time));
}
