library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class User = _User with _$User;

@store
abstract class _User with Store {
  _User();

  @observable
  int value;
}
