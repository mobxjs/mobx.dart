library generator_sample;

import 'dart:core' as c;

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class User = UserBase with _$User;

abstract class UserBase with Store {
  UserBase(this.id);

  final c.int id;

  @observable
  c.String firstName = 'Jane';

  @observable
  c.String lastName = 'Doe';

  @computed
  c.String get fullName => '$firstName $lastName';

  @action
  void updateNames({@required c.String firstName, c.String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @observable
  c.Future<c.String> foobar() async {
    return 'foobar';
  }

  @observable
  c.Stream<T> loadStuff<T>(c.String arg1, {T value}) async* {
    yield value;
  }

  @observable
  c.Stream<c.String> asyncGenerator() async* {
    yield 'item1';
  }

  @action
  c.Future<void> setAsyncFirstName() async {
    firstName = 'Async FirstName';
  }

  @action
  @observable
  c.Future<void> setAsyncFirstName2() async {
    firstName = 'Async FirstName 2';
  }

  @action
  void setBlob(blob) {} // ignore: type_annotate_public_apis
}
