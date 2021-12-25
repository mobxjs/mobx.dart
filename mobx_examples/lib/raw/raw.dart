import 'package:mobx/mobx.dart';

class Test {
  final x = Observable(0);

  late final Computed<int> computed;

  Test() {
    computed = Computed(() => x.value + 1);
  }

  void parametrizedAction(int increment) {
    runInAction(() {
      x.value = x.value + increment;
    });
  }
}
