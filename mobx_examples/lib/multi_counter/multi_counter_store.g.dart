// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_counter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SingleCounter on _SingleCounter, Store {
  final _$valueAtom = Atom(name: '_SingleCounter.value');

  @override
  int get value {
    _$valueAtom.context.enforceReadPolicy(_$valueAtom);
    _$valueAtom.reportObserved();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.context.conditionallyRunInAction(() {
      super.value = value;
      _$valueAtom.reportChanged();
    }, _$valueAtom, name: '${_$valueAtom.name}_set');
  }

  final _$_SingleCounterActionController =
      ActionController(name: '_SingleCounter');

  @override
  void reset() {
    final _$actionInfo = _$_SingleCounterActionController.startAction();
    try {
      return super.reset();
    } finally {
      _$_SingleCounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_SingleCounterActionController.startAction();
    try {
      return super.increment();
    } finally {
      _$_SingleCounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement() {
    final _$actionInfo = _$_SingleCounterActionController.startAction();
    try {
      return super.decrement();
    } finally {
      _$_SingleCounterActionController.endAction(_$actionInfo);
    }
  }
}

mixin _$MultiCounterStore on _MultiCounterStore, Store {
  final _$_MultiCounterStoreActionController =
      ActionController(name: '_MultiCounterStore');

  @override
  void addCounter() {
    final _$actionInfo = _$_MultiCounterStoreActionController.startAction();
    try {
      return super.addCounter();
    } finally {
      _$_MultiCounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCounter(int index) {
    final _$actionInfo = _$_MultiCounterStoreActionController.startAction();
    try {
      return super.removeCounter(index);
    } finally {
      _$_MultiCounterStoreActionController.endAction(_$actionInfo);
    }
  }
}
