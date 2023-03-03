import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:validators2/validators2.dart';

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
  ObservableFuture<bool> usernameCheck = ObservableFuture.value(true);

  @computed
  bool get isUserCheckPending => usernameCheck.status == FutureStatus.pending;

  @computed
  bool get canLogin => !error.hasErrors;

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => name, validateUsername),
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword)
    ];
  }

  @action
  Future validateUsername(String value) async {
    if (isNull(value) || value.isEmpty) {
      error.username = 'Cannot be blank';
      return;
    }

    try {
      usernameCheck = ObservableFuture(checkValidUsername(value));

      error.username = null;

      final isValid = await usernameCheck;
      if (!isValid) {
        error.username = 'Username cannot be "admin"';
        return;
      }
    } on Object catch (_) {
      error.username = null;
    }

    error.username = null;
  }

  @action
  void validatePassword(String value) {
    error.password = isNull(value) || value.isEmpty ? 'Cannot be blank' : null;
  }

  @action
  void validateEmail(String value) {
    error.email = isEmail(value) ? null : 'Not a valid email';
  }

  Future<bool> checkValidUsername(String value) async {
    await Future.delayed(const Duration(seconds: 1));

    return value != 'admin';
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validatePassword(password);
    validateEmail(email);
    validateUsername(name);
  }
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
