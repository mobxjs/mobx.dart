// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// ObservableGenerator
// **************************************************************************

class _$Counter extends Counter {
  _$Counter() : super._() {}

  final _$valueAtom = Atom(name: 'Counter.value');

  @override
  int get value {
    _$valueAtom.reportObserved();
    return super.value;
  }

  @override
  set value(int value) {
    super.value = value;
    _$valueAtom.reportChanged();
  }

  final _$CounterActionController = ActionController(name: 'Counter');

  @override
  void increment() {
    final _$prevDerivation = _$CounterActionController.startAction();
    try {
      return super.increment();
    } finally {
      _$CounterActionController.endAction(_$prevDerivation);
    }
  }
}
