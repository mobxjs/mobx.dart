// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_example.dart';

// **************************************************************************
// ObservableGenerator
// **************************************************************************

class _$User extends User {
  _$User() : super._() {
    _$fullNameComputed = Computed(() => super.fullName);
  }

  final _$firstNameAtom = Atom(name: 'User.firstName');

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

  final _$lastNameAtom = Atom(name: 'User.lastName');

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

  Computed<String> _$fullNameComputed;

  @override
  String get fullName => _$fullNameComputed.value;

  // Actions here

  final _$UserActionController = ActionController(name: 'User');

  @override
  void updateNames({String firstName, String lastName}) {
    final _$prevDerivation = _$UserActionController.startAction();
    try {
      return super.updateNames(firstName: firstName, lastName: lastName);
    } finally {
      _$UserActionController.endAction(_$prevDerivation);
    }
  }
}
