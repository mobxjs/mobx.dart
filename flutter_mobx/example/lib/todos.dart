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

class TodoExample extends StatefulWidget {
  const TodoExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoExampleState createState() => _TodoExampleState();
}

class _TodoExampleState extends State<TodoExample> {
  final _todoList = TodoList();
  final _todoController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _todoController,
              ),
              RaisedButton(
                  child: const Text('Add Todo'),
                  onPressed: () {
                    _todoList.addTodo(_todoController.text);
                  }),
              Observer(
                  builder: (_) => ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: _todoList.todos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(_todoList.todos[index].description);
                        },
                      )),
            ],
          ),
        ),
      );
}
