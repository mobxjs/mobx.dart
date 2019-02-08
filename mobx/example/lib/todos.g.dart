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
    mainContext.checkIfStateModificationsAreAllowed(_$descriptionAtom);
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
    mainContext.checkIfStateModificationsAreAllowed(_$doneAtom);
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
  Computed<bool> _$hasCompletedTodosComputed;

  @override
  bool get hasCompletedTodos => (_$hasCompletedTodosComputed ??=
          Computed<bool>(() => super.hasCompletedTodos))
      .value;
  Computed<bool> _$hasPendingTodosComputed;

  @override
  bool get hasPendingTodos => (_$hasPendingTodosComputed ??=
          Computed<bool>(() => super.hasPendingTodos))
      .value;
  Computed<String> _$itemsDescriptionComputed;

  @override
  String get itemsDescription => (_$itemsDescriptionComputed ??=
          Computed<String>(() => super.itemsDescription))
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
    mainContext.checkIfStateModificationsAreAllowed(_$todosAtom);
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
    mainContext.checkIfStateModificationsAreAllowed(_$filterAtom);
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
    mainContext.checkIfStateModificationsAreAllowed(_$currentDescriptionAtom);
    super.currentDescription = value;
    _$currentDescriptionAtom.reportChanged();
  }

  final _$TodoListBaseActionController = ActionController(name: 'TodoListBase');

  @override
  void addTodo(String description) {
    final _$actionInfo = _$TodoListBaseActionController.startAction();
    try {
      return super.addTodo(description);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTodo(Todo todo) {
    final _$actionInfo = _$TodoListBaseActionController.startAction();
    try {
      return super.removeTodo(todo);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDescription(String description) {
    final _$actionInfo = _$TodoListBaseActionController.startAction();
    try {
      return super.changeDescription(description);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeFilter(VisibilityFilter filter) {
    final _$actionInfo = _$TodoListBaseActionController.startAction();
    try {
      return super.changeFilter(filter);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCompleted() {
    final _$actionInfo = _$TodoListBaseActionController.startAction();
    try {
      return super.removeCompleted();
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllAsCompleted() {
    final _$actionInfo = _$TodoListBaseActionController.startAction();
    try {
      return super.markAllAsCompleted();
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }
}
