// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$TodoList on _TodoList, Store {
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
  Computed<bool> _$canRemoveAllCompletedComputed;

  @override
  bool get canRemoveAllCompleted => (_$canRemoveAllCompletedComputed ??=
          Computed<bool>(() => super.canRemoveAllCompleted))
      .value;
  Computed<bool> _$canMarkAllCompletedComputed;

  @override
  bool get canMarkAllCompleted => (_$canMarkAllCompletedComputed ??=
          Computed<bool>(() => super.canMarkAllCompleted))
      .value;

  final _$todosAtom = Atom(name: '_TodoList.todos');

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

  final _$filterAtom = Atom(name: '_TodoList.filter');

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

  final _$currentDescriptionAtom = Atom(name: '_TodoList.currentDescription');

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

  final _$_TodoListActionController = ActionController(name: '_TodoList');

  @override
  void addTodo(String description) {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.addTodo(description);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTodo(Todo todo) {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.removeTodo(todo);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDescription(String description) {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.changeDescription(description);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeFilter(VisibilityFilter filter) {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.changeFilter(filter);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCompleted() {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.removeCompleted();
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllAsCompleted() {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.markAllAsCompleted();
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }
}
