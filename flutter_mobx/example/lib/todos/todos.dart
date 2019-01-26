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

  @action
  void changeDescription(String description) =>
      currentDescription = description;

  @action
  void changeFilter(VisibilityFilter filter) => this.filter = filter;

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

class TodoExample extends StatefulWidget {
  const TodoExample();

  @override
  State<StatefulWidget> createState() => _TodoExampleState();
}

class _TodoExampleState extends State<TodoExample> {
  final _list = TodoList();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          AddTodo(list: _list),
          ActionBar(list: _list),
          TodoListView(list: _list)
        ],
      ));
}

class TodoListView extends StatelessWidget {
  const TodoListView({@required this.list});

  final TodoList list;

  @override
  Widget build(BuildContext context) => Observer(
      builder: (_) => Flexible(
            child: ListView.builder(
                itemCount: list.visibleTodos.length,
                itemBuilder: (_, index) {
                  final todo = list.visibleTodos[index];
                  return Observer(
                      builder: (_) => CheckboxListTile(
                            value: todo.done,
                            onChanged: (value) => todo.done = value,
                            title: Text(todo.description),
                          ));
                }),
          ));
}

class ActionBar extends StatelessWidget {
  const ActionBar({@required this.list});

  final TodoList list;

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        Observer(
          builder: (_) => Column(
                children: <Widget>[
                  RadioListTile(
                      dense: true,
                      title: const Text('All'),
                      value: VisibilityFilter.all,
                      groupValue: list.filter,
                      onChanged: list.changeFilter),
                  RadioListTile(
                      dense: true,
                      title: const Text('Pending'),
                      value: VisibilityFilter.pending,
                      groupValue: list.filter,
                      onChanged: list.changeFilter),
                  RadioListTile(
                      dense: true,
                      title: const Text('Completed'),
                      value: VisibilityFilter.completed,
                      groupValue: list.filter,
                      onChanged: list.changeFilter),
                ],
              ),
        ),
        Observer(
            builder: (_) => ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: const Text('Remove Completed'),
                      onPressed:
                          list.hasCompletedTodos ? list.removeCompleted : null,
                    ),
                    RaisedButton(
                      child: const Text('Mark All Completed'),
                      onPressed:
                          list.hasPendingTodos ? list.markAllAsCompleted : null,
                    )
                  ],
                ))
      ]);
}

class AddTodo extends StatelessWidget {
  AddTodo({@required this.list});

  final TodoList list;
  final _textController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) => TextField(
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'Add a Todo', contentPadding: EdgeInsets.all(8)),
              controller: _textController,
              onChanged: _onTextChanged,
              onSubmitted: _onTextSubmitted,
            ),
      );

  void _onTextChanged(String newValue) {
    list.changeDescription(newValue);
  }

  void _onTextSubmitted(String value) {
    list.addTodo(value);
    _textController.clear();
  }
}
