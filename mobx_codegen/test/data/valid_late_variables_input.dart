library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class TestStore = _TestStore with _$TestStore;

@StoreConfig(hasToString: false)
abstract class _TestStore with Store {
  @observable
  late String username;
}
