// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_counter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SingleCounter on InternalSingleCounter, Store {
  late final _$valueAtom = Atom(
    name: 'InternalSingleCounter.value',
    context: context,
  );

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

  late final _$InternalSingleCounterActionController = ActionController(
    name: 'InternalSingleCounter',
    context: context,
  );

  @override
  void reset() {
    final _$actionInfo = _$InternalSingleCounterActionController.startAction(
      name: 'InternalSingleCounter.reset',
    );
    try {
      return super.reset();
    } finally {
      _$InternalSingleCounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$InternalSingleCounterActionController.startAction(
      name: 'InternalSingleCounter.increment',
    );
    try {
      return super.increment();
    } finally {
      _$InternalSingleCounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement() {
    final _$actionInfo = _$InternalSingleCounterActionController.startAction(
      name: 'InternalSingleCounter.decrement',
    );
    try {
      return super.decrement();
    } finally {
      _$InternalSingleCounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}

mixin _$MultiCounterStore on InternalMultiCounterStore, Store {
  late final _$InternalMultiCounterStoreActionController = ActionController(
    name: 'InternalMultiCounterStore',
    context: context,
  );

  @override
  void addCounter() {
    final _$actionInfo = _$InternalMultiCounterStoreActionController
        .startAction(name: 'InternalMultiCounterStore.addCounter');
    try {
      return super.addCounter();
    } finally {
      _$InternalMultiCounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCounter(int index) {
    final _$actionInfo = _$InternalMultiCounterStoreActionController
        .startAction(name: 'InternalMultiCounterStore.removeCounter');
    try {
      return super.removeCounter(index);
    } finally {
      _$InternalMultiCounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
