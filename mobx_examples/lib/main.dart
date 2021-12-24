import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/connectivity/connectivity_store.dart';
import 'package:mobx_examples/counter/counter.dart';
import 'package:mobx_examples/examples.dart';
import 'package:mobx_examples/multi_counter/multi_counter_store.dart';
import 'package:mobx_examples/settings/preferences_service.dart';
import 'package:mobx_examples/settings/settings_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  // ignore: avoid_print
  mainContext.spy(print);

  runApp(MyApp(sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp(this.sharedPreferences, {Key? key}) : super(key: key);

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<MultiCounterStore>(create: (_) => MultiCounterStore()),
            Provider<Counter>(create: (_) => Counter()),
            Provider<PreferencesService>(
              create: (_) => PreferencesService(sharedPreferences),
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
                  '/': (_) => const ExampleList(),
                }..addEntries(
                    examples.map((ex) => MapEntry(ex.path, ex.widgetBuilder))),
              ),
            ),
          ));
}

class ExampleList extends StatelessWidget {
  const ExampleList({Key? key}) : super(key: key);

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
