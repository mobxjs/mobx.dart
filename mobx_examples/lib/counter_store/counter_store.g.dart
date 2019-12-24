// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CounterStore on _CounterStore, Store {
  final _$_textAtom = Atom(name: '_CounterStore._text');

  @override
  String get _text {
    _$_textAtom.context.enforceReadPolicy(_$_textAtom);
    _$_textAtom.reportObserved();
    return super._text;
  }

  @override
  set _text(String value) {
    _$_textAtom.context.conditionallyRunInAction(() {
      super._text = value;
      _$_textAtom.reportChanged();
    }, _$_textAtom, name: '${_$_textAtom.name}_set');
  }

  final _$_counterAtom = Atom(name: '_CounterStore._counter');

  @override
  int get _counter {
    _$_counterAtom.context.enforceReadPolicy(_$_counterAtom);
    _$_counterAtom.reportObserved();
    return super._counter;
  }

  @override
  set _counter(int value) {
    _$_counterAtom.context.conditionallyRunInAction(() {
      super._counter = value;
      _$_counterAtom.reportChanged();
    }, _$_counterAtom, name: '${_$_counterAtom.name}_set');
  }

  final _$successAsyncCallAsyncAction = AsyncAction('successAsyncCall');

  @override
  Future successAsyncCall() {
    return _$successAsyncCallAsyncAction.run(() => super.successAsyncCall());
  }

  final _$errorAsyncCallAsyncAction = AsyncAction('errorAsyncCall');

  @override
  Future errorAsyncCall() {
    return _$errorAsyncCallAsyncAction.run(() => super.errorAsyncCall());
  }

  final _$_CounterStoreActionController =
      ActionController(name: '_CounterStore');

  @override
  void increament() {
    final _$actionInfo = _$_CounterStoreActionController.startAction();
    try {
      return super.increament();
    } finally {
      _$_CounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decreament() {
    final _$actionInfo = _$_CounterStoreActionController.startAction();
    try {
      return super.decreament();
    } finally {
      _$_CounterStoreActionController.endAction(_$actionInfo);
    }
  }
}
