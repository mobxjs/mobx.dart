import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'clock/clock_widgets.dart';
import 'counter/counter_widgets.dart';
import 'form/form_widgets.dart';
import 'github/github_widgets.dart';
import 'hackernews/news_widgets.dart';
import 'multi_counter/multi_counter_widgets.dart';
import 'random_stream/random_widgets.dart';
import 'settings/settings_store.dart';
import 'settings/settings_widgets.dart';
import 'todos/todo_widgets.dart';

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
  Example(
    title: 'Settings',
    description: 'Settings for toggling dark mode',
    path: '/settings',
    widgetBuilder: (_) => Consumer<SettingsStore>(
      builder: (_, store, __) => SettingsExample(store),
    ),
  )
];
