import 'package:mobx/mobx.dart';

part 'generator_example.g.dart';

@observable
abstract class User {
  User._();
  factory User() = _$User;

  @observable
  String firstName = 'Jane';

  @observable
  String lastName = 'Doe';

  @computed
  String get fullName => '$firstName $lastName';

  @action
  void updateNames({String firstName, String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
  }
}
