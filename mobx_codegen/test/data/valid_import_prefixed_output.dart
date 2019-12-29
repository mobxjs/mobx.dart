mixin _$User on UserBase, Store {
  Computed<io.File> _$biographyNotesComputed;

  @override
  io.File get biographyNotes => (_$biographyNotesComputed ??=
          Computed<io.File>(() => super.biographyNotes))
      .value;

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

  final _$friendAtom = Atom(name: 'UserBase.friend');

  @override
  User get friend {
    _$friendAtom.context.enforceReadPolicy(_$friendAtom);
    _$friendAtom.reportObserved();
    return super.friend;
  }

  @override
  set friend(User value) {
    _$friendAtom.context.conditionallyRunInAction(() {
      super.friend = value;
      _$friendAtom.reportChanged();
    }, _$friendAtom, name: '${_$friendAtom.name}_set');
  }

  final _$callbackAtom = Atom(name: 'UserBase.callback');

  @override
  void Function(io.File, {io.File another}) get callback {
    _$callbackAtom.context.enforceReadPolicy(_$callbackAtom);
    _$callbackAtom.reportObserved();
    return super.callback;
  }

  @override
  set callback(void Function(io.File, {io.File another}) value) {
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
