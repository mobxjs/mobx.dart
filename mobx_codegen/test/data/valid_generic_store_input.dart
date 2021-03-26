library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class Item<A extends num> = _Item<A> with _$Item<A>;

@StoreConfig(hasToString: false)
abstract class _Item<T extends num> with Store {
  @observable
  T value1;

  @observable
  T? value2;

  @observable
  List<T> values1;

  @observable
  List<T> values2;
}
