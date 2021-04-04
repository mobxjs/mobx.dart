import 'package:mobx/mobx.dart';

class CounterStore = _CounterStoreBase with _$CounterStore;

abstract class _CounterStoreBase with Store {
  @readonly
  int _counter;

  set counter(int counter) {
    _counter = counter;
  }

  @action
  void increment() {
    _counter++;
  }
}
