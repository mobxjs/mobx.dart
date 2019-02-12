import 'package:mobx/mobx.dart';

part 'generator_example.g.dart';

class User = _User with _$User;

abstract class _User implements Store {
  _User(this.id);

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

  @observable
  Future<String> loadPrivileges([String foo]) async {
    return foo;
  }

  @observable
  Stream<T> loadStuff<T>(String arg1, {T value}) async* {
    yield value;
  }

  @action
  @observable
  Future<void> loadAccessRights() async {
    final items = Stream.fromIterable(['web', 'filesystem'])
        .asyncMap((ev) => Future.delayed(Duration(milliseconds: 10), () => ev));
    await for (final item in items) {
      accessRights.add(item);
    }
  }
}
