library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class Item<A extends num> = _Item<A> with _$Item<A>;

abstract class _Item<T extends num> with Store {
  @observable
  T value;

  @observable
  List<T> values;
}
