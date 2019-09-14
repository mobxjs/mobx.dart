library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class Item<A> = _Item<A> with _$Item<A>;

abstract class _Item<T> with Store {
  @observable
  T value;
}
