import 'dart:ui';

import 'package:mobx/mobx.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:validators2/validators.dart';

part 'form_store.g.dart';

class CustomColor extends Color {
  CustomColor(int value) : super(value);
}

// ignore: library_private_types_in_public_api
class FormStore = _FormStore with _$FormStore;

abstract class _FormStore with Store {
  final FormErrorState error = FormErrorState();

  @observable
  CustomColor color = CustomColor(0);

  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  ObservableFuture<bool> usernameCheck = ObservableFuture.value(false);

  @computed
  bool get isUserCheckPending => usernameCheck.status == FutureStatus.pending;

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => name, validateName),
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
    ];
  }

  void dispose() {
    for (var d in _disposers) {
      d();
    }
  }

  @action
  void validateName(_) {
    name = name.trim();
    error.username = null;
    if (isNull(name) || name.trim().isEmpty) {
      error.username = 'Cannot be blank';
      return;
    }
  }

  @action
  void validateEmail(_) {
    email = email.trim();
    error.email = isEmail(email) ? null : 'Not a valid email';
  }

  @action
  void validatePassword(_) {
    password = password.trim();
    error.password = null;
    if (isNull(password) || password.isEmpty) {
      error.password = 'Cannot be blank';
      return;
    }
    if (!isLength(password, 5)) {
      error.password = 'Must be at least 5 characters long';
    }
  }

  @action
  Future<bool> serverValidation(String value) async {
    bool result = true;
    try {
      usernameCheck = ObservableFuture(_serverUsernameCheck(value));
      final isValid = await usernameCheck;
      if (!isValid) {
        error.username = 'Username cannot be "admin"';
        result = false;
      }
    } on Object catch (_) {
      error.username = 'Server validation is broken';
    }
    return result;
  }

  Future<bool> _serverUsernameCheck(String value) async {
    await Future.delayed(const Duration(seconds: 1));
    return value != 'admin';
  }

  @computed
  bool get canLogin => !error.hasErrors;
}

// ignore: library_private_types_in_public_api
class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String? username;

  @observable
  String? email;

  @observable
  String? password;

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
