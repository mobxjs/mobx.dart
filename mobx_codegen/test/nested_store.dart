import 'package:mobx/mobx.dart';

part 'nested_store.g.dart';

// ignore: library_private_types_in_public_api
class NestedStore = _NestedStore with _$NestedStore;

abstract class _NestedStore with Store {
  @observable
  late String name;
}
