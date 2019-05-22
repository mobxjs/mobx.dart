import 'package:mobx/mobx.dart';

part 'nested_store.g.dart';

class NestedStore = _NestedStore with _$NestedStore;

abstract class _NestedStore with Store {
  @observable
  String name;
}
