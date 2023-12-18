import 'dart:async';

import 'package:collection/collection.dart' show DeepCollectionEquality, IterableExtension;

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
bool equatable<T>(T a, T b) {
  if (identical(a, b)) return true;
  if (a is Iterable || a is Map) {
    if (!_equality.equals(a, b)) return false;
  } else if (a.runtimeType != b.runtimeType) {
    return false;
  } else if (a != b) {
    return false;
  }

  return true;
}

const DeepCollectionEquality _equality = DeepCollectionEquality();

/// Returns a `hashCode` for [props].
int mapPropsToHashCode(Iterable<Object?>? props) {
  return _finish(props == null ? 0 : props.fold(0, _combine));
}

/// Jenkins Hash Functions
/// https://en.wikipedia.org/wiki/Jenkins_hash_function
int _combine(int hash, Object? object) {
  if (object is Map) {
    object.keys
        .sorted((Object? a, Object? b) => a.hashCode - b.hashCode)
        .forEach((Object? key) {
      hash = hash ^ _combine(hash, [key, (object! as Map)[key]]);
    });
    return hash;
  }
  if (object is Set) {
    object = object.sorted((Object? a, Object? b) => a.hashCode - b.hashCode);
  }
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }
    return hash ^ object.length;
  }

  hash = 0x1fffffff & (hash + object.hashCode);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}