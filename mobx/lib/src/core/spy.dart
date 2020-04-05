part of '../core.dart';

typedef SpyListener = void Function(SpyEvent event);

abstract class SpyEvent {
  SpyEvent._(this.object,
      {this.type, this.name, this.duration, this.isStart, this.isEnd});

  final dynamic object;
  final String name;
  final String type;

  final Duration duration;
  final bool isStart;
  final bool isEnd;

  String get sentinel {
    final hasStart =
        isStart != null && isStart == true && (isEnd == null || isEnd == false);
    final hasEnd =
        isEnd != null && isEnd == true && (isStart == null || isStart == false);

    if (hasStart) {
      return '(START)';
    }

    if (hasEnd) {
      return '(END${duration == null ? '' : ' after ${duration.inMilliseconds}ms'})';
    }

    return '';
  }

  @override
  String toString() => '$type$sentinel $name';
}

/// Used for reporting value changes on an Observable
class ObservableValueSpyEvent extends SpyEvent {
  ObservableValueSpyEvent(dynamic object,
      {this.newValue, this.oldValue, String name, bool isEnd})
      : super._(object,
            type: 'observable', name: name, isStart: true, isEnd: isEnd);

  final dynamic newValue;
  final dynamic oldValue;

  @override
  String toString() => '${super.toString()}=$newValue, previously=$oldValue';
}

class ComputedValueSpyEvent extends SpyEvent {
  ComputedValueSpyEvent(object, {String name})
      : super._(object,
            type: 'computed', name: name, isStart: true, isEnd: true);
}

class ReactionSpyEvent extends SpyEvent {
  ReactionSpyEvent({String name})
      : super._(null, type: 'reaction', name: name, isStart: true);
}

class ReactionErrorSpyEvent extends SpyEvent {
  ReactionErrorSpyEvent(
    this.error, {
    String name,
  }) : super._(null,
            type: 'reaction-error', name: name, isStart: true, isEnd: true);

  final Object error;

  @override
  String toString() => '${super.toString()} $error';
}

class ReactionDisposedSpyEvent extends SpyEvent {
  ReactionDisposedSpyEvent({
    String name,
  }) : super._(null,
            type: 'reaction-dispose', name: name, isStart: true, isEnd: true);
}

class ActionSpyEvent extends SpyEvent {
  ActionSpyEvent({
    String name,
  }) : super._(null, type: 'action', name: name, isStart: true);
}

class EndedSpyEvent extends SpyEvent {
  EndedSpyEvent({String type, String name, Duration duration})
      : super._(null, type: type, name: name, duration: duration, isEnd: true);
}

/// Utility function that only invokes the given [fn] once.
Function _once(Function fn) {
  var invoked = false;

  return () {
    if (invoked) {
      return;
    }

    invoked = true;
    fn();
  };
}

bool get _isDebugMode {
  var debug = false;

  // asserts are removed in release mode!!!
  assert(() {
    debug = true;
    return true;
  }());

  return debug;
}
