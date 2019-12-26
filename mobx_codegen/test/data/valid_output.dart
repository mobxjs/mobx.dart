mixin _$User on UserBase, Store {
  Computed<String> _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName)).value;

  final _$firstNameAtom = Atom(name: 'UserBase.firstName');

  @override
  String get firstName {
    _$firstNameAtom.context.enforceReadPolicy(_$firstNameAtom);
    _$firstNameAtom.reportObserved();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    _$firstNameAtom.context.conditionallyRunInAction(() {
      super.firstName = value;
      _$firstNameAtom.reportChanged();
    }, _$firstNameAtom, name: '${_$firstNameAtom.name}_set');
  }

  final _$middleNameAtom = Atom(name: 'UserBase.middleName');

  @override
  String get middleName {
    _$middleNameAtom.context.enforceReadPolicy(_$middleNameAtom);
    _$middleNameAtom.reportObserved();
    return super.middleName;
  }

  @override
  set middleName(String value) {
    _$middleNameAtom.context.conditionallyRunInAction(() {
      super.middleName = value;
      _$middleNameAtom.reportChanged();
    }, _$middleNameAtom, name: '${_$middleNameAtom.name}_set');
  }

  final _$lastNameAtom = Atom(name: 'UserBase.lastName');

  @override
  String get lastName {
    _$lastNameAtom.context.enforceReadPolicy(_$lastNameAtom);
    _$lastNameAtom.reportObserved();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    _$lastNameAtom.context.conditionallyRunInAction(() {
      super.lastName = value;
      _$lastNameAtom.reportChanged();
    }, _$lastNameAtom, name: '${_$lastNameAtom.name}_set');
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
  void Function() get callback {
    _$callbackAtom.context.enforceReadPolicy(_$callbackAtom);
    _$callbackAtom.reportObserved();
    return super.callback;
  }

  @override
  set callback(void Function() value) {
    _$callbackAtom.context.conditionallyRunInAction(() {
      super.callback = value;
      _$callbackAtom.reportChanged();
    }, _$callbackAtom, name: '${_$callbackAtom.name}_set');
  }

  final _$callback2Atom = Atom(name: 'UserBase.callback2');

  @override
  VoidCallback get callback2 {
    _$callback2Atom.context.enforceReadPolicy(_$callback2Atom);
    _$callback2Atom.reportObserved();
    return super.callback2;
  }

  @override
  set callback2(VoidCallback value) {
    _$callback2Atom.context.conditionallyRunInAction(() {
      super.callback2 = value;
      _$callback2Atom.reportChanged();
    }, _$callback2Atom, name: '${_$callback2Atom.name}_set');
  }

  @override
  ObservableFuture<String> foobar() {
    final _$future = super.foobar();
    return ObservableFuture<String>(_$future);
  }

  @override
  ObservableStream<T> loadStuff<T>(String arg1, {T value}) {
    final _$stream = super.loadStuff<T>(arg1, value: value);
    return ObservableStream<T>(_$stream);
  }

  @override
  ObservableStream<String> asyncGenerator() {
    final _$stream = super.asyncGenerator();
    return ObservableStream<String>(_$stream);
  }

  final _$setAsyncFirstNameAsyncAction = AsyncAction('setAsyncFirstName');

  @override
  Future<void> setAsyncFirstName() {
    return _$setAsyncFirstNameAsyncAction.run(() => super.setAsyncFirstName());
  }

  final _$setAsyncFirstName2AsyncAction = AsyncAction('setAsyncFirstName2');

  @override
  ObservableFuture<void> setAsyncFirstName2() {
    return ObservableFuture<void>(
        _$setAsyncFirstName2AsyncAction.run(() => super.setAsyncFirstName2()));
  }

  final _$UserBaseActionController = ActionController(name: 'UserBase');

  @override
  void updateNames({@required String firstName, String lastName}) {
    final _$actionInfo = _$UserBaseActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBlob(dynamic blob) {
    final _$actionInfo = _$UserBaseActionController.startAction();
    try {
      return super.setBlob(blob);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }
}
