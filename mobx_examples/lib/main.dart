import 'package:flutter/material.dart';
import 'package:mobx_examples/examples.dart';
import 'package:mobx_examples/multi_counter/multi_counter_store.dart';
import 'package:provider/provider.dart';

import 'counter/counter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<MultiCounterStore>.value(value: MultiCounterStore()),
            Provider<Counter>.value(value: Counter()),
          ],
          child: MaterialApp(
            initialRoute: '/',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: {
              '/': (_) => ExampleList(),
            }..addEntries(
                examples.map((ex) => MapEntry(ex.path, ex.widgetBuilder))),
          ));
}

class ExampleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MobX Examples'),
      ),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (_, int index) {
          final ex = examples[index];

          return ListTile(
            title: Text(ex.title),
            subtitle: Text(ex.description),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, ex.path),
          );
        },
      ));
}
