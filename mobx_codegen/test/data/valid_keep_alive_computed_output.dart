mixin _$TestStore on _TestStore, Store {
  Computed<String>? _$usernameComputedComputed;

  @override
  String get usernameComputed => (_$usernameComputedComputed ??=
          Computed<String>(() => super.usernameComputed,
              name: '_TestStore.usernameComputed', keepAlive: true))
      .value;

  late final _$usernameAtom =
      Atom(name: '_TestStore.username', context: context);

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  bool _usernameIsInitialized = false;

  @override
  set username(String value) {
    _$usernameAtom
        .reportWrite(value, _usernameIsInitialized ? super.username : null, () {
      super.username = value;
      _usernameIsInitialized = true;
    });
  }
}
