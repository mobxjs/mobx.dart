import 'package:mobx/mobx.dart';

class SingleCounter with Store {
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

class MultiCounterStore with Store {
  final ObservableList<SingleCounter> counters = ObservableList();

  @action
  void addCounter() {
    counters.add(SingleCounter());
  }

  @action
  void removeCounter(int index) {
    counters.removeAt(index);
  }
}
