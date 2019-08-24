import 'package:flutter_mobx_forms/src/error_context.dart';
import 'package:mobx/mobx.dart';

part 'field_state.g.dart';

typedef SyncFieldValidator<T> = void Function(T value, ErrorContext errors);
typedef AsyncFieldValidator<T> = Future<void> Function(
    T value, ErrorContext errors);

enum ValidationPolicy { onChange, always, manual }

class FieldState<T> = _FieldState<T> with _$FieldState<T>;

abstract class _FieldState<T> with Store {
  _FieldState(
      {this.name,
      this.label,
      this.value,
      this.validator,
      this.asyncValidator,
      this.validationPolicy = ValidationPolicy.manual})
      : assert(validator == null || asyncValidator == null,
            'Only one of validator or asyncValidator can be specified') {
    _setupValidation();
  }

  ReactionDisposer _disposer;

  final ValidationPolicy validationPolicy;

  final String name;

  final String label;

  @observable
  T value;

  @observable
  bool _isValidating;

  final ErrorContext errorContext = ErrorContext();

  @computed
  bool get isValidating => _isValidating;

  @computed
  bool get isValid => errorContext.isEmpty;

  final SyncFieldValidator<T> validator;
  final AsyncFieldValidator<T> asyncValidator;

  void validate() {
    assert(!_isValidating);

    if (validator != null) {
      _syncValidate();
      return;
    }

    if (asyncValidator != null) {
      _asyncValidate();
    }
  }

  @override
  void dispose() {
    if (_disposer != null) {
      _disposer();
    }
  }

  @action
  void _syncValidate() {
    try {
      _isValidating = true;

      validator(value, errorContext);
    } finally {
      _isValidating = false;
    }
  }

  @action
  // ignore: avoid_void_async
  Future<void> _asyncValidate() async {
    try {
      _isValidating = true;

      await asyncValidator(value, errorContext);
    } finally {
      _isValidating = false;
    }
  }

  void _setupValidation() {
    switch (validationPolicy) {
      case ValidationPolicy.manual:
        break;
      case ValidationPolicy.always:
        _disposer = autorun((_) {
          validate();
        });
        break;
      case ValidationPolicy.onChange:
        _disposer = reaction((_) => value, (_) {
          validate();
        });
        break;
    }
  }
}
