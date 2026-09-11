import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../site/stores.dart';

Widget buildExample(DemoStores stores) => const CounterExample();

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});
  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  final count = Observable(0);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'A little change.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 16),
      const Text(
        'The Observer reads count. Tap the button: only that number needs to rebuild.',
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Observer(
          builder: (_) => Text(
            '${count.value}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
      FilledButton.icon(
        onPressed: () => runInAction(() => count.value++),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add one'),
      ),
      TextButton(
        onPressed: () => runInAction(() => count.value = 0),
        child: const Text('Reset'),
      ),
    ],
  );
}
