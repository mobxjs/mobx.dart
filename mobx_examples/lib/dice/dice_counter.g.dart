// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice_counter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DiceCounter on _DiceCounter, Store {
  Computed<int> _$totalComputed;

  @override
  int get total => (_$totalComputed ??=
          Computed<int>(() => super.total, name: '_DiceCounter.total'))
      .value;

  final _$leftAtom = Atom(name: '_DiceCounter.left');

  @override
  int get left {
    _$leftAtom.reportRead();
    return super.left;
  }

  @override
  set left(int value) {
    _$leftAtom.reportWrite(value, super.left, () {
      super.left = value;
    });
  }

  final _$rightAtom = Atom(name: '_DiceCounter.right');

  @override
  int get right {
    _$rightAtom.reportRead();
    return super.right;
  }

  @override
  set right(int value) {
    _$rightAtom.reportWrite(value, super.right, () {
      super.right = value;
    });
  }

  final _$_DiceCounterActionController = ActionController(name: '_DiceCounter');

  @override
  void roll() {
    final _$actionInfo =
        _$_DiceCounterActionController.startAction(name: '_DiceCounter.roll');
    try {
      return super.roll();
    } finally {
      _$_DiceCounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
left: ${left},
right: ${right},
total: ${total}
    ''';
  }
}
