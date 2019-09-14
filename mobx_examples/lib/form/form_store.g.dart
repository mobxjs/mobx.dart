// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

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

  final _$colorAtom = Atom(name: '_FormStore.color');

  @override
  CustomColor get color {
    _$colorAtom.context.enforceReadPolicy(_$colorAtom);
    _$colorAtom.reportObserved();
    return super.color;
  }

  @override
  set color(CustomColor value) {
    _$colorAtom.context.conditionallyRunInAction(() {
      super.color = value;
      _$colorAtom.reportChanged();
    }, _$colorAtom, name: '${_$colorAtom.name}_set');
  }

  final _$nameAtom = Atom(name: '_FormStore.name');

  @override
  String get name {
    _$nameAtom.context.enforceReadPolicy(_$nameAtom);
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.conditionallyRunInAction(() {
      super.name = value;
      _$nameAtom.reportChanged();
    }, _$nameAtom, name: '${_$nameAtom.name}_set');
  }

  final _$emailAtom = Atom(name: '_FormStore.email');

  @override
  String get email {
    _$emailAtom.context.enforceReadPolicy(_$emailAtom);
    _$emailAtom.reportObserved();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.context.conditionallyRunInAction(() {
      super.email = value;
      _$emailAtom.reportChanged();
    }, _$emailAtom, name: '${_$emailAtom.name}_set');
  }

  final _$passwordAtom = Atom(name: '_FormStore.password');

  @override
  String get password {
    _$passwordAtom.context.enforceReadPolicy(_$passwordAtom);
    _$passwordAtom.reportObserved();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.context.conditionallyRunInAction(() {
      super.password = value;
      _$passwordAtom.reportChanged();
    }, _$passwordAtom, name: '${_$passwordAtom.name}_set');
  }

  final _$_usernameCheckAtom = Atom(name: '_FormStore._usernameCheck');

  @override
  ObservableFuture<bool> get _usernameCheck {
    _$_usernameCheckAtom.context.enforceReadPolicy(_$_usernameCheckAtom);
    _$_usernameCheckAtom.reportObserved();
    return super._usernameCheck;
  }

  @override
  set _usernameCheck(ObservableFuture<bool> value) {
    _$_usernameCheckAtom.context.conditionallyRunInAction(() {
      super._usernameCheck = value;
      _$_usernameCheckAtom.reportChanged();
    }, _$_usernameCheckAtom, name: '${_$_usernameCheckAtom.name}_set');
  }

  final _$validateUsernameAsyncAction = AsyncAction('validateUsername');

  @override
  Future validateUsername(String value) {
    return _$validateUsernameAsyncAction
        .run(() => super.validateUsername(value));
  }

  final _$_FormStoreActionController = ActionController(name: '_FormStore');

  @override
  void validatePassword(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.validatePassword(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateEmail(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.validateEmail(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }
}

mixin _$FormErrorState on _FormErrorState, Store {
  Computed<bool> _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors)).value;

  final _$usernameAtom = Atom(name: '_FormErrorState.username');

  @override
  String get username {
    _$usernameAtom.context.enforceReadPolicy(_$usernameAtom);
    _$usernameAtom.reportObserved();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.context.conditionallyRunInAction(() {
      super.username = value;
      _$usernameAtom.reportChanged();
    }, _$usernameAtom, name: '${_$usernameAtom.name}_set');
  }

  final _$emailAtom = Atom(name: '_FormErrorState.email');

  @override
  String get email {
    _$emailAtom.context.enforceReadPolicy(_$emailAtom);
    _$emailAtom.reportObserved();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.context.conditionallyRunInAction(() {
      super.email = value;
      _$emailAtom.reportChanged();
    }, _$emailAtom, name: '${_$emailAtom.name}_set');
  }

  final _$passwordAtom = Atom(name: '_FormErrorState.password');

  @override
  String get password {
    _$passwordAtom.context.enforceReadPolicy(_$passwordAtom);
    _$passwordAtom.reportObserved();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.context.conditionallyRunInAction(() {
      super.password = value;
      _$passwordAtom.reportChanged();
    }, _$passwordAtom, name: '${_$passwordAtom.name}_set');
  }
}
