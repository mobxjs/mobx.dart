library generator_sample;

import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

part 'generator_sample.g.dart';

class User<T extends io.Process> = UserBase<T> with _$User<T>;

@StoreConfig(hasToString: false)
abstract class UserBase<T extends io.Process> with Store {
  UserBase();

  @observable
  List<String> names;

  @observable
  List<io.File> files;

  @observable
  List<T> processes;

  @observable
  io.File biography;

  // This should output the type's constraint, prefixed
  @observable
  User friendWithImplicitTypeArgument;

  @observable
  User<T> friendWithExplicitTypeArgument;

  @observable
  void Function(io.File, {T another}) callback;

  @observable
  io.File Function(String, [int, io.File]) callback2;

  @observable
  ValueCallback<io.Process> localTypedefCallback;

  @observable
  io.BadCertificateCallback prefixedTypedefCallback;

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

typedef ValueCallback<T> = void Function(T);
