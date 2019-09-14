import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/settings/settings_store.dart';

class SettingsExample extends StatelessWidget {
  const SettingsExample(this.store);

  final SettingsStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Observer(
        builder: (context) => SwitchListTile(
          value: store.useDarkMode,
          title: const Text('Use dark mode'),
          onChanged: (value) {
            store.setDarkMode(value: value);
          },
        ),
      ));
}
