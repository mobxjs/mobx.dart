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

//  @action removeTodo(){}
//  @action changeDescription(){}
//  @action changeFilter(){}
//  @action removeCompleted(){}
//  @action markAllAsCompleted(){}

}
