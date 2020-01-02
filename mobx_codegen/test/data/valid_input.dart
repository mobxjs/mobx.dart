library generator_sample;

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

typedef VoidCallback = void Function();

class User = UserBase with _$User;

abstract class UserBase with Store {
  UserBase(this.id);

  final int id;

  @observable
  String firstName = 'Jane';

  // Ensures that we pick up on type being inferred to string
  @observable
  var middleName = 'Mary'; // ignore: type_annotate_public_apis

  @observable
  String lastName = 'Doe';

  @observable
  User friend;

  @observable
  void Function() callback;

  @observable
  VoidCallback callback2;

  @observable
  List<User> _testUsers = <User>[];

  @computed
  String get fullName => '$firstName $middleName $lastName';

  @action
  Future<List<User>> fetchUsers() async => Future.value([]);

  @action
  void updateNames({@required String firstName, String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @observable
  Future<String> foobar() async {
    return 'foobar';
  }

  @observable
  Stream<T> loadStuff<T>(String arg1, {T value}) async* {
    yield value;
  }

  @observable
  Stream<String> asyncGenerator() async* {
    yield 'item1';
  }

  @action
  Future<void> setAsyncFirstName() async {
    firstName = 'Async FirstName';
  }

  @action
  @observable
  Future<void> setAsyncFirstName2() async {
    firstName = 'Async FirstName 2';
  }

  @action
  void setBlob(blob) {} // ignore: type_annotate_public_apis
}
