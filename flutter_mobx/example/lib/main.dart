import 'package:flutter/material.dart';
import 'package:flutter_mobx_example/counter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CounterExample(title: 'Flutter Demo Home Page'),
      );
}
