import 'package:mobx/src/global_state.dart';

class Atom {
  String name;

  Atom(String this.name);

  reportObserved() {
    global.reportObserved(this);
  }

  reportChanged() {}

  Set<Derivation> observers = Set();

  addObserver(Derivation d) {
    observers.add(d);
  }

  removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
  }
}

abstract class Derivation {
  String name;
  Set<Atom> observing;
  Set<Atom> newObserving;

  void execute() {}
}

class ObservableValue<T> extends Atom {
  T _value;

  ObservableValue(String name) : super(name);

  ObservableValue.of(String name, this._value) : super(name);

  T get value {
    reportObserved();
    return _value;
  }

  set value(T value) {
    _value = value;
    reportChanged();
  }
}

class ComputedValue<T> extends Atom implements Derivation {
  @override
  Set<Atom> observing = Set();

  @override
  Set<Atom> newObserving;

  T _value;

  @override
  T Function() _fn;

  ComputedValue(
    String name,
    this._fn,
  ) : super(name);

  T get value {
    global.startBatch();
    computeValue(true);
    global.endBatch();

    reportObserved();
    return _value;
  }

  computeValue(bool track) {
    if (track) {
      global.trackDerivation(this);
    } else {
      execute();
    }
  }

  @override
  void execute() {
    _value = _fn();
  }
}
