import 'package:mobx/mobx.dart';

part 'form_field.g.dart';

typedef SyncFieldValidator<T> = Iterable<String> Function(T value);
typedef AsyncFieldValidator<T> = Stream<String> Function(T value);

enum ValidationPolicy { onChange, always, manual }

class FormField<T> = _FormField<T> with _$FormField;

abstract class _FormField<T> with Store {
  _FormField(
      {this.name,
      this.label,
      this.value,
      this.validator,
      this.asyncValidator,
      this.validationPolicy = ValidationPolicy.manual})
      : assert(validator != null && asyncValidator != null,
            'Only one of validator or asyncValidator can be specified') {
    _setupValidation();
  }

  ValidationPolicy validationPolicy;

  final String name;

  final String label;

  @observable
  List<String> errors;

  @observable
  T value;

  @observable
  bool _isValidating;

  @computed
  bool get isValidating => _isValidating;

  @computed
  String get error =>
      errors == null ? null : (errors.isEmpty ? null : errors[0]);

  @computed
  bool get isValid => errors == null;

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

  @action
  void _syncValidate() {
    try {
      _isValidating = false;

      final errors = validator(value);
      this.errors = errors == null ? null : errors.toList(growable: false);
    } finally {
      _isValidating = false;
    }
  }

  @action
  // ignore: avoid_void_async
  Future<void> _asyncValidate() async {
    try {
      _isValidating = false;

      final errors = await asyncValidator(value).toList();
      this.errors = errors;
    } finally {
      _isValidating = false;
    }
  }

  void _setupValidation() {}
}
