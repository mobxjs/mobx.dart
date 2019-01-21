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
  Computed<ObservableList<Todo>> _$pendingTodosComputed;

  @override
  ObservableList<Todo> get pendingTodos => (_$pendingTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.pendingTodos))
      .value;
  Computed<ObservableList<Todo>> _$completedTodosComputed;

  @override
  ObservableList<Todo> get completedTodos => (_$completedTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.completedTodos))
      .value;
  Computed<ObservableList<Todo>> _$visibleTodosComputed;

  @override
  ObservableList<Todo> get visibleTodos => (_$visibleTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.visibleTodos))
      .value;

  final _$todosAtom = Atom(name: 'TodoListBase.todos');

  @override
  ObservableList<Todo> get todos {
    _$todosAtom.reportObserved();
    return super.todos;
  }

  @override
  set todos(ObservableList<Todo> value) {
    super.todos = value;
    _$todosAtom.reportChanged();
  }

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
