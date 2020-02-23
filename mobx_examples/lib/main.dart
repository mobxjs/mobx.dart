import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dart_json_mapper_mobx/dart_json_mapper_mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/connectivity/connectivity_store.dart';
import 'package:mobx_examples/counter/counter.dart';
import 'package:mobx_examples/examples.dart';
import 'package:mobx_examples/multi_counter/multi_counter_store.dart';
import 'package:mobx_examples/settings/preferences_service.dart';
import 'package:mobx_examples/settings/settings_store.dart';
import 'package:provider/provider.dart';

import 'main.reflectable.dart';

void main() {
  initializeReflectable();
  JsonMapper().useAdapter(mobXAdapter);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<MultiCounterStore>(create: (_) => MultiCounterStore()),
            Provider<Counter>(create: (_) => Counter()),
            Provider<PreferencesService>(
              create: (_) => PreferencesService(),
            ),
            ProxyProvider<PreferencesService, SettingsStore>(
                update: (_, preferencesService, __) =>
                    SettingsStore(preferencesService)),
            Provider<ConnectivityStore>(
              create: (_) => ConnectivityStore(),
              dispose: (_, store) => store.dispose(),
            )
          ],
          child: Consumer<SettingsStore>(
            builder: (_, store, __) => Observer(
              builder: (_) => MaterialApp(
                initialRoute: '/',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  brightness:
                      store.useDarkMode ? Brightness.dark : Brightness.light,
                ),
                routes: {
                  '/': (_) => ExampleList(),
                }..addEntries(
                    examples.map((ex) => MapEntry(ex.path, ex.widgetBuilder))),
              ),
            ),
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
