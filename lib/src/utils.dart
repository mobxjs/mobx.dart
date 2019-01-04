import 'dart:async';

const Duration ms = Duration(milliseconds: 1);

Timer Function(void Function()) createDelayedScheduler(int delayMs) =>
    (fn) => Timer(ms * delayMs, fn);
