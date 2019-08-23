import 'package:mobx/mobx.dart';

class ErrorContext {
  final ObservableSet<ConstraintError> errors = ObservableSet();

  bool get isEmpty => errors.isEmpty;

  // ignore: avoid_returning_this
  ErrorContext reset() {
    errors.clear();
    return this;
  }

  void addErrorMessage(String message) => errors.add(ConstraintError(message));

  void addError(ConstraintError error) => errors.add(error);
}

class ConstraintError extends Error {
  ConstraintError(this.message);

  final String message;
}
