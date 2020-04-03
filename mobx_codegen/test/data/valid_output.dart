mixin _$User on UserBase, Store {
  Computed<String> _$fullNameComputed;

  @override
  String get fullName => (_$fullNameComputed ??=
          Computed<String>(() => super.fullName, name: 'UserBase.fullName'))
      .value;

  final _$firstNameAtom = Atom(name: 'UserBase.firstName');

  @override
  String get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  final _$middleNameAtom = Atom(name: 'UserBase.middleName');

  @override
  String get middleName {
    _$middleNameAtom.reportRead();
    return super.middleName;
  }

  @override
  set middleName(String value) {
    _$middleNameAtom.reportWrite(value, super.middleName, () {
      super.middleName = value;
    });
  }

  final _$lastNameAtom = Atom(name: 'UserBase.lastName');

  @override
  String get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  final _$friendAtom = Atom(name: 'UserBase.friend');

  @override
  User get friend {
    _$friendAtom.reportRead();
    return super.friend;
  }

  @override
  set friend(User value) {
    _$friendAtom.reportWrite(value, super.friend, () {
      super.friend = value;
    });
  }

  final _$callbackAtom = Atom(name: 'UserBase.callback');

  @override
  void Function() get callback {
    _$callbackAtom.reportRead();
    return super.callback;
  }

  @override
  set callback(void Function() value) {
    _$callbackAtom.reportWrite(value, super.callback, () {
      super.callback = value;
    });
  }

  final _$callback2Atom = Atom(name: 'UserBase.callback2');

  @override
  VoidCallback get callback2 {
    _$callback2Atom.reportRead();
    return super.callback2;
  }

  @override
  set callback2(VoidCallback value) {
    _$callback2Atom.reportWrite(value, super.callback2, () {
      super.callback2 = value;
    });
  }

  final _$_testUsersAtom = Atom(name: 'UserBase._testUsers');

  @override
  List<User> get _testUsers {
    _$_testUsersAtom.reportRead();
    return super._testUsers;
  }

  @override
  set _testUsers(List<User> value) {
    _$_testUsersAtom.reportWrite(value, super._testUsers, () {
      super._testUsers = value;
    });
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

  final _$fetchUsersAsyncAction = AsyncAction('UserBase.fetchUsers');

  @override
  Future<List<User>> fetchUsers() {
    return _$fetchUsersAsyncAction.run(() => super.fetchUsers());
  }

  final _$setAsyncFirstNameAsyncAction =
      AsyncAction('UserBase.setAsyncFirstName');

  @override
  Future<void> setAsyncFirstName() {
    return _$setAsyncFirstNameAsyncAction.run(() => super.setAsyncFirstName());
  }

  final _$setAsyncFirstName2AsyncAction =
      AsyncAction('UserBase.setAsyncFirstName2');

  @override
  ObservableFuture<void> setAsyncFirstName2() {
    return ObservableFuture<void>(
        _$setAsyncFirstName2AsyncAction.run(() => super.setAsyncFirstName2()));
  }

  final _$UserBaseActionController = ActionController(name: 'UserBase');

  @override
  void updateNames({@required String firstName, String lastName}) {
    final _$actionInfo =
        _$UserBaseActionController.startAction(name: 'UserBase.updateNames');
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBlob(dynamic blob) {
    final _$actionInfo =
        _$UserBaseActionController.startAction(name: 'UserBase.setBlob');
    try {
      return super.setBlob(blob);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }
}
