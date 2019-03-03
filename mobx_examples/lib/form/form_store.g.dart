// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$FormStore on _FormStore, Store {
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

  final _$_FormStoreActionController = ActionController(name: '_FormStore');

  @override
  void setName(String name) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.setName(name);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String email) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.setEmail(email);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String password) {
    final _$actionInfo = _$_FormStoreActionController.startAction();
    try {
      return super.setPassword(password);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }
}
