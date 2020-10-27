mixin _$User<T extends io.Process> on UserBase<T>, Store {
  Computed<io.File> _$biographyNotesComputed;

  @override
  io.File get biographyNotes => (_$biographyNotesComputed ??= Computed<io.File>(
          () => super.biographyNotes,
          name: 'UserBase.biographyNotes'))
      .value;

  final _$namesAtom = Atom(name: 'UserBase.names');

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

  final _$filesAtom = Atom(name: 'UserBase.files');

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

  final _$processesAtom = Atom(name: 'UserBase.processes');

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

  final _$biographyAtom = Atom(name: 'UserBase.biography');

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

  final _$friendWithImplicitTypeArgumentAtom =
      Atom(name: 'UserBase.friendWithImplicitTypeArgument');

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

  final _$friendWithExplicitTypeArgumentAtom =
      Atom(name: 'UserBase.friendWithExplicitTypeArgument');

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

  final _$callbackAtom = Atom(name: 'UserBase.callback');

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

  final _$callback2Atom = Atom(name: 'UserBase.callback2');

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

  final _$localTypedefCallbackAtom =
      Atom(name: 'UserBase.localTypedefCallback');

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

  final _$prefixedTypedefCallbackAtom =
      Atom(name: 'UserBase.prefixedTypedefCallback');

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

  @override
  ObservableFuture<io.File> futureBiography() {
    final _$future = super.futureBiography();
    return ObservableFuture<io.File>(_$future);
  }

  @override
  ObservableStream<T> loadDirectory<T extends io.Directory>(String arg1,
      {T directory}) {
    final _$stream = super.loadDirectory<T>(arg1, directory: directory);
    return ObservableStream<T>(_$stream);
  }

  final _$UserBaseActionController = ActionController(name: 'UserBase');

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
}
