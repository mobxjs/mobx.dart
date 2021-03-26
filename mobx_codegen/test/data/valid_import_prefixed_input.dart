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
  List<io.File?> filesNullable;

  @observable
  List<T> processes;

  @observable
  io.File biography;

  @observable
  io.File? biographyNullable;

  // This should output the type's constraint, prefixed
  @observable
  User friendWithImplicitTypeArgument;

  @observable
  User? friendWithImplicitTypeArgumentNullable;

  @observable
  User<T> friendWithExplicitTypeArgument;

  @observable
  User<T>? friendWithExplicitTypeArgumentNullable;

  @observable
  void Function(io.File, {T another}) callback;

  @observable
  void Function(io.File?, {T? another}) callbackNullable;

  @observable
  io.File Function(String, [int, io.File]) callback2;

  @observable
  io.File? Function(String?, [int?, io.File?]) callback2Nullable;

  @observable
  ValueCallback<io.Process> localTypedefCallback;

  @observable
  ValueCallback<io.Process?> localTypedefCallbackNullable;

  @observable
  io.BadCertificateCallback prefixedTypedefCallback;

  @observable
  io.BadCertificateCallback? prefixedTypedefCallbackNullable;

  @computed
  io.File get biographyNotes => io.File('${biography.path}.notes');

  @computed
  io.File? get biographyNotesNullable => io.File('${biography.path}.notes');

  @action
  void updateBiography(io.File newBiography) {
    biography = newBiography;
  }

  @action
  void updateBiographyNullable(io.File? newBiographyNullable) {
    biographyNullable = newBiographyNullable;
  }

  @observable
  Future<io.File> futureBiography() async => biography;

  @observable
  Future<io.File?> futureBiographyNullable() async => biographyNullable;

  @observable
  Stream<T> loadDirectory<T extends io.Directory>(String arg1,
      {T directory}) async* {
    yield directory;
  }

  @observable
  Stream<T?> loadDirectoryNullable<T extends io.Directory>(String? arg1,
      {T? directory}) async* {
    yield directory;
  }
}

typedef ValueCallback<T> = void Function(T);
