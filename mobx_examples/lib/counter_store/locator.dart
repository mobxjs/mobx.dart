import 'package:get_it/get_it.dart';
import 'package:mobx_examples/counter_store/counter_store.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerFactory(() => CounterStore());
}
