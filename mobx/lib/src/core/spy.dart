part of '../core.dart';

typedef SpyListener = void Function(SpyEvent event);

abstract class SpyEvent {
  SpyEvent._(
    this.object, {
    required this.type,
    required this.name,
    this.duration,
    this.isStart = false,
    this.isEnd = false,
  });

  final dynamic object;
  final String name;
  final String type;

  final Duration? duration;
  final bool isStart;
  final bool isEnd;

  String get sentinel {
    final hasStart = isStart == true && isEnd == false;
    final hasEnd = isEnd == true && isStart == false;

    if (hasStart) {
      return '(START)';
    }

    if (hasEnd) {
      return '(END${duration == null ? '' : ' after ${duration!.inMilliseconds}ms'})';
    }

    return '';
  }

  @override
  String toString() => '$type$sentinel $name';
}

/// Used for reporting value changes on an Observable
class ObservableValueSpyEvent extends SpyEvent {
  ObservableValueSpyEvent(
    super.object, {
    this.newValue,
    this.oldValue,
    required super.name,
    super.isEnd,
  }) : super._(type: 'observable', isStart: true);

  final dynamic newValue;
  final dynamic oldValue;

  @override
  String toString() => '${super.toString()}=$newValue, previously=$oldValue';
}

class ComputedValueSpyEvent extends SpyEvent {
  ComputedValueSpyEvent(super.object, {required super.name})
    : super._(type: 'computed', isStart: true, isEnd: true);
}

class ReactionSpyEvent extends SpyEvent {
  ReactionSpyEvent({required String name})
    : super._(null, type: 'reaction', name: name, isStart: true);
}

class ReactionErrorSpyEvent extends SpyEvent {
  ReactionErrorSpyEvent(this.error, {required String name})
    : super._(
        null,
        type: 'reaction-error',
        name: name,
        isStart: true,
        isEnd: true,
      );

  final Object error;

  @override
  String toString() => '${super.toString()} $error';
}

class ReactionDisposedSpyEvent extends SpyEvent {
  ReactionDisposedSpyEvent({required String name})
    : super._(
        null,
        type: 'reaction-dispose',
        name: name,
        isStart: true,
        isEnd: true,
      );
}

class ActionSpyEvent extends SpyEvent {
  ActionSpyEvent({required String name})
    : super._(null, type: 'action', name: name, isStart: true);
}

class EndedSpyEvent extends SpyEvent {
  EndedSpyEvent({
    required String type,
    required String name,
    Duration? duration,
  }) : super._(null, type: type, name: name, duration: duration, isEnd: true);
}

/// Utility function that only invokes the given [fn] once.
void Function() _once(Function fn) {
  var invoked = false;

  return () {
    if (invoked) {
      return;
    }

    invoked = true;
    fn();
  };
}
