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

  ReactionDisposer _disposer;

  final ValidationPolicy validationPolicy;

  final String name;

  final String label;

  @observable
  List<String> _errors;

  @observable
  T value;

  @observable
  bool _isValidating;

  @computed
  bool get isValidating => _isValidating;

  @computed
  String get error => isValid ? null : _errors.first;

  @computed
  bool get isValid => _errors == null || _errors.isEmpty;

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
