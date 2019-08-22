import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobx_examples/counter/counter.dart';
import 'package:mobx_examples/examples.dart';
import 'package:mobx_examples/multi_counter/multi_counter_store.dart';
import 'package:mobx_examples/settings/preferences_service.dart';
import 'package:mobx_examples/settings/settings_store.dart';

Future<void> main() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<MultiCounterStore>(builder: (_) => MultiCounterStore()),
            Provider<Counter>(builder: (_) => Counter()),
            Provider<PreferencesService>(
              builder: (_) => PreferencesService(_sharedPreferences),
            ),
            ProxyProvider<PreferencesService, SettingsStore>(
                builder: (_, preferencesService, __) =>
                    SettingsStore(preferencesService)),
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
