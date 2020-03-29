part of '../core.dart';

typedef SpyListener = void Function(SpyEvent event);

abstract class SpyEvent {
  SpyEvent(this.object, {this.name, this.isStart, this.isEnd});

  final dynamic object;
  final String name;

  final bool isStart;
  final bool isEnd;
}

/// Used for reporting value changes on an Observable
class ObservableValueSpyEvent extends SpyEvent {
  ObservableValueSpyEvent(dynamic object,
      {this.newValue, this.oldValue, String name, bool isStart, bool isEnd})
      : super(object, name: name, isStart: isStart, isEnd: isEnd);

  final dynamic newValue;
  final dynamic oldValue;
}

class ComputedValueSpyEvent extends SpyEvent {
  ComputedValueSpyEvent(object, {String name})
      : super(object, name: name, isStart: true, isEnd: true);
}

class EndedSpyEvent extends SpyEvent {
  EndedSpyEvent() : super(null, isEnd: true);
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
  }());

  return debug;
}
