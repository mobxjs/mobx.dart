import 'package:dart_json_mapper/annotations.dart';
import 'package:dart_json_mapper/json_mapper.dart';
import 'package:mobx/mobx.dart';

import 'todo_json_mapper.dart';

part 'todo_json_mapper_list.g.dart';

enum VisibilityFilter { all, pending, completed }

@jsonSerializable
class TodoJsonMapperList extends _TodoJsonMapperList with _$TodoJsonMapperList{

}

@jsonSerializable
abstract class _TodoJsonMapperList with Store {
  @observable
  ObservableList<TodoJsonMapper> todos = ObservableList<TodoJsonMapper>();

  @JsonProperty(enumValues: VisibilityFilter.values)
  @observable
  VisibilityFilter filter = VisibilityFilter.all;

  @observable
  String currentDescription = '';

  @computed
  ObservableList<TodoJsonMapper> get pendingTodos =>
      ObservableList.of(todos.where((todo) => todo.done != true));

  @computed
  ObservableList<TodoJsonMapper> get completedTodos =>
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
  ObservableList<TodoJsonMapper> get visibleTodos {
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
    final todo = TodoJsonMapper(description);
    todos.add(todo);
    currentDescription = '';

    // Just a quick test of the JSON encode/decode
    final list = JsonMapper.serialize(this);
    print(list);
    print(JsonMapper.deserialize<TodoJsonMapperList>(list));
  }

  @action
  void removeTodo(TodoJsonMapper todo) {
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
