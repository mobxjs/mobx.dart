// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FieldState<T> on _FieldState<T>, Store {
  Computed<bool> _$isValidatingComputed;

  @override
  bool get isValidating =>
      (_$isValidatingComputed ??= Computed<bool>(() => super.isValidating))
          .value;
  Computed<bool> _$isValidComputed;

  @override
  bool get isValid =>
      (_$isValidComputed ??= Computed<bool>(() => super.isValid)).value;

  final _$valueAtom = Atom(name: '_FieldState.value');

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

  final _$_isValidatingAtom = Atom(name: '_FieldState._isValidating');

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

  final _$_FieldStateActionController = ActionController(name: '_FieldState');

  @override
  void _syncValidate() {
    final _$actionInfo = _$_FieldStateActionController.startAction();
    try {
      return super._syncValidate();
    } finally {
      _$_FieldStateActionController.endAction(_$actionInfo);
    }
  }
}
