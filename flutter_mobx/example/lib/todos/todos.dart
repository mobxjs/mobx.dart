import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'todos.g.dart';

class Todo = TodoBase with _$Todo;

abstract class TodoBase implements Store {
  TodoBase(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}

enum VisibilityFilter { all, pending, completed }

class TodoList = TodoListBase with _$TodoList;

abstract class TodoListBase implements Store {
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  VisibilityFilter filter = VisibilityFilter.all;

  @computed
  ObservableList<Todo> get pendingTodos =>
      todos.where((todo) => todo.done != true);

  @computed
  ObservableList<Todo> get completedTodos =>
      todos.where((todo) => todo.done == true);

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

  @observable
  String currentDescription = '';

  @action
  void addTodo(String description) {
    final todo = Todo(description);
    todos.add(todo);
  }

  @action
  void removeTodo(Todo todo) {
    todos.removeWhere((x) => x == todo);
  }

  // ignore: use_setters_to_change_properties
  @action
  void changeDescription(String description) =>
      currentDescription = description;

  // ignore: use_setters_to_change_properties
  @action
  void changeFilter(VisibilityFilter filter) => this.filter = filter;

  @action
  void removeCompleted() {
    todos.removeWhere((todo) => todo.done);
  }

  @action
  void markAllAsCompleted() {
    // ignore: avoid_function_literals_in_foreach_calls
    todos.forEach((todo) => todo.done = true);
  }
}

class TodoExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoExampleState();
}

class _TodoExampleState extends State<TodoExample> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
