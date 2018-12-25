import 'package:mobx/src/core/base_types.dart';

class ObservableValue<T> extends Atom {
  T _value;

  ObservableValue(T value, {String name}) : super(name) {
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
