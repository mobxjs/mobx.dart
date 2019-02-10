import 'package:flutter/material.dart';
import 'package:mobx_examples/counter/counter.dart';
import 'package:mobx_examples/todos/todo_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (_) => ExampleList(),
          '/counter': (_) => const CounterExample(),
          '/todos': (_) => const TodoExample(),
        },
      );
}

class ExampleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MobX Examples'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: const Text('Counter'),
              onPressed: () => Navigator.pushNamed(context, '/counter'),
            ),
            RaisedButton(
              child: const Text('Todos'),
              onPressed: () => Navigator.pushNamed(context, '/todos'),
            )
          ],
        ),
      ));
}
