// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoList _$TodoListFromJson(Map<String, dynamic> json) => TodoList()
  ..todos = const ObservableTodoListConverter()
      .fromJson(json['todos'] as Iterable<Map<String, dynamic>>)
  ..filter = $enumDecodeNullable(_$VisibilityFilterEnumMap, json['filter']) ??
      VisibilityFilter.all;

Map<String, dynamic> _$TodoListToJson(TodoList instance) => <String, dynamic>{
      'todos': const ObservableTodoListConverter().toJson(instance.todos),
      'filter': _$VisibilityFilterEnumMap[instance.filter]!,
    };

const _$VisibilityFilterEnumMap = {
  VisibilityFilter.all: 'all',
  VisibilityFilter.pending: 'pending',
  VisibilityFilter.completed: 'completed',
};

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TodoList on _TodoList, Store {
  Computed<ObservableList<Todo>>? _$pendingTodosComputed;

  @override
  ObservableList<Todo> get pendingTodos => (_$pendingTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.pendingTodos,
              name: '_TodoList.pendingTodos'))
      .value;
  Computed<ObservableList<Todo>>? _$completedTodosComputed;

  @override
  ObservableList<Todo> get completedTodos => (_$completedTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.completedTodos,
              name: '_TodoList.completedTodos'))
      .value;
  Computed<bool>? _$hasCompletedTodosComputed;

  @override
  bool get hasCompletedTodos => (_$hasCompletedTodosComputed ??= Computed<bool>(
          () => super.hasCompletedTodos,
          name: '_TodoList.hasCompletedTodos'))
      .value;
  Computed<bool>? _$hasPendingTodosComputed;

  @override
  bool get hasPendingTodos =>
      (_$hasPendingTodosComputed ??= Computed<bool>(() => super.hasPendingTodos,
              name: '_TodoList.hasPendingTodos'))
          .value;
  Computed<String>? _$itemsDescriptionComputed;

  @override
  String get itemsDescription => (_$itemsDescriptionComputed ??=
          Computed<String>(() => super.itemsDescription,
              name: '_TodoList.itemsDescription'))
      .value;
  Computed<ObservableList<Todo>>? _$visibleTodosComputed;

  @override
  ObservableList<Todo> get visibleTodos => (_$visibleTodosComputed ??=
          Computed<ObservableList<Todo>>(() => super.visibleTodos,
              name: '_TodoList.visibleTodos'))
      .value;
  Computed<bool>? _$canRemoveAllCompletedComputed;

  @override
  bool get canRemoveAllCompleted => (_$canRemoveAllCompletedComputed ??=
          Computed<bool>(() => super.canRemoveAllCompleted,
              name: '_TodoList.canRemoveAllCompleted'))
      .value;
  Computed<bool>? _$canMarkAllCompletedComputed;

  @override
  bool get canMarkAllCompleted => (_$canMarkAllCompletedComputed ??=
          Computed<bool>(() => super.canMarkAllCompleted,
              name: '_TodoList.canMarkAllCompleted'))
      .value;

  late final _$todosAtom = Atom(name: '_TodoList.todos', context: context);

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

  late final _$filterAtom = Atom(name: '_TodoList.filter', context: context);

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

  late final _$_TodoListActionController =
      ActionController(name: '_TodoList', context: context);

  @override
  void addTodo(String description) {
    final _$actionInfo =
        _$_TodoListActionController.startAction(name: '_TodoList.addTodo');
    try {
      return super.addTodo(description);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTodo(Todo todo) {
    final _$actionInfo =
        _$_TodoListActionController.startAction(name: '_TodoList.removeTodo');
    try {
      return super.removeTodo(todo);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCompleted() {
    final _$actionInfo = _$_TodoListActionController.startAction(
        name: '_TodoList.removeCompleted');
    try {
      return super.removeCompleted();
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllAsCompleted() {
    final _$actionInfo = _$_TodoListActionController.startAction(
        name: '_TodoList.markAllAsCompleted');
    try {
      return super.markAllAsCompleted();
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
todos: ${todos},
filter: ${filter},
pendingTodos: ${pendingTodos},
completedTodos: ${completedTodos},
hasCompletedTodos: ${hasCompletedTodos},
hasPendingTodos: ${hasPendingTodos},
itemsDescription: ${itemsDescription},
visibleTodos: ${visibleTodos},
canRemoveAllCompleted: ${canRemoveAllCompleted},
canMarkAllCompleted: ${canMarkAllCompleted}
    ''';
  }
}
