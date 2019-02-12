import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = _Counter with _$Counter;

abstract class _Counter implements Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
