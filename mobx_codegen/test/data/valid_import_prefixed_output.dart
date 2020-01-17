mixin _$User<T extends io.Process> on UserBase<T>, Store {
  Computed<io.File> _$biographyNotesComputed;

  @override
  io.File get biographyNotes => (_$biographyNotesComputed ??=
          Computed<io.File>(() => super.biographyNotes))
      .value;

  final _$namesAtom = Atom(name: 'UserBase.names');

  @override
  List<String> get names {
    _$namesAtom.context.enforceReadPolicy(_$namesAtom);
    _$namesAtom.reportObserved();
    return super.names;
  }

  @override
  set names(List<String> value) {
    _$namesAtom.context.conditionallyRunInAction(() {
      super.names = value;
      _$namesAtom.reportChanged();
    }, _$namesAtom, name: '${_$namesAtom.name}_set');
  }

  final _$filesAtom = Atom(name: 'UserBase.files');

  @override
  List<io.File> get files {
    _$filesAtom.context.enforceReadPolicy(_$filesAtom);
    _$filesAtom.reportObserved();
    return super.files;
  }

  @override
  set files(List<io.File> value) {
    _$filesAtom.context.conditionallyRunInAction(() {
      super.files = value;
      _$filesAtom.reportChanged();
    }, _$filesAtom, name: '${_$filesAtom.name}_set');
  }

  final _$processesAtom = Atom(name: 'UserBase.processes');

  @override
  List<T> get processes {
    _$processesAtom.context.enforceReadPolicy(_$processesAtom);
    _$processesAtom.reportObserved();
    return super.processes;
  }

  @override
  set processes(List<T> value) {
    _$processesAtom.context.conditionallyRunInAction(() {
      super.processes = value;
      _$processesAtom.reportChanged();
    }, _$processesAtom, name: '${_$processesAtom.name}_set');
  }

  final _$biographyAtom = Atom(name: 'UserBase.biography');

  @override
  io.File get biography {
    _$biographyAtom.context.enforceReadPolicy(_$biographyAtom);
    _$biographyAtom.reportObserved();
    return super.biography;
  }

  @override
  set biography(io.File value) {
    _$biographyAtom.context.conditionallyRunInAction(() {
      super.biography = value;
      _$biographyAtom.reportChanged();
    }, _$biographyAtom, name: '${_$biographyAtom.name}_set');
  }

  final _$friendWithImplicitTypeArgumentAtom =
      Atom(name: 'UserBase.friendWithImplicitTypeArgument');

  @override
  User<io.Process> get friendWithImplicitTypeArgument {
    _$friendWithImplicitTypeArgumentAtom.context
        .enforceReadPolicy(_$friendWithImplicitTypeArgumentAtom);
    _$friendWithImplicitTypeArgumentAtom.reportObserved();
    return super.friendWithImplicitTypeArgument;
  }

  @override
  set friendWithImplicitTypeArgument(User<io.Process> value) {
    _$friendWithImplicitTypeArgumentAtom.context.conditionallyRunInAction(() {
      super.friendWithImplicitTypeArgument = value;
      _$friendWithImplicitTypeArgumentAtom.reportChanged();
    }, _$friendWithImplicitTypeArgumentAtom,
        name: '${_$friendWithImplicitTypeArgumentAtom.name}_set');
  }

  final _$friendWithExplicitTypeArgumentAtom =
      Atom(name: 'UserBase.friendWithExplicitTypeArgument');

  @override
  User<T> get friendWithExplicitTypeArgument {
    _$friendWithExplicitTypeArgumentAtom.context
        .enforceReadPolicy(_$friendWithExplicitTypeArgumentAtom);
    _$friendWithExplicitTypeArgumentAtom.reportObserved();
    return super.friendWithExplicitTypeArgument;
  }

  @override
  set friendWithExplicitTypeArgument(User<T> value) {
    _$friendWithExplicitTypeArgumentAtom.context.conditionallyRunInAction(() {
      super.friendWithExplicitTypeArgument = value;
      _$friendWithExplicitTypeArgumentAtom.reportChanged();
    }, _$friendWithExplicitTypeArgumentAtom,
        name: '${_$friendWithExplicitTypeArgumentAtom.name}_set');
  }

  final _$callbackAtom = Atom(name: 'UserBase.callback');

  @override
  void Function(io.File, {T another}) get callback {
    _$callbackAtom.context.enforceReadPolicy(_$callbackAtom);
    _$callbackAtom.reportObserved();
    return super.callback;
  }

  @override
  set callback(void Function(io.File, {T another}) value) {
    _$callbackAtom.context.conditionallyRunInAction(() {
      super.callback = value;
      _$callbackAtom.reportChanged();
    }, _$callbackAtom, name: '${_$callbackAtom.name}_set');
  }

  final _$callback2Atom = Atom(name: 'UserBase.callback2');

  @override
  io.File Function(String, [int, io.File]) get callback2 {
    _$callback2Atom.context.enforceReadPolicy(_$callback2Atom);
    _$callback2Atom.reportObserved();
    return super.callback2;
  }

  @override
  set callback2(io.File Function(String, [int, io.File]) value) {
    _$callback2Atom.context.conditionallyRunInAction(() {
      super.callback2 = value;
      _$callback2Atom.reportChanged();
    }, _$callback2Atom, name: '${_$callback2Atom.name}_set');
  }

  final _$localTypedefCallbackAtom =
      Atom(name: 'UserBase.localTypedefCallback');

  @override
  ValueCallback<io.Process> get localTypedefCallback {
    _$localTypedefCallbackAtom.context
        .enforceReadPolicy(_$localTypedefCallbackAtom);
    _$localTypedefCallbackAtom.reportObserved();
    return super.localTypedefCallback;
  }

  @override
  set localTypedefCallback(ValueCallback<io.Process> value) {
    _$localTypedefCallbackAtom.context.conditionallyRunInAction(() {
      super.localTypedefCallback = value;
      _$localTypedefCallbackAtom.reportChanged();
    }, _$localTypedefCallbackAtom,
        name: '${_$localTypedefCallbackAtom.name}_set');
  }

  final _$prefixedTypedefCallbackAtom =
      Atom(name: 'UserBase.prefixedTypedefCallback');

  @override
  io.BadCertificateCallback get prefixedTypedefCallback {
    _$prefixedTypedefCallbackAtom.context
        .enforceReadPolicy(_$prefixedTypedefCallbackAtom);
    _$prefixedTypedefCallbackAtom.reportObserved();
    return super.prefixedTypedefCallback;
  }

  @override
  set prefixedTypedefCallback(io.BadCertificateCallback value) {
    _$prefixedTypedefCallbackAtom.context.conditionallyRunInAction(() {
      super.prefixedTypedefCallback = value;
      _$prefixedTypedefCallbackAtom.reportChanged();
    }, _$prefixedTypedefCallbackAtom,
        name: '${_$prefixedTypedefCallbackAtom.name}_set');
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
    final _$actionInfo = _$UserBaseActionController.startAction();
    try {
      return super.updateBiography(newBiography);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }
}
