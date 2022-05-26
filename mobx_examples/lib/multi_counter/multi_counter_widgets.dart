import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/multi_counter/multi_counter_store.dart';
import 'package:provider/provider.dart';

class MultiCounterExample extends StatefulWidget {
  const MultiCounterExample({Key? key}) : super(key: key);

  @override
  State<MultiCounterExample> createState() => _MultiCounterExampleState();
}

class _MultiCounterExampleState extends State<MultiCounterExample> {
  final MultiCounterStore store = MultiCounterStore();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Multi Counter'),
        ),
        body: const CounterListPage(),
      );
}

class CounterListPage extends StatelessWidget {
  const CounterListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MultiCounterStore>(context);

    return Column(children: <Widget>[
      ElevatedButton(
        onPressed: store.addCounter,
        child: const Text('Add Counter'),
      ),
      Observer(
        builder: (_) => ListView.builder(
            shrinkWrap: true,
            itemCount: store.counters.length,
            itemBuilder: (_, index) => ListTile(
                trailing: const Icon(Icons.navigate_next),
                title: Observer(
                    builder: (_) =>
                        Text('Count: ${store.counters[index].value}')),
                leading: IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () => store.removeCounter(index)),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                            appBar: AppBar(
                              title: const Text('Multi Counter'),
                            ),
                            body: CounterViewPage(store: store, index: index)),
                      ),
                    ))),
      )
    ]);
  }
}

class CounterViewPage extends StatelessWidget {
  const CounterViewPage({Key? key, required this.store, required this.index})
      : super(key: key);

  final int index;
  final MultiCounterStore store;

  @override
  Widget build(BuildContext context) {
    final counter = store.counters[index];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: counter.decrement,
                  child: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Center(
                    child: Observer(
                        builder: (_) => Text(
                              '${counter.value}',
                              style: const TextStyle(fontSize: 20),
                            )),
                  ),
                ),
                ElevatedButton(
                  onPressed: counter.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: counter.reset,
              child: const Text('Reset'),
            )
          ],
        ),
      ),
    );
  }
}
