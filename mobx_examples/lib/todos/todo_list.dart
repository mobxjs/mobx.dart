import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

import 'todo.dart';

part 'todo_list.g.dart';

enum VisibilityFilter { all, pending, completed }

@JsonSerializable()
class TodoList = _TodoList with _$TodoList;

abstract class _TodoList with Store {
  @observable
  @_ObservableListJsonConverter()
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  VisibilityFilter filter = VisibilityFilter.all;

  @observable
  String currentDescription = '';

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
    currentDescription = '';

    // Just a quick test of the JSON encode/decode
    final list = _$TodoListToJson(this);
    print(list);
    print(_$TodoListFromJson(list));
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

class _ObservableListJsonConverter
    implements JsonConverter<ObservableList<Todo>, List<Map<String, dynamic>>> {
  const _ObservableListJsonConverter();

  @override
  ObservableList<Todo> fromJson(List<Map<String, dynamic>> json) =>
      ObservableList.of(json.map(Todo.fromJson));

  @override
  List<Map<String, dynamic>> toJson(ObservableList<Todo> list) =>
      list.map(Todo.toJson).toList();
}
