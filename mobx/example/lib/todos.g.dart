// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Todo on TodoBase, Store {
  final _$descriptionAtom = Atom(name: 'TodoBase.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$doneAtom = Atom(name: 'TodoBase.done');

  @override
  bool get done {
    _$doneAtom.reportRead();
    return super.done;
  }

  @override
  set done(bool value) {
    _$doneAtom.reportWrite(value, super.done, () {
      super.done = value;
    });
  }

  @override
  String toString() {
    return '''
description: ${description},
done: ${done}
    ''';
  }
}

mixin _$TodoList on TodoListBase, Store {
  Computed<ObservableList<Todo>>? _$pendingTodosComputed;

  @override
  ObservableList<Todo> get pendingTodos => (_$pendingTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.pendingTodos,
              name: 'TodoListBase.pendingTodos'))
      .value;
  Computed<ObservableList<Todo>>? _$completedTodosComputed;

  @override
  ObservableList<Todo> get completedTodos => (_$completedTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.completedTodos,
              name: 'TodoListBase.completedTodos'))
      .value;
  Computed<bool>? _$hasCompletedTodosComputed;

  @override
  bool get hasCompletedTodos => (_$hasCompletedTodosComputed ??= Computed<bool>(
          () => super.hasCompletedTodos,
          name: 'TodoListBase.hasCompletedTodos'))
      .value;
  Computed<bool>? _$hasPendingTodosComputed;

  @override
  bool get hasPendingTodos =>
      (_$hasPendingTodosComputed ??= Computed<bool>(() => super.hasPendingTodos,
              name: 'TodoListBase.hasPendingTodos'))
          .value;
  Computed<String>? _$itemsDescriptionComputed;

  @override
  String get itemsDescription => (_$itemsDescriptionComputed ??=
          Computed<String>(() => super.itemsDescription,
              name: 'TodoListBase.itemsDescription'))
      .value;
  Computed<ObservableList<Todo>>? _$visibleTodosComputed;

  @override
  ObservableList<Todo> get visibleTodos => (_$visibleTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.visibleTodos,
              name: 'TodoListBase.visibleTodos'))
      .value;

  final _$todosAtom = Atom(name: 'TodoListBase.todos');

  @override
  ObservableList<Todo> get todos {
    _$todosAtom.reportRead();
    return super.todos;
  }

  @override
  set todos(ObservableList<Todo> value) {
    _$todosAtom.reportWrite(value, super.todos, () {
      super.todos = value;
    });
  }

  final _$filterAtom = Atom(name: 'TodoListBase.filter');

  @override
  VisibilityFilter get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(VisibilityFilter value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$currentDescriptionAtom =
      Atom(name: 'TodoListBase.currentDescription');

  @override
  String get currentDescription {
    _$currentDescriptionAtom.reportRead();
    return super.currentDescription;
  }

  @override
  set currentDescription(String value) {
    _$currentDescriptionAtom.reportWrite(value, super.currentDescription, () {
      super.currentDescription = value;
    });
  }

  final _$TodoListBaseActionController = ActionController(name: 'TodoListBase');

  @override
  void addTodo(String description) {
    final _$actionInfo = _$TodoListBaseActionController.startAction(
        name: 'TodoListBase.addTodo');
    try {
      return super.addTodo(description);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTodo(Todo todo) {
    final _$actionInfo = _$TodoListBaseActionController.startAction(
        name: 'TodoListBase.removeTodo');
    try {
      return super.removeTodo(todo);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDescription(String description) {
    final _$actionInfo = _$TodoListBaseActionController.startAction(
        name: 'TodoListBase.changeDescription');
    try {
      return super.changeDescription(description);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeFilter(VisibilityFilter filter) {
    final _$actionInfo = _$TodoListBaseActionController.startAction(
        name: 'TodoListBase.changeFilter');
    try {
      return super.changeFilter(filter);
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCompleted() {
    final _$actionInfo = _$TodoListBaseActionController.startAction(
        name: 'TodoListBase.removeCompleted');
    try {
      return super.removeCompleted();
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllAsCompleted() {
    final _$actionInfo = _$TodoListBaseActionController.startAction(
        name: 'TodoListBase.markAllAsCompleted');
    try {
      return super.markAllAsCompleted();
    } finally {
      _$TodoListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
todos: ${todos},
filter: ${filter},
currentDescription: ${currentDescription},
pendingTodos: ${pendingTodos},
completedTodos: ${completedTodos},
hasCompletedTodos: ${hasCompletedTodos},
hasPendingTodos: ${hasPendingTodos},
itemsDescription: ${itemsDescription},
visibleTodos: ${visibleTodos}
    ''';
  }
}
