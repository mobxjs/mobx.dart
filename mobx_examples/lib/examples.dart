import 'package:flutter/material.dart';
import 'package:mobx_examples/clock/clock_widgets.dart';
import 'package:mobx_examples/counter/counter_widgets.dart';
import 'package:mobx_examples/form/form_widgets.dart';
import 'package:mobx_examples/github/github_widgets.dart';
import 'package:mobx_examples/hackernews/news_widgets.dart';
import 'package:mobx_examples/multi_counter/multi_counter_widgets.dart';
import 'package:mobx_examples/random_stream/random_widgets.dart';
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
    title: 'Multi Counter',
    description: 'Multiple Counters with a shared Store using Provider.',
    path: '/multi-counter',
    widgetBuilder: (_) => const MultiCounterExample(),
  ),
  Example(
    title: 'Simple Stream Observer',
    description: 'Observing a Stream of random numbers.',
    path: '/random-stream',
    widgetBuilder: (_) => const RandomNumberExample(),
  ),
  Example(
    title: 'Todos',
    description: 'Managing a list of Todos, the TodoMVC way.',
    path: '/todos',
    widgetBuilder: (_) => TodoExample(),
  ),
  Example(
    title: 'Github Repos',
    description: 'Get a list of repos for a user',
    path: '/github',
    widgetBuilder: (_) => const GithubExample(),
  ),
  Example(
    title: 'Clock',
    description: 'A simple ticking Clock, made with an Atom',
    path: '/clock',
    widgetBuilder: (_) => const ClockExample(),
  ),
  Example(
    title: 'Login Form',
    description: 'A login form with validations',
    path: '/form',
    widgetBuilder: (_) => const FormExample(),
  ),
  Example(
    title: 'Hacker News',
    description: 'Simple reader for Hacker News',
    path: '/hn',
    widgetBuilder: (_) => const HackerNewsExample(),
  ),
];
