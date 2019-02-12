// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_example.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$User on _User, Store {
  Computed<String> _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName)).value;

  final _$firstNameAtom = Atom(name: '_User.firstName');

  @override
  String get firstName {
    _$firstNameAtom.reportObserved();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$firstNameAtom);
    super.firstName = value;
    _$firstNameAtom.reportChanged();
  }

  final _$lastNameAtom = Atom(name: '_User.lastName');

  @override
  String get lastName {
    _$lastNameAtom.reportObserved();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$lastNameAtom);
    super.lastName = value;
    _$lastNameAtom.reportChanged();
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

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$Admin on AdminBase, Store {
  final _$userNameAtom = Atom(name: 'AdminBase.userName');

  @override
  String get userName {
    _$userNameAtom.reportObserved();
    return super.userName;
  }

  @override
  set userName(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$userNameAtom);
    super.userName = value;
    _$userNameAtom.reportChanged();
  }

  final _$accessRightsAtom = Atom(name: 'AdminBase.accessRights');

  @override
  ObservableList<String> get accessRights {
    _$accessRightsAtom.reportObserved();
    return super.accessRights;
  }

  @override
  set accessRights(ObservableList<String> value) {
    mainContext.checkIfStateModificationsAreAllowed(_$accessRightsAtom);
    super.accessRights = value;
    _$accessRightsAtom.reportChanged();
  }

  @override
  ObservableFuture<String> loadPrivileges([String foo]) {
    final _$future = super.loadPrivileges(foo);
    return ObservableFuture<String>(_$future);
  }

  @override
  ObservableStream<T> loadStuff<T>(String arg1, {T value}) {
    final _$stream = super.loadStuff<T>(arg1, value: value);
    return ObservableStream<T>(_$stream);
  }

  final _$loadAccessRightsAsyncAction = AsyncAction('loadAccessRights');

  @override
  ObservableFuture<void> loadAccessRights() {
    return ObservableFuture<void>(
        _$loadAccessRightsAsyncAction.run(() => super.loadAccessRights()));
  }
}
