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
    super.lastName = value;
    _$lastNameAtom.reportChanged();
  }

  final _$UserBaseActionController = ActionController(name: 'UserBase');

  @override
  void updateNames({String firstName, String lastName}) {
    final _$prevDerivation = _$UserBaseActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$UserBaseActionController.endAction(_$prevDerivation);
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
    super.accessRights = value;
    _$accessRightsAtom.reportChanged();
  }
}
