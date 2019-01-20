import 'package:mobx/mobx.dart';
part 'todos.g.dart';

@observable
class Todo {
  Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}

enum VisibilityFilter { all, pending, completed }

class TodoList {
  TodoList() {
    _visibleTodos = Computed(() {
      switch (filter) {
        case VisibilityFilter.pending:
          return pendingTodos;
        case VisibilityFilter.completed:
          return completedTodos;
        default:
          return todos;
      }
    });

    _pendingTodos = Computed(() => todos.where((todo) => todo.done != true));
    _completedTodos = Computed(() => todos.where((todo) => todo.done == true));

    addTodo = Action(_addTodo);
  }

  //region Private Fields
  final _todos = ObservableList<Todo>();
  final _filter = Observable<VisibilityFilter>(VisibilityFilter.all);
  final _currentDescription = Observable<String>('');

  Computed<ObservableList<Todo>> _visibleTodos;
  Computed<ObservableList<Todo>> _pendingTodos;
  Computed<ObservableList<Todo>> _completedTodos;
  //endregion

  ObservableList<Todo> get todos => _todos;
  VisibilityFilter get filter => _filter.value;

  set filter(VisibilityFilter value) => _filter.value = value;
  String get currentDescription => _currentDescription.value;

  set currentDescription(String value) => _currentDescription.value = value;

  ObservableList<Todo> get visibleTodos => _visibleTodos.value;
  ObservableList<Todo> get pendingTodos => _pendingTodos.value;
  ObservableList<Todo> get completedTodos => _completedTodos.value;

  Action addTodo;
  Action removeTodo;
  Action changeDescription;
  Action changeFilter;
  Action removeCompleted;
  Action markAllAsCompleted;

  void _addTodo(String description) {
    final todo = Todo(description);
    todos.add(todo);
  }
}
