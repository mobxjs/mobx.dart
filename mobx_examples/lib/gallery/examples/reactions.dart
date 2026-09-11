import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../site/stores.dart';

Widget buildExample(DemoStores stores) => const ReactionsExample();

class ReactionsExample extends StatefulWidget {
  const ReactionsExample({super.key});
  @override
  State<ReactionsExample> createState() => _ReactionsExampleState();
}

class _ReactionsExampleState extends State<ReactionsExample> {
  final count = Observable(0), events = ObservableList<String>();
  final disposers = <ReactionDisposer>[];
  bool stopped = false;
  void record(String message) => runInAction(() => events.insert(0, message));
  @override
  void initState() {
    super.initState();
    disposers.addAll([
      autorun((_) => record('autorun: ${count.value}')),
      reaction<int>((_) => count.value, (value) => record('reaction: $value')),
      when(
        (_) => count.value >= 3,
        () => record('when: reached three; automatically disposed'),
      ),
    ]);
  }

  void stop() {
    for (final dispose in disposers) {
      dispose();
    }
    disposers.clear();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Effects have an owner.',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const Text(
        'autorun starts immediately. reaction waits for a change. when runs once at three.',
      ),
      const SizedBox(height: 20),
      Observer(
        builder: (_) => Text(
          'Count: ${count.value}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Wrap(
        spacing: 12,
        children: [
          FilledButton(
            onPressed: () => runInAction(() => count.value++),
            child: const Text('Increment'),
          ),
          OutlinedButton(
            onPressed: stopped
                ? null
                : () {
                    stop();
                    setState(() => stopped = true);
                  },
            child: const Text('Dispose reactions'),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Observer(
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final event in events.take(10)) Text(event)],
        ),
      ),
      if (stopped)
        const Text('The count still changes. Disposed effects stay quiet.'),
    ],
  );
}
