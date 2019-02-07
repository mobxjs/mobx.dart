// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_example.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$User on UserBase, Store {
  Computed<String> _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName)).value;

  final _$firstNameAtom = Atom(name: 'UserBase.firstName');

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

  final _$lastNameAtom = Atom(name: 'UserBase.lastName');

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

  final _$UserBaseActionController = ActionController(name: 'UserBase');

  @override
  void updateNames({String firstName, String lastName}) {
    final _$actionInfo = _$UserBaseActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }
}

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
