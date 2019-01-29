import 'package:mobx/mobx.dart';

part 'generator_example.g.dart';

class User = UserBase with _$User;

abstract class UserBase implements Store {
  UserBase(this.id);

  final int id;

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

class Admin extends AdminBase with _$Admin {
  Admin(int id) : super(id);
}

abstract class AdminBase extends User implements Store {
  AdminBase(int id) : super(id);

  @observable
  String userName = 'admin';

  @observable
  ObservableList<String> accessRights = ObservableList();
}
