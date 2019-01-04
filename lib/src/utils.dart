import 'dart:async';

const ms = Duration(milliseconds: 1);

Timer Function(Function) createDelayedScheduler(int delayMs) {
  return (Function fn) {
    return Timer(ms * delayMs, fn);
  };
}
