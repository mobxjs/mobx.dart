mixin _$User<T extends io.Process> on UserBase<T>, Store {
  Computed<io.File>? _$biographyNotesComputed;

  @override
  io.File get biographyNotes => (_$biographyNotesComputed ??= Computed<io.File>(
          () => super.biographyNotes,
          name: 'UserBase.biographyNotes'))
      .value;
  Computed<io.File?>? _$biographyNotesNullableComputed;

  @override
  io.File? get biographyNotesNullable => (_$biographyNotesNullableComputed ??=
          Computed<io.File?>(() => super.biographyNotesNullable,
              name: 'UserBase.biographyNotesNullable'))
      .value;

  late final _$namesAtom = Atom(name: 'UserBase.names', context: context);

  @override
  List<String> get names {
    _$namesAtom.reportRead();
    return super.names;
  }

  @override
  set names(List<String> value) {
    _$namesAtom.reportWrite(value, super.names, () {
      super.names = value;
    });
  }

  late final _$filesAtom = Atom(name: 'UserBase.files', context: context);

  @override
  List<io.File> get files {
    _$filesAtom.reportRead();
    return super.files;
  }

  @override
  set files(List<io.File> value) {
    _$filesAtom.reportWrite(value, super.files, () {
      super.files = value;
    });
  }

  late final _$filesNullableAtom =
      Atom(name: 'UserBase.filesNullable', context: context);

  @override
  List<io.File?> get filesNullable {
    _$filesNullableAtom.reportRead();
    return super.filesNullable;
  }

  @override
  set filesNullable(List<io.File?> value) {
    _$filesNullableAtom.reportWrite(value, super.filesNullable, () {
      super.filesNullable = value;
    });
  }

  late final _$processesAtom =
      Atom(name: 'UserBase.processes', context: context);

  @override
  List<T> get processes {
    _$processesAtom.reportRead();
    return super.processes;
  }

  @override
  set processes(List<T> value) {
    _$processesAtom.reportWrite(value, super.processes, () {
      super.processes = value;
    });
  }

  late final _$biographyAtom =
      Atom(name: 'UserBase.biography', context: context);

  @override
  io.File get biography {
    _$biographyAtom.reportRead();
    return super.biography;
  }

  @override
  set biography(io.File value) {
    _$biographyAtom.reportWrite(value, super.biography, () {
      super.biography = value;
    });
  }

  late final _$biographyNullableAtom =
      Atom(name: 'UserBase.biographyNullable', context: context);

  @override
  io.File? get biographyNullable {
    _$biographyNullableAtom.reportRead();
    return super.biographyNullable;
  }

  @override
  set biographyNullable(io.File? value) {
    _$biographyNullableAtom.reportWrite(value, super.biographyNullable, () {
      super.biographyNullable = value;
    });
  }

  late final _$friendWithImplicitTypeArgumentAtom =
      Atom(name: 'UserBase.friendWithImplicitTypeArgument', context: context);

  @override
  User<io.Process> get friendWithImplicitTypeArgument {
    _$friendWithImplicitTypeArgumentAtom.reportRead();
    return super.friendWithImplicitTypeArgument;
  }

  @override
  set friendWithImplicitTypeArgument(User<io.Process> value) {
    _$friendWithImplicitTypeArgumentAtom
        .reportWrite(value, super.friendWithImplicitTypeArgument, () {
      super.friendWithImplicitTypeArgument = value;
    });
  }

  late final _$friendWithImplicitTypeArgumentNullableAtom = Atom(
      name: 'UserBase.friendWithImplicitTypeArgumentNullable',
      context: context);

  @override
  User<io.Process>? get friendWithImplicitTypeArgumentNullable {
    _$friendWithImplicitTypeArgumentNullableAtom.reportRead();
    return super.friendWithImplicitTypeArgumentNullable;
  }

  @override
  set friendWithImplicitTypeArgumentNullable(User<io.Process>? value) {
    _$friendWithImplicitTypeArgumentNullableAtom
        .reportWrite(value, super.friendWithImplicitTypeArgumentNullable, () {
      super.friendWithImplicitTypeArgumentNullable = value;
    });
  }

  late final _$friendWithExplicitTypeArgumentAtom =
      Atom(name: 'UserBase.friendWithExplicitTypeArgument', context: context);

  @override
  User<T> get friendWithExplicitTypeArgument {
    _$friendWithExplicitTypeArgumentAtom.reportRead();
    return super.friendWithExplicitTypeArgument;
  }

  @override
  set friendWithExplicitTypeArgument(User<T> value) {
    _$friendWithExplicitTypeArgumentAtom
        .reportWrite(value, super.friendWithExplicitTypeArgument, () {
      super.friendWithExplicitTypeArgument = value;
    });
  }

  late final _$friendWithExplicitTypeArgumentNullableAtom = Atom(
      name: 'UserBase.friendWithExplicitTypeArgumentNullable',
      context: context);

  @override
  User<T>? get friendWithExplicitTypeArgumentNullable {
    _$friendWithExplicitTypeArgumentNullableAtom.reportRead();
    return super.friendWithExplicitTypeArgumentNullable;
  }

  @override
  set friendWithExplicitTypeArgumentNullable(User<T>? value) {
    _$friendWithExplicitTypeArgumentNullableAtom
        .reportWrite(value, super.friendWithExplicitTypeArgumentNullable, () {
      super.friendWithExplicitTypeArgumentNullable = value;
    });
  }

  late final _$callbackAtom = Atom(name: 'UserBase.callback', context: context);

  @override
  void Function(io.File, {T another}) get callback {
    _$callbackAtom.reportRead();
    return super.callback;
  }

  @override
  set callback(void Function(io.File, {T another}) value) {
    _$callbackAtom.reportWrite(value, super.callback, () {
      super.callback = value;
    });
  }

  late final _$callbackNullableAtom =
      Atom(name: 'UserBase.callbackNullable', context: context);

  @override
  void Function(io.File?, {T? another}) get callbackNullable {
    _$callbackNullableAtom.reportRead();
    return super.callbackNullable;
  }

  @override
  set callbackNullable(void Function(io.File?, {T? another}) value) {
    _$callbackNullableAtom.reportWrite(value, super.callbackNullable, () {
      super.callbackNullable = value;
    });
  }

  late final _$callback2Atom =
      Atom(name: 'UserBase.callback2', context: context);

  @override
  io.File Function(String, [int, io.File]) get callback2 {
    _$callback2Atom.reportRead();
    return super.callback2;
  }

  @override
  set callback2(io.File Function(String, [int, io.File]) value) {
    _$callback2Atom.reportWrite(value, super.callback2, () {
      super.callback2 = value;
    });
  }

  late final _$callback2NullableAtom =
      Atom(name: 'UserBase.callback2Nullable', context: context);

  @override
  io.File? Function(String?, [int?, io.File?]) get callback2Nullable {
    _$callback2NullableAtom.reportRead();
    return super.callback2Nullable;
  }

  @override
  set callback2Nullable(io.File? Function(String?, [int?, io.File?]) value) {
    _$callback2NullableAtom.reportWrite(value, super.callback2Nullable, () {
      super.callback2Nullable = value;
    });
  }

  late final _$localTypedefCallbackAtom =
      Atom(name: 'UserBase.localTypedefCallback', context: context);

  @override
  ValueCallback<io.Process> get localTypedefCallback {
    _$localTypedefCallbackAtom.reportRead();
    return super.localTypedefCallback;
  }

  @override
  set localTypedefCallback(ValueCallback<io.Process> value) {
    _$localTypedefCallbackAtom.reportWrite(value, super.localTypedefCallback,
        () {
      super.localTypedefCallback = value;
    });
  }

  late final _$localTypedefCallbackNullableAtom =
      Atom(name: 'UserBase.localTypedefCallbackNullable', context: context);

  @override
  ValueCallback<io.Process?> get localTypedefCallbackNullable {
    _$localTypedefCallbackNullableAtom.reportRead();
    return super.localTypedefCallbackNullable;
  }

  @override
  set localTypedefCallbackNullable(ValueCallback<io.Process?> value) {
    _$localTypedefCallbackNullableAtom
        .reportWrite(value, super.localTypedefCallbackNullable, () {
      super.localTypedefCallbackNullable = value;
    });
  }

  late final _$prefixedTypedefCallbackAtom =
      Atom(name: 'UserBase.prefixedTypedefCallback', context: context);

  @override
  io.BadCertificateCallback get prefixedTypedefCallback {
    _$prefixedTypedefCallbackAtom.reportRead();
    return super.prefixedTypedefCallback;
  }

  @override
  set prefixedTypedefCallback(io.BadCertificateCallback value) {
    _$prefixedTypedefCallbackAtom
        .reportWrite(value, super.prefixedTypedefCallback, () {
      super.prefixedTypedefCallback = value;
    });
  }

  late final _$prefixedTypedefCallbackNullableAtom =
      Atom(name: 'UserBase.prefixedTypedefCallbackNullable', context: context);

  @override
  io.BadCertificateCallback? get prefixedTypedefCallbackNullable {
    _$prefixedTypedefCallbackNullableAtom.reportRead();
    return super.prefixedTypedefCallbackNullable;
  }

  @override
  set prefixedTypedefCallbackNullable(io.BadCertificateCallback? value) {
    _$prefixedTypedefCallbackNullableAtom
        .reportWrite(value, super.prefixedTypedefCallbackNullable, () {
      super.prefixedTypedefCallbackNullable = value;
    });
  }

  @override
  ObservableFuture<io.File> futureBiography() {
    final _$future = super.futureBiography();
    return ObservableFuture<io.File>(_$future, context: context);
  }

  @override
  ObservableFuture<io.File?> futureBiographyNullable() {
    final _$future = super.futureBiographyNullable();
    return ObservableFuture<io.File?>(_$future, context: context);
  }

  @override
  ObservableStream<T> loadDirectory<T extends io.Directory>(String arg1,
      {T directory}) {
    final _$stream = super.loadDirectory<T>(arg1, directory: directory);
    return ObservableStream<T>(_$stream, context: context);
  }

  @override
  ObservableStream<T?> loadDirectoryNullable<T extends io.Directory>(
      String? arg1,
      {T? directory}) {
    final _$stream = super.loadDirectoryNullable<T>(arg1, directory: directory);
    return ObservableStream<T?>(_$stream, context: context);
  }

  late final _$UserBaseActionController =
      ActionController(name: 'UserBase', context: context);

  @override
  void updateBiography(io.File newBiography) {
    final _$actionInfo = _$UserBaseActionController.startAction(
        name: 'UserBase.updateBiography');
    try {
      return super.updateBiography(newBiography);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateBiographyNullable(io.File? newBiographyNullable) {
    final _$actionInfo = _$UserBaseActionController.startAction(
        name: 'UserBase.updateBiographyNullable');
    try {
      return super.updateBiographyNullable(newBiographyNullable);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }
}
