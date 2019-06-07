// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$Counter on _Counter, Store {
  final _$valueAtom = Atom(name: '_Counter.value');

  @override
  int get value {
    _$valueAtom.reportObserved();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.context.checkIfStateModificationsAreAllowed(_$valueAtom);
    super.value = value;
    _$valueAtom.reportChanged();
  }

  final _$_CounterActionController = ActionController(name: '_Counter');

  @override
  void increment() {
    final _$actionInfo = _$_CounterActionController.startAction();
    try {
      return super.increment();
    } finally {
      _$_CounterActionController.endAction(_$actionInfo);
    }
  }
}
