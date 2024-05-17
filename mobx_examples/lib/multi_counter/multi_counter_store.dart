import 'package:mobx/mobx.dart';

part 'multi_counter_store.g.dart';

class SingleCounter = InternalSingleCounter with _$SingleCounter;

abstract class InternalSingleCounter with Store {
  @observable
  int value = 0;

  @action
  void reset() {
    value = 0;
  }

  @action
  void increment() {
    value++;
  }

  @action
  void decrement() {
    value--;
  }
}

class MultiCounterStore = InternalMultiCounterStore with _$MultiCounterStore;

abstract class InternalMultiCounterStore with Store {
  final ObservableList<SingleCounter> counters =
      ObservableList<SingleCounter>.of([]);

  @action
  void addCounter() {
    counters.add(SingleCounter());
  }

  @action
  void removeCounter(int index) {
    counters.removeAt(index);
  }
}
