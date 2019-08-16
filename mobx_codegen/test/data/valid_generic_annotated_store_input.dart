library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

@store
class _Item<T> {
  @observable
  T value;
}
