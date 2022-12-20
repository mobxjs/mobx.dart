mixin _$User on UserBase, Store {
  Computed<String>? _$fullNameComputed;

  @override
  String get fullName => (_$fullNameComputed ??=
          Computed<String>(() => super.fullName, name: 'UserBase.fullName'))
      .value;
  Computed<String?>? _$fullNameNullableComputed;

  @override
  String? get fullNameNullable => (_$fullNameNullableComputed ??=
          Computed<String?>(() => super.fullNameNullable,
              name: 'UserBase.fullNameNullable'))
      .value;

  late final _$firstNameAtom =
      Atom(name: 'UserBase.firstName', context: context);

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

  late final _$firstNameNullableAtom =
      Atom(name: 'UserBase.firstNameNullable', context: context);

  @override
  String? get firstNameNullable {
    _$firstNameNullableAtom.reportRead();
    return super.firstNameNullable;
  }

  @override
  set firstNameNullable(String? value) {
    _$firstNameNullableAtom.reportWrite(value, super.firstNameNullable, () {
      super.firstNameNullable = value;
    });
  }

  late final _$middleNameAtom =
      Atom(name: 'UserBase.middleName', context: context);

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

  late final _$lastNameAtom = Atom(name: 'UserBase.lastName', context: context);

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

  late final _$friendAtom = Atom(name: 'UserBase.friend', context: context);

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

  late final _$friendNullableAtom =
      Atom(name: 'UserBase.friendNullable', context: context);

  @override
  User? get friendNullable {
    _$friendNullableAtom.reportRead();
    return super.friendNullable;
  }

  @override
  set friendNullable(User? value) {
    _$friendNullableAtom.reportWrite(value, super.friendNullable, () {
      super.friendNullable = value;
    });
  }

  late final _$callbackAtom = Atom(name: 'UserBase.callback', context: context);

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

  late final _$callbackNullableAtom =
      Atom(name: 'UserBase.callbackNullable', context: context);

  @override
  void Function() get callbackNullable {
    _$callbackNullableAtom.reportRead();
    return super.callbackNullable;
  }

  @override
  set callbackNullable(void Function() value) {
    _$callbackNullableAtom.reportWrite(value, super.callbackNullable, () {
      super.callbackNullable = value;
    });
  }

  late final _$callback2Atom =
      Atom(name: 'UserBase.callback2', context: context);

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

  late final _$callback2NullableAtom =
      Atom(name: 'UserBase.callback2Nullable', context: context);

  @override
  VoidCallback? get callback2Nullable {
    _$callback2NullableAtom.reportRead();
    return super.callback2Nullable;
  }

  @override
  set callback2Nullable(VoidCallback? value) {
    _$callback2NullableAtom.reportWrite(value, super.callback2Nullable, () {
      super.callback2Nullable = value;
    });
  }

  late final _$_testUsersAtom =
      Atom(name: 'UserBase._testUsers', context: context);

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
    return ObservableFuture<String>(_$future, context: context);
  }

  @override
  ObservableFuture<String?> foobarNullable() {
    final _$future = super.foobarNullable();
    return ObservableFuture<String?>(_$future, context: context);
  }

  @override
  ObservableStream<T> loadStuff<T>(String arg1, {T value}) {
    final _$stream = super.loadStuff<T>(arg1, value: value);
    return ObservableStream<T>(_$stream, context: context);
  }

  @override
  ObservableStream<T?> loadStuffNullable<T>(String arg1, {T value}) {
    final _$stream = super.loadStuffNullable<T>(arg1, value: value);
    return ObservableStream<T?>(_$stream, context: context);
  }

  @override
  ObservableStream<String> asyncGenerator() {
    final _$stream = super.asyncGenerator();
    return ObservableStream<String>(_$stream, context: context);
  }

  @override
  ObservableStream<String> asyncGeneratorNullable() {
    final _$stream = super.asyncGeneratorNullable();
    return ObservableStream<String>(_$stream, context: context);
  }

  late final _$fetchUsersAsyncAction =
      AsyncAction('UserBase.fetchUsers', context: context);

  @override
  Future<List<User>> fetchUsers() {
    return _$fetchUsersAsyncAction.run(() => super.fetchUsers());
  }

  late final _$fetchUsersNullableAsyncAction =
      AsyncAction('UserBase.fetchUsersNullable', context: context);

  @override
  Future<List<User>> fetchUsersNullable() {
    return _$fetchUsersNullableAsyncAction
        .run(() => super.fetchUsersNullable());
  }

  late final _$setAsyncFirstNameNullableAsyncAction =
      AsyncAction('UserBase.setAsyncFirstNameNullable', context: context);

  @override
  Future<void> setAsyncFirstNameNullable() {
    return _$setAsyncFirstNameNullableAsyncAction
        .run(() => super.setAsyncFirstNameNullable());
  }

  late final _$setAsyncFirstNameAsyncAction =
      AsyncAction('UserBase.setAsyncFirstName', context: context);

  @override
  Future<void> setAsyncFirstName() {
    return _$setAsyncFirstNameAsyncAction.run(() => super.setAsyncFirstName());
  }

  late final _$setAsyncFirstName2AsyncAction =
      AsyncAction('UserBase.setAsyncFirstName2', context: context);

  @override
  ObservableFuture<void> setAsyncFirstName2() {
    return ObservableFuture<void>(
        _$setAsyncFirstName2AsyncAction.run(() => super.setAsyncFirstName2()));
  }

  late final _$setAsyncFirstName2NullableAsyncAction =
      AsyncAction('UserBase.setAsyncFirstName2Nullable', context: context);

  @override
  ObservableFuture<void> setAsyncFirstName2Nullable() {
    return ObservableFuture<void>(_$setAsyncFirstName2NullableAsyncAction
        .run(() => super.setAsyncFirstName2Nullable()));
  }

  late final _$UserBaseActionController =
      ActionController(name: 'UserBase', context: context);

  @override
  void updateNames({required String firstName, String lastName}) {
    final _$actionInfo =
        _$UserBaseActionController.startAction(name: 'UserBase.updateNames');
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateNamesNullable({required String? firstName, String? lastName}) {
    final _$actionInfo = _$UserBaseActionController.startAction(
        name: 'UserBase.updateNamesNullable');
    try {
      return super
          .updateNamesNullable(firstName: firstName, lastName: lastName);
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
