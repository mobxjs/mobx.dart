// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$Todo on TodoBase, Store {
  final _$descriptionAtom = Atom(name: 'TodoBase.description');

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

  final _$doneAtom = Atom(name: 'TodoBase.done');

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

mixin _$TodoList on TodoListBase, Store {
  Computed<ObservableList> _$pendingTodosComputed;

  @override
  ObservableList get pendingTodos => (_$pendingTodosComputed ??=
          Computed<ObservableList>(() => super.pendingTodos))
      .value;
  Computed<ObservableList> _$completedTodosComputed;

  @override
  ObservableList get completedTodos => (_$completedTodosComputed ??=
          Computed<ObservableList>(() => super.completedTodos))
      .value;
  Computed<ObservableList> _$visibleTodosComputed;

  @override
  ObservableList get visibleTodos => (_$visibleTodosComputed ??=
          Computed<ObservableList>(() => super.visibleTodos))
      .value;

  final _$filterAtom = Atom(name: 'TodoListBase.filter');

  @override
  VisibilityFilter get filter {
    _$filterAtom.reportObserved();
    return super.filter;
  }

  @override
  set filter(VisibilityFilter value) {
    super.filter = value;
    _$filterAtom.reportChanged();
  }

  final _$currentDescriptionAtom =
      Atom(name: 'TodoListBase.currentDescription');

  @override
  String get currentDescription {
    _$currentDescriptionAtom.reportObserved();
    return super.currentDescription;
  }

  @override
  set currentDescription(String value) {
    super.currentDescription = value;
    _$currentDescriptionAtom.reportChanged();
  }

  final _$TodoListBaseActionController = ActionController(name: 'TodoListBase');

  @override
  void addTodo(String description) {
    final _$prevDerivation = _$TodoListBaseActionController.startAction();
    try {
      return super.addTodo(description);
    } finally {
      _$TodoListBaseActionController.endAction(_$prevDerivation);
    }
  }
}
