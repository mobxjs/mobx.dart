import 'package:mobx/src/core/observable.dart';

ObservableValue<T> observable<T>(T initialValue, {String name}) {
  return ObservableValue(initialValue, name: name);
}
