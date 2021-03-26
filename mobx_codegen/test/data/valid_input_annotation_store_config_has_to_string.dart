library generator_sample;

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
//import 'package:flutter/material.dart';

part 'generator_sample.g.dart';

typedef VoidCallback = void Function();

class User = UserBase with _$User;

abstract class UserBase with Store {
  UserBase(this.id);

  final int id;

  final int? idNullable;

  @observable
  String firstName = 'Jane';

  @observable
  String? firstNameNullable = 'JaneNullable';

  // Ensures that we pick up on type being inferred to string
  @observable
  var middleName = 'Mary'; // ignore: type_annotate_public_apis

  @observable
  String lastName = 'Doe';

  @observable
  User friend;

  @observable
  User? friendNullable;

  @observable
  void Function() callback;

  @observable
  void Function()? callbackNullable;

  @observable
  VoidCallback callback2;

  @observable
  VoidCallback? callback2Nullable;

  @observable
  List<User> _testUsers = <User>[];

//  @observable
//  List<Color> backColor = List.generate(60, (i) => Colors.transparent);

  @computed
  String get fullName => '$firstName $middleName $lastName';

  @computed
  String? get fullNameNullable => null;

  @action
  Future<List<User>> fetchUsers() async => Future.value([]);

  @action
  Future<List<User>>? fetchUsersNullable() async => null;

  @action
  void updateNames({required String firstName, String lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @action
  void updateNamesNullable({required String? firstName, String? lastName}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = firstName;
  }

  @observable
  Future<String> foobar() async {
    return 'foobar';
  }

  @observable
  Future<String?> foobarNullable() async {
    return 'foobar';
  }

  @observable
  Stream<T> loadStuff<T>(String arg1, {T value}) async* {
    yield value;
  }

  @observable
  Stream<T?> loadStuffNullable<T>(String arg1, {T value}) async* {
    yield value;
  }

  @observable
  Stream<String> asyncGenerator() async* {
    yield 'item1';
  }

  @observable
  Stream<String>? asyncGeneratorNullable() async* {
    yield 'item1';
  }

  @action
  Future<void>? setAsyncFirstNameNullable() async {
    firstName = 'Async FirstName';
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
  @observable
  Future<void>? setAsyncFirstName2Nullable() async {
    firstName = 'Async FirstName 2';
  }

  @action
  void setBlob(blob) {} // ignore: type_annotate_public_apis
}
