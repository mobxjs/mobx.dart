typedef SpyListener = void Function(SpyEvent event);

abstract class SpyEvent {
  SpyEvent(this.object, {this.name, this.isStart, this.isEnd});

  final dynamic object;
  final String name;

  final bool isStart;
  final bool isEnd;
}

/// Used for reporting value changes on an Observable
class ValueChangedSpyEvent extends SpyEvent {
  ValueChangedSpyEvent(dynamic object,
      {this.newValue, this.oldValue, String name, bool isStart, bool isEnd})
      : super(object, name: name, isStart: isStart, isEnd: isEnd);

  final dynamic newValue;
  final dynamic oldValue;
}

class EndedSpyEvent extends SpyEvent {
  EndedSpyEvent() : super(null, isEnd: true);
}

/// Utility function that only invokes the given [fn] once.
Function once(Function fn) {
  var invoked = false;

  return () {
    if (invoked) {
      return;
    }

    invoked = true;
    fn();
  };
}
