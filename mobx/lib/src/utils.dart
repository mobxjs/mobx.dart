import 'dart:async';

const Duration ms = Duration(milliseconds: 1);

Timer Function(void Function()) createDelayedScheduler(int delayMs) =>
    (fn) => Timer(ms * delayMs, fn);

mixin DebugCreationStack {
  /// Set the flag to true, to enable [debugCreationStack].
  /// Otherwise, the stack is always null.
  static var enable = false;

  /// The stack trace when the object is created
  final StackTrace? debugCreationStack = () {
    StackTrace? result;
    assert(() {
      if (enable) result = StackTrace.current;
      return true;
    }());
    return result;
  }();
}
