library generator_sample;

import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

@store
class _User {
  _User(this.id);
  _User.withNames({this.firstName = 'Scott', this.lastName}) : id = 0;

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
}
