import 'package:flutter/material.dart';
import 'package:mobx_examples/counter/counter_widgets.dart';
import 'package:mobx_examples/github/github_widgets.dart';
import 'package:mobx_examples/todos/todo_widgets.dart';

class Example {
  Example(
      {@required this.title,
      @required this.description,
      @required this.path,
      @required this.widgetBuilder});

  final WidgetBuilder widgetBuilder;
  final String path;
  final String title;

  final String description;
}

final List<Example> examples = [
  Example(
    title: 'Counter',
    description: 'The classic Counter that can be incremented.',
    path: '/counter',
    widgetBuilder: (_) => const CounterExample(),
  ),
  Example(
    title: 'Todos',
    description: 'Managing a list of Todos, the TodoMVC way.',
    path: '/todos',
    widgetBuilder: (_) => const TodoExample(),
  ),
  Example(
    title: 'Github Repos',
    description: 'Get a list of repos for a user',
    path: '/github',
    widgetBuilder: (_) => const GithubExample(),
  ),
];
