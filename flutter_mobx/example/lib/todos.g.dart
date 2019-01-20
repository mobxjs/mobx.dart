// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// ObservableGenerator
// **************************************************************************

class _$Todo extends Todo {
  _$Todo() : super._() {}

  final _$descriptionAtom = Atom(name: 'Todo.description');

  @override
  String get description {
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    super.description = value;
    _$descriptionAtom.reportChanged();
  }

  final _$doneAtom = Atom(name: 'Todo.done');

  @override
  bool get done {
    _$doneAtom.reportObserved();
    return super.done;
  }

  @override
  set done(bool value) {
    super.done = value;
    _$doneAtom.reportChanged();
  }
}
