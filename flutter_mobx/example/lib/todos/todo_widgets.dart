import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mobx_example/todos/todos.dart';

class TodoExample extends StatefulWidget {
  const TodoExample();

  @override
  State<StatefulWidget> createState() => _TodoExampleState();
}

class _TodoExampleState extends State<TodoExample> {
  final _list = TodoList();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Column(
        children: <Widget>[
          AddTodo(list: _list),
          ActionBar(list: _list),
          Description(list: _list),
          TodoListView(list: _list)
        ],
      ));
}

class Description extends StatelessWidget {
  const Description({this.list});

  final TodoList list;
  @override
  Widget build(BuildContext context) =>
      Observer(builder: (_) => Text(list.itemsDescription));
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
                            controlAffinity: ListTileControlAffinity.leading,
                            value: todo.done,
                            onChanged: (value) => todo.done = value,
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  todo.description,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => list.removeTodo(todo),
                                )
                              ],
                            ),
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
