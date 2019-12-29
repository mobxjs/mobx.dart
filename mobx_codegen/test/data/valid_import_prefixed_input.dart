library generator_sample;

import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class User = UserBase with _$User;

abstract class UserBase with Store {
  UserBase();

  @observable
  io.File biography;

  @observable
  User friend;

  @observable
  void Function(io.File, {io.File another}) callback;

  @observable
  io.File Function(String, [int, io.File]) callback2;

  @computed
  io.File get biographyNotes => io.File('${biography.path}.notes');

  @action
  void updateBiography(io.File newBiography) {
    biography = newBiography;
  }

  @observable
  Future<io.File> futureBiography() async => biography;

  @observable
  Stream<T> loadDirectory<T extends io.Directory>(String arg1,
      {T directory}) async* {
    yield directory;
  }
}
