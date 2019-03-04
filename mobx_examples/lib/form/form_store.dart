import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'form_store.g.dart';

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore implements Store {
  _FormStore() {
    _setupValidations();
  }

  final FormErrorState error = FormErrorState();

  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  ObservableFuture<bool> _usernameCheck = ObservableFuture.value(true);

  @computed
  bool get isUserCheckPending => _usernameCheck.status == FutureStatus.pending;

  @computed
  bool get canLogin => !error.hasErrors;

  List<ReactionDisposer> _disposers;

  @action
  void setUsername(String value) {
    name = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  void _setupValidations() {
    _disposers = [
      reaction((_) => name, validateUsername),
      reaction((_) => email, (value) => error.email = validateEmail(value)),
      reaction(
          (_) => password, (value) => error.password = validatePassword(value))
    ];
  }

  @action
  // ignore: avoid_void_async
  Future validateUsername(String value) async {
    if (isNull(value) || value.isEmpty) {
      error.username = 'Cannot be blank';
      return;
    }

    try {
      _usernameCheck = ObservableFuture(checkValidUsername(value));

      error.username = null;

      final isValid = await _usernameCheck;
      if (!isValid) {
        error.username = 'Username cannot be "admin"';
        return;
      }
    } on Object catch (_) {
      error.username = null;
    }

    error.username = null;
  }

  String validatePassword(String value) =>
      isNull(value) || value.isEmpty ? 'Cannot be blank' : null;

  String validateEmail(String value) =>
      isEmail(value) ? null : 'Not a valid email';

  Future<bool> checkValidUsername(String value) async {
    await Future.delayed(Duration(seconds: 1));

    return value != 'admin';
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState implements Store {
  @observable
  String username;

  @observable
  String email;

  @observable
  String password;

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
