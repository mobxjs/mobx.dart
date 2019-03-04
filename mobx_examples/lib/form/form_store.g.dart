// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$FormStore on _FormStore, Store {
  Computed<bool> _$isUserCheckPendingComputed;

  @override
  bool get isUserCheckPending => (_$isUserCheckPendingComputed ??=
          Computed<bool>(() => super.isUserCheckPending))
      .value;
  Computed<bool> _$canLoginComputed;

  @override
  bool get canLogin =>
      (_$canLoginComputed ??= Computed<bool>(() => super.canLogin)).value;

  final _$nameAtom = Atom(name: '_FormStore.name');

  @override
  String get name {
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$nameAtom);
    super.name = value;
    _$nameAtom.reportChanged();
  }

  final _$emailAtom = Atom(name: '_FormStore.email');

  @override
  String get email {
    _$emailAtom.reportObserved();
    return super.email;
  }

  @override
  set email(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$emailAtom);
    super.email = value;
    _$emailAtom.reportChanged();
  }

  final _$passwordAtom = Atom(name: '_FormStore.password');

  @override
  String get password {
    _$passwordAtom.reportObserved();
    return super.password;
  }

  @override
  set password(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$passwordAtom);
    super.password = value;
    _$passwordAtom.reportChanged();
  }

  final _$_usernameCheckAtom = Atom(name: '_FormStore._usernameCheck');

  @override
  ObservableFuture<bool> get _usernameCheck {
    _$_usernameCheckAtom.reportObserved();
    return super._usernameCheck;
  }

  @override
  set _usernameCheck(ObservableFuture<bool> value) {
    mainContext.checkIfStateModificationsAreAllowed(_$_usernameCheckAtom);
    super._usernameCheck = value;
    _$_usernameCheckAtom.reportChanged();
  }

  final _$validateUsernameAsyncAction = AsyncAction('validateUsername');

  @override
  Future<dynamic> validateUsername(String value) {
    return _$validateUsernameAsyncAction
        .run(() => super.validateUsername(value));
  }

  final _$_FormStoreActionController = ActionController(name: '_FormStore');

  @override
  void setUsername(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.setUsername(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.setEmail(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.setPassword(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$FormErrorState on _FormErrorState, Store {
  Computed<bool> _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors)).value;

  final _$usernameAtom = Atom(name: '_FormErrorState.username');

  @override
  String get username {
    _$usernameAtom.reportObserved();
    return super.username;
  }

  @override
  set username(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$usernameAtom);
    super.username = value;
    _$usernameAtom.reportChanged();
  }

  final _$emailAtom = Atom(name: '_FormErrorState.email');

  @override
  String get email {
    _$emailAtom.reportObserved();
    return super.email;
  }

  @override
  set email(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$emailAtom);
    super.email = value;
    _$emailAtom.reportChanged();
  }

  final _$passwordAtom = Atom(name: '_FormErrorState.password');

  @override
  String get password {
    _$passwordAtom.reportObserved();
    return super.password;
  }

  @override
  set password(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$passwordAtom);
    super.password = value;
    _$passwordAtom.reportChanged();
  }
}
