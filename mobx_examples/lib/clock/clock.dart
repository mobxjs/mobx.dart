import 'dart:async';

import 'package:mobx/mobx.dart';

class Clock {
  Clock() {
    _atom = Atom(
        name: 'Clock Atom', onObserved: _startTimer, onUnobserved: _stopTimer);
  }

  DateTime get now {
    _atom.reportObserved();
    return DateTime.now();
  }

  Atom _atom;
  Timer _timer;

  void _startTimer() {
    print('Clock started ticking');

    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }

    print('Clock stopped ticking');
  }

  void _onTick(_) {
    _atom.reportChanged();
  }
}
