mixin _$User on UserBase, Store {
  Computed<c.String> _$fullNameComputed;

  @override
  c.String get fullName =>
      (_$fullNameComputed ??= Computed<c.String>(() => super.fullName)).value;

  final _$firstNameAtom = Atom(name: 'UserBase.firstName');

  @override
  c.String get firstName {
    _$firstNameAtom.context.enforceReadPolicy(_$firstNameAtom);
    _$firstNameAtom.reportObserved();
    return super.firstName;
  }

  @override
  set firstName(c.String value) {
    _$firstNameAtom.context.conditionallyRunInAction(() {
      super.firstName = value;
      _$firstNameAtom.reportChanged();
    }, _$firstNameAtom, name: '${_$firstNameAtom.name}_set');
  }

  final _$lastNameAtom = Atom(name: 'UserBase.lastName');

  @override
  c.String get lastName {
    _$lastNameAtom.context.enforceReadPolicy(_$lastNameAtom);
    _$lastNameAtom.reportObserved();
    return super.lastName;
  }

  @override
  set lastName(c.String value) {
    _$lastNameAtom.context.conditionallyRunInAction(() {
      super.lastName = value;
      _$lastNameAtom.reportChanged();
    }, _$lastNameAtom, name: '${_$lastNameAtom.name}_set');
  }

  @override
  ObservableFuture<c.String> foobar() {
    final _$future = super.foobar();
    return ObservableFuture<c.String>(_$future);
  }

  @override
  ObservableStream<T> loadStuff<T>(c.String arg1, {T value}) {
    final _$stream = super.loadStuff<T>(arg1, value: value);
    return ObservableStream<T>(_$stream);
  }

  @override
  ObservableStream<c.String> asyncGenerator() {
    final _$stream = super.asyncGenerator();
    return ObservableStream<c.String>(_$stream);
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
  void updateNames({@required c.String firstName, c.String lastName}) {
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
