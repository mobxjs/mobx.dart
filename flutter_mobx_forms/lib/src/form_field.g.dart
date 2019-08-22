// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_field.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FormField<T> on _FormField<T>, Store {
  Computed<bool> _$isValidatingComputed;

  @override
  bool get isValidating =>
      (_$isValidatingComputed ??= Computed<bool>(() => super.isValidating))
          .value;
  Computed<String> _$errorComputed;

  @override
  String get error =>
      (_$errorComputed ??= Computed<String>(() => super.error)).value;
  Computed<bool> _$isValidComputed;

  @override
  bool get isValid =>
      (_$isValidComputed ??= Computed<bool>(() => super.isValid)).value;

  final _$_errorsAtom = Atom(name: '_FormField._errors');

  @override
  List<String> get _errors {
    _$_errorsAtom.context.enforceReadPolicy(_$_errorsAtom);
    _$_errorsAtom.reportObserved();
    return super._errors;
  }

  @override
  set _errors(List<String> value) {
    _$_errorsAtom.context.conditionallyRunInAction(() {
      super._errors = value;
      _$_errorsAtom.reportChanged();
    }, _$_errorsAtom, name: '${_$_errorsAtom.name}_set');
  }

  final _$valueAtom = Atom(name: '_FormField.value');

  @override
  T get value {
    _$valueAtom.context.enforceReadPolicy(_$valueAtom);
    _$valueAtom.reportObserved();
    return super.value;
  }

  @override
  set value(T value) {
    _$valueAtom.context.conditionallyRunInAction(() {
      super.value = value;
      _$valueAtom.reportChanged();
    }, _$valueAtom, name: '${_$valueAtom.name}_set');
  }

  final _$_isValidatingAtom = Atom(name: '_FormField._isValidating');

  @override
  bool get _isValidating {
    _$_isValidatingAtom.context.enforceReadPolicy(_$_isValidatingAtom);
    _$_isValidatingAtom.reportObserved();
    return super._isValidating;
  }

  @override
  set _isValidating(bool value) {
    _$_isValidatingAtom.context.conditionallyRunInAction(() {
      super._isValidating = value;
      _$_isValidatingAtom.reportChanged();
    }, _$_isValidatingAtom, name: '${_$_isValidatingAtom.name}_set');
  }

  final _$_asyncValidateAsyncAction = AsyncAction('_asyncValidate');

  @override
  Future<void> _asyncValidate() {
    return _$_asyncValidateAsyncAction.run(() => super._asyncValidate());
  }

  final _$_FormFieldActionController = ActionController(name: '_FormField');

  @override
  void _syncValidate() {
    final _$actionInfo = _$_FormFieldActionController.startAction();
    try {
      return super._syncValidate();
    } finally {
      _$_FormFieldActionController.endAction(_$actionInfo);
    }
  }
}
