import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:mobx_examples/todos/todo_list.dart';

class TodoExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<TodoList>(
      create: (_) => TodoList(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Todos'),
          ),
          body: Column(
            children: <Widget>[
              AddTodo(),
              ActionBar(),
              Description(),
              TodoListView()
            ],
          )));
}

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return Observer(
        builder: (_) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              list.itemsDescription,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )));
  }
}

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return Observer(
        builder: (_) => Flexible(
              child: ListView.builder(
                  itemCount: list.visibleTodos.length,
                  itemBuilder: (_, index) {
                    final todo = list.visibleTodos[index];
                    return Observer(
                        builder: (_) => CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: todo.done,
                              onChanged: (flag) => todo.done = flag,
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
}

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return Column(children: <Widget>[
      Observer(
        builder: (_) {
          final selections = VisibilityFilter.values
              .map((f) => f == list.filter)
              .toList(growable: false);
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text('All'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text('Pending'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text('Completed'),
                    )
                  ],
                  onPressed: (index) {
                    list.filter = VisibilityFilter.values[index];
                  },
                  isSelected: selections,
                ),
              ),
            ],
          );
        },
      ),
      Observer(
          builder: (_) => ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Remove Completed'),
                    onPressed: list.canRemoveAllCompleted
                        ? list.removeCompleted
                        : null,
                  ),
                  RaisedButton(
                    child: const Text('Mark All Completed'),
                    onPressed: list.canMarkAllCompleted
                        ? list.markAllAsCompleted
                        : null,
                  )
                ],
              ))
    ]);
  }
}

class AddTodo extends StatelessWidget {
  final _textController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
          labelText: 'Add a Todo', contentPadding: EdgeInsets.all(8)),
      controller: _textController,
      onChanged: (String newValue) {
        list.currentDescription = newValue;
      },
      onSubmitted: (String value) {
        list.addTodo(value);
        _textController.clear();
      },
    );
  }
}
