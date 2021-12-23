import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/todos/observable_todo_list_converter.dart';

import 'todo.dart';

part 'todo_list.g.dart';

enum VisibilityFilter { all, pending, completed }

@JsonSerializable()
class TodoList extends _TodoList with _$TodoList {
  TodoList();

  factory TodoList.fromJson(Map<String, dynamic> json) =>
      _$TodoListFromJson(json);

  Map<String, dynamic> toJson() => _$TodoListToJson(this);
}

abstract class _TodoList with Store {
  @observable
  @ObservableTodoListConverter()
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  @JsonKey(defaultValue: VisibilityFilter.all)
  VisibilityFilter filter = VisibilityFilter.all;

  @computed
  ObservableList<Todo> get pendingTodos =>
      ObservableList.of(todos.where((todo) => todo.done != true));

  @computed
  ObservableList<Todo> get completedTodos =>
      ObservableList.of(todos.where((todo) => todo.done == true));

  @computed
  bool get hasCompletedTodos => completedTodos.isNotEmpty;

  @computed
  bool get hasPendingTodos => pendingTodos.isNotEmpty;

  @computed
  String get itemsDescription {
    if (todos.isEmpty) {
      return "There are no Todos here. Why don't you add one?.";
    }

    final suffix = pendingTodos.length == 1 ? 'todo' : 'todos';
    return '${pendingTodos.length} pending $suffix, ${completedTodos.length} completed';
  }

  @computed
  @JsonKey(ignore: true)
  ObservableList<Todo> get visibleTodos {
    switch (filter) {
      case VisibilityFilter.pending:
        return pendingTodos;
      case VisibilityFilter.completed:
        return completedTodos;
      default:
        return todos;
    }
  }

  @computed
  bool get canRemoveAllCompleted =>
      hasCompletedTodos && filter != VisibilityFilter.pending;

  @computed
  bool get canMarkAllCompleted =>
      hasPendingTodos && filter != VisibilityFilter.completed;

  @action
  void addTodo(String description) {
    final todo = Todo(description);
    todos.add(todo);
  }

  @action
  void removeTodo(Todo todo) {
    todos.removeWhere((x) => x == todo);
  }

  @action
  void removeCompleted() {
    todos.removeWhere((todo) => todo.done);
  }

  @action
  void markAllAsCompleted() {
    for (final todo in todos) {
      todo.done = true;
    }
  }
}
