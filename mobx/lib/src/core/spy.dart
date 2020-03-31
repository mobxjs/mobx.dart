part of '../core.dart';

typedef SpyListener = void Function(SpyEvent event);

abstract class SpyEvent {
  SpyEvent(this.object, {this.name, this.duration, this.isStart, this.isEnd});

  final dynamic object;
  final String name;

  final Duration duration;
  final bool isStart;
  final bool isEnd;

  @override
  String toString() => '$name';
}

/// Used for reporting value changes on an Observable
class ObservableValueSpyEvent extends SpyEvent {
  ObservableValueSpyEvent(dynamic object,
      {this.newValue, this.oldValue, String name, bool isStart, bool isEnd})
      : super(object, name: name, isStart: isStart, isEnd: isEnd);

  final dynamic newValue;
  final dynamic oldValue;

  @override
  String toString() {
    final hasStart =
        isStart != null && isStart == true && (isEnd == null || isEnd == false);
    return 'observable $name=$newValue${hasStart ? ' START' : ''}';
  }
}

class ComputedValueSpyEvent extends SpyEvent {
  ComputedValueSpyEvent(object, {String name})
      : super(object, name: name, isStart: true, isEnd: true);

  @override
  String toString() => 'computed $name';
}

class ReactionSpyEvent extends SpyEvent {
  ReactionSpyEvent({String name}) : super(null, name: name, isStart: true);

  @override
  String toString() => 'reaction $name START';
}

class ReactionErrorSpyEvent extends SpyEvent {
  ReactionErrorSpyEvent(
    this.error, {
    String name,
  }) : super(null, name: name, isStart: true, isEnd: true);

  final Object error;
}

class ActionSpyEvent extends SpyEvent {
  ActionSpyEvent({
    String name,
  }) : super(null, name: name, isStart: true);

  @override
  String toString() => 'action $name START';
}

class EndedSpyEvent extends SpyEvent {
  EndedSpyEvent({String name, Duration duration})
      : super(null, name: name, duration: duration, isEnd: true);

  @override
  String toString() =>
      '$name END${duration == null ? '' : ' after ${duration.inMilliseconds}ms'}';
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
