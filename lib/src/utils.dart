import 'dart:async';

const ms = const Duration(milliseconds: 1);

Timer Function(Function) createDelayedScheduler(int delayMs) {
  return (Function fn) {
    return Timer(ms * delayMs, fn);
  };
}
