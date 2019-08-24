class User extends _User {
  User(int id) : super(id);

  User.withNames({String firstName = 'Scott', String lastName})
      : super.withNames(firstName: firstName, lastName: lastName);

  Computed<String> _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName)).value;

  final _$firstNameAtom = Atom(name: '_User.firstName');

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

  final _$lastNameAtom = Atom(name: '_User.lastName');

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

  final _$_UserActionController = ActionController(name: '_User');

  @override
  void updateNames({String firstName, String lastName}) {
    final _$actionInfo = _$_UserActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$_UserActionController.endAction(_$actionInfo);
    }
  }
}
