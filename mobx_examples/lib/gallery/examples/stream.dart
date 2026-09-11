import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../site/stores.dart';

Widget buildExample(DemoStores stores) => const StreamExample();

class StreamExample extends StatefulWidget {
  const StreamExample({super.key});
  @override
  State<StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> {
  final source = StreamController<int>();
  late final signal = ObservableStream(source.stream);
  late final StreamSubscription<int> subscription;
  int sequence = 0;
  @override
  void initState() {
    super.initState();
    subscription = signal.listen(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
  }

  @override
  void dispose() {
    unawaited(subscription.cancel());
    unawaited(source.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow a live signal',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Text('Status: ${signal.status.name}'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            signal.hasError
                ? 'Signal interrupted. Send a value to recover.'
                : 'Latest value: ${signal.value ?? 'Waiting'}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: signal.status == StreamStatus.done
                  ? null
                  : () => source.add(++sequence),
              child: const Text('Send value'),
            ),
            OutlinedButton(
              onPressed: signal.status == StreamStatus.done
                  ? null
                  : () => source.addError(
                      StateError('Demo error'),
                      StackTrace.current,
                    ),
              child: const Text('Send error'),
            ),
            TextButton(
              onPressed: signal.status == StreamStatus.done
                  ? null
                  : () => source.close(),
              child: const Text('Complete stream'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'The stream belongs to this route. Leaving cancels its subscription. Reopen the example to start a fresh stream.',
        ),
      ],
    ),
  );
}
