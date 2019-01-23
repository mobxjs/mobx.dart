import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
      ObservableList.of(todos.where((todo) => todo.done != true));

  @computed
  ObservableList<Todo> get completedTodos =>
      ObservableList.of(todos.where((todo) => todo.done == true));

  @computed
  bool get hasCompletedTodos => completedTodos.isNotEmpty;

  @computed
  bool get hasPendingTodos => pendingTodos.isNotEmpty;

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
    currentDescription = '';
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
  const TodoExample();

  @override
  State<StatefulWidget> createState() => _TodoExampleState();
}

class _TodoExampleState extends State<TodoExample> {
  final _list = TodoList();

  final _textController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Observer(
            builder: (_) => TextField(
                  autofocus: true,
                  controller: _textController,
                  onChanged: _onTextChanged,
                  onSubmitted: _onTextSubmitted,
                ),
          ),
          Observer(
              builder: (_) => ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        child: const Text('Remove Completed'),
                        onPressed: _list.hasCompletedTodos
                            ? _list.removeCompleted
                            : null,
                      ),
                      RaisedButton(
                        child: const Text('Mark All Completed'),
                        onPressed: _list.hasPendingTodos
                            ? _list.markAllAsCompleted
                            : null,
                      )
                    ],
                  )),
          Observer(
              builder: (_) => Flexible(
                    child: ListView.builder(
                        itemCount: _list.todos.length,
                        itemBuilder: (_, index) {
                          final todo = _list.todos[index];
                          return Observer(
                              builder: (_) => CheckboxListTile(
                                    value: todo.done,
                                    onChanged: (value) => todo.done = value,
                                    title: Text(todo.description),
                                  ));
                        }),
                  )),
        ],
      ));

  void _onTextChanged(String newValue) {
    _list.changeDescription(newValue);
  }

  void _onTextSubmitted(String value) {
    _list.addTodo(value);
    _textController.clear();
  }
}
