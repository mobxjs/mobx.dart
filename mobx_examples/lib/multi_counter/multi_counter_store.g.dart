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
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$_SingleCounterActionController =
      ActionController(name: '_SingleCounter');

  @override
  void reset() {
    final _$reportInfo =
        _$_SingleCounterActionController.reportStart('_SingleCounter.reset');
    final _$actionInfo = _$_SingleCounterActionController.startAction();
    try {
      return super.reset();
    } finally {
      _$_SingleCounterActionController.endAction(_$actionInfo);
      _$_SingleCounterActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  void increment() {
    final _$reportInfo = _$_SingleCounterActionController
        .reportStart('_SingleCounter.increment');
    final _$actionInfo = _$_SingleCounterActionController.startAction();
    try {
      return super.increment();
    } finally {
      _$_SingleCounterActionController.endAction(_$actionInfo);
      _$_SingleCounterActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  void decrement() {
    final _$reportInfo = _$_SingleCounterActionController
        .reportStart('_SingleCounter.decrement');
    final _$actionInfo = _$_SingleCounterActionController.startAction();
    try {
      return super.decrement();
    } finally {
      _$_SingleCounterActionController.endAction(_$actionInfo);
      _$_SingleCounterActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  String toString() {
    final string = 'value: ${value.toString()}';
    return '{$string}';
  }
}

mixin _$MultiCounterStore on _MultiCounterStore, Store {
  final _$_MultiCounterStoreActionController =
      ActionController(name: '_MultiCounterStore');

  @override
  void addCounter() {
    final _$reportInfo = _$_MultiCounterStoreActionController
        .reportStart('_MultiCounterStore.addCounter');
    final _$actionInfo = _$_MultiCounterStoreActionController.startAction();
    try {
      return super.addCounter();
    } finally {
      _$_MultiCounterStoreActionController.endAction(_$actionInfo);
      _$_MultiCounterStoreActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  void removeCounter(int index) {
    final _$reportInfo = _$_MultiCounterStoreActionController
        .reportStart('_MultiCounterStore.removeCounter');
    final _$actionInfo = _$_MultiCounterStoreActionController.startAction();
    try {
      return super.removeCounter(index);
    } finally {
      _$_MultiCounterStoreActionController.endAction(_$actionInfo);
      _$_MultiCounterStoreActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  String toString() {
    final string = '';
    return '{$string}';
  }
}
