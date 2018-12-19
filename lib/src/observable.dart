class Atom {
  String name;

  Atom(String this.name);

  reportObserved() {
    print("Used ${this.name}");
  }

  reportChanged() {
    print("Changed ${this.name}");
  }

  Set _observers;
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

  @override
  reportObserved() {
    print("Used ${this.name} = ${this._value}");
  }

  @override
  reportChanged() {
    print("Changed ${this.name} = ${this._value}");
  }
}

class ComputedValue<T> extends Atom {
  List _observing;

  T Function() _fn;

  ComputedValue(
    String name,
    this._fn,
  ) : super(name);

  T get value {
    return this._fn();
  }
}

class ObservableList {}

class ObservableMap {}
