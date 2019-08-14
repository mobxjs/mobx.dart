library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class User = UserBase with _$User;

abstract class UserBase with Store {
  UserBase(this.id);

  @observable
  final int id;

  @observable
  final String firstName = 'Jane';

  @observable
  String lastName = 'Doe';

  @computed
  String get fullName => '$firstName $lastName';

  @observable
  static int foobar = 123;

  @action
  void updateNames({String firstName, String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @action
  static UserBase getUser(int id) async {}

  @observable
  String nonAsyncObservableMethod() {
    return 'nonAsyncObservableMethod';
  }
}
