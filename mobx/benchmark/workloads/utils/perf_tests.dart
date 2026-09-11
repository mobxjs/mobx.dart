class TestResult {
  const TestResult({required this.sum, required this.count});

  final num sum;
  final int count;
}

class TestTiming {
  const TestTiming(this.time);
  final int time;
}

class TimingResult<T> {
  const TimingResult(this.result, this.timing);

  final T result;
  final TestTiming timing;
}
