import 'package:mobx/mobx.dart';

part 'form_store.g.dart';

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore implements Store {
  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @action
  void setName(String name) {
    this.name = name;
  }

  @action
  void setEmail(String email) {
    this.email = email;
  }

  @action
  void setPassword(String password) {
    this.password = password;
  }
}
