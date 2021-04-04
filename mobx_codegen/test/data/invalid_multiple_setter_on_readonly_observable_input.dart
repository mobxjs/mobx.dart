import 'package:mobx/mobx.dart';

class CounterStore = _CounterStoreBase with _$CounterStore;

abstract class _CounterStoreBase with Store {
  @readonly
  int _counter;

  @readonly
  int _counter2;

  set counter(int counter) {
    _counter = counter;
  }

  set counter2(int counter2) {
    _counter2 = counter2;
  }

  @action
  void increment() {
    _counter++;
  }
}
