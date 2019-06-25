// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$Todo on TodoBase, Store {
  final _$descriptionAtom = Atom(name: 'TodoBase.description');

  @override
  String get description {
    _$descriptionAtom.context.enforceReadPolicy(_$descriptionAtom);
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$descriptionAtom.context.conditionallyRunInAction(() {
      super.description = value;
      _$descriptionAtom.reportChanged();
    }, name: '${_$descriptionAtom.name}_set');
  }

  final _$doneAtom = Atom(name: 'TodoBase.done');

  @override
  bool get done {
    _$doneAtom.context.enforceReadPolicy(_$doneAtom);
    _$doneAtom.reportObserved();
    return super.done;
  }

  @override
  set done(bool value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$doneAtom.context.conditionallyRunInAction(() {
      super.done = value;
      _$doneAtom.reportChanged();
    }, name: '${_$doneAtom.name}_set');
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

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
    _$todosAtom.context.enforceReadPolicy(_$todosAtom);
    _$todosAtom.reportObserved();
    return super.todos;
  }

  @override
  set todos(ObservableList<Todo> value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$todosAtom.context.conditionallyRunInAction(() {
      super.todos = value;
      _$todosAtom.reportChanged();
    }, name: '${_$todosAtom.name}_set');
  }

  final _$filterAtom = Atom(name: 'TodoListBase.filter');

  @override
  VisibilityFilter get filter {
    _$filterAtom.context.enforceReadPolicy(_$filterAtom);
    _$filterAtom.reportObserved();
    return super.filter;
  }

  @override
  set filter(VisibilityFilter value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$filterAtom.context.conditionallyRunInAction(() {
      super.filter = value;
      _$filterAtom.reportChanged();
    }, name: '${_$filterAtom.name}_set');
  }

  final _$currentDescriptionAtom =
      Atom(name: 'TodoListBase.currentDescription');

  @override
  String get currentDescription {
    _$currentDescriptionAtom.context
        .enforceReadPolicy(_$currentDescriptionAtom);
    _$currentDescriptionAtom.reportObserved();
    return super.currentDescription;
  }

  @override
  set currentDescription(String value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    _$currentDescriptionAtom.context.conditionallyRunInAction(() {
      super.currentDescription = value;
      _$currentDescriptionAtom.reportChanged();
    }, name: '${_$currentDescriptionAtom.name}_set');
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
