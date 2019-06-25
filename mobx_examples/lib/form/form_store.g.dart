// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$colorAtom.context.isWithinBatch) {
      super.color = value;
      _$colorAtom.reportChanged();
    } else {
      runInAction(() {
        super.color = value;
        _$colorAtom.reportChanged();
      });
    }
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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$nameAtom.context.isWithinBatch) {
      super.name = value;
      _$nameAtom.reportChanged();
    } else {
      runInAction(() {
        super.name = value;
        _$nameAtom.reportChanged();
      });
    }
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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$emailAtom.context.isWithinBatch) {
      super.email = value;
      _$emailAtom.reportChanged();
    } else {
      runInAction(() {
        super.email = value;
        _$emailAtom.reportChanged();
      });
    }
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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$passwordAtom.context.isWithinBatch) {
      super.password = value;
      _$passwordAtom.reportChanged();
    } else {
      runInAction(() {
        super.password = value;
        _$passwordAtom.reportChanged();
      });
    }
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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$_usernameCheckAtom.context.isWithinBatch) {
      super._usernameCheck = value;
      _$_usernameCheckAtom.reportChanged();
    } else {
      runInAction(() {
        super._usernameCheck = value;
        _$_usernameCheckAtom.reportChanged();
      });
    }
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

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$usernameAtom.context.isWithinBatch) {
      super.username = value;
      _$usernameAtom.reportChanged();
    } else {
      runInAction(() {
        super.username = value;
        _$usernameAtom.reportChanged();
      });
    }
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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$emailAtom.context.isWithinBatch) {
      super.email = value;
      _$emailAtom.reportChanged();
    } else {
      runInAction(() {
        super.email = value;
        _$emailAtom.reportChanged();
      });
    }
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
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if (_$passwordAtom.context.isWithinBatch) {
      super.password = value;
      _$passwordAtom.reportChanged();
    } else {
      runInAction(() {
        super.password = value;
        _$passwordAtom.reportChanged();
      });
    }
  }
}
