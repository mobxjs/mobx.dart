import 'dart:async';

import 'package:collection/collection.dart' show DeepCollectionEquality;

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

/// Determines whether [a] and [b] are equal.
bool equatable<T>(T a, T b, {bool useDeepEquality = false}) {
  if (identical(a, b)) return true;
  if (useDeepEquality && (a is Iterable || a is Map)) {
    if (!_equality.equals(a, b)) return false;
  } else if (a.runtimeType != b.runtimeType) {
    return false;
  } else if (a != b) {
    return false;
  }

  return true;
}

const DeepCollectionEquality _equality = DeepCollectionEquality();
