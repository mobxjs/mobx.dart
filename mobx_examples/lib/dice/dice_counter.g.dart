// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice_counter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DiceCounter on _DiceCounter, Store {
  Computed<int> _$totalComputed;

  @override
  int get total => (_$totalComputed ??= Computed<int>(() => super.total)).value;

  final _$leftAtom = Atom(name: '_DiceCounter.left');

  @override
  int get left {
    _$leftAtom.context.enforceReadPolicy(_$leftAtom);
    _$leftAtom.reportObserved();
    return super.left;
  }

  @override
  set left(int value) {
    _$leftAtom.context.conditionallyRunInAction(() {
      super.left = value;
      _$leftAtom.reportChanged();
    }, _$leftAtom, name: '${_$leftAtom.name}_set');
  }

  final _$rightAtom = Atom(name: '_DiceCounter.right');

  @override
  int get right {
    _$rightAtom.context.enforceReadPolicy(_$rightAtom);
    _$rightAtom.reportObserved();
    return super.right;
  }

  @override
  set right(int value) {
    _$rightAtom.context.conditionallyRunInAction(() {
      super.right = value;
      _$rightAtom.reportChanged();
    }, _$rightAtom, name: '${_$rightAtom.name}_set');
  }

  final _$_DiceCounterActionController = ActionController(name: '_DiceCounter');

  @override
  void roll() {
    final _$actionInfo = _$_DiceCounterActionController.startAction();
    try {
      return super.roll();
    } finally {
      _$_DiceCounterActionController.endAction(_$actionInfo);
    }
  }
}
