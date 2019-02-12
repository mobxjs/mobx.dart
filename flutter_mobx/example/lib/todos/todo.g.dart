// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$Todo on _Todo, Store {
  final _$descriptionAtom = Atom(name: '_Todo.description');

  @override
  String get description {
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$descriptionAtom);
    super.description = value;
    _$descriptionAtom.reportChanged();
  }

  final _$doneAtom = Atom(name: '_Todo.done');

  @override
  bool get done {
    _$doneAtom.reportObserved();
    return super.done;
  }

  @override
  set done(bool value) {
    mainContext.checkIfStateModificationsAreAllowed(_$doneAtom);
    super.done = value;
    _$doneAtom.reportChanged();
  }

  final _$_TodoActionController = ActionController(name: '_Todo');

  @override
  void markDone({bool value}) {
    final _$actionInfo = _$_TodoActionController.startAction();
    try {
      return super.markDone(value: value);
    } finally {
      _$_TodoActionController.endAction(_$actionInfo);
    }
  }
}
