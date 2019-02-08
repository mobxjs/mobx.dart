// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$Counter on CounterBase, Store {
  final _$valueAtom = Atom(name: 'CounterBase.value');

  @override
  int get value {
    _$valueAtom.reportObserved();
    return super.value;
  }

  @override
  set value(int value) {
    mainContext.checkIfStateModificationsAreAllowed(_$valueAtom);
    super.value = value;
    _$valueAtom.reportChanged();
  }

  final _$CounterBaseActionController = ActionController(name: 'CounterBase');

  @override
  void increment() {
    final _$actionInfo = _$CounterBaseActionController.startAction();
    try {
      return super.increment();
    } finally {
      _$CounterBaseActionController.endAction(_$actionInfo);
    }
  }
}
