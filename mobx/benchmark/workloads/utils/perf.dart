class TimedResult<T> {
  const TimedResult(this.result, this.time);

  final T result;
  final int time;
}

final _stopwatch = Stopwatch();

TimedResult<T> runTimed<T>(T Function() fn) {
  _stopwatch
    ..reset()
    ..start();
  final result = fn();
  _stopwatch.stop();

  return TimedResult(result, _stopwatch.elapsedMicroseconds);
}
