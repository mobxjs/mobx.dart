import 'package:flutter/material.dart';
import 'package:flutter_mobx_example/counter/counter.dart';
import 'package:flutter_mobx_example/todos/todo_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
//        home: const CounterExample(title: 'Flutter Demo Home Page'),
      );
}

class ExampleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
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
