import 'package:mobx/src/core/global_state.dart';
import 'package:mobx/src/core/reaction.dart';

class Atom {
  String name;

  bool isPendingUnobservation = false;

  Atom(String this.name);

  Set<Derivation> observers = Set();

  reportObserved() {
    global.reportObserved(this);
  }

  reportChanged() {
    global.startBatch();
    global.propagateChanged(this);
    global.endBatch();
  }

  addObserver(Derivation d) {
    observers.add(d);
  }

  removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
    if (observers.isEmpty) {
      global.enqueueForUnobservation(this);
    }
  }
}

class ObservableValue<T> extends Atom {
  T _value;

  ObservableValue(value, {String name}) : super(name) {
    this._value = value;
  }

  T get value {
    reportObserved();
    return _value;
  }

  set value(T value) {
    _value = value;
    reportChanged();
  }
}
