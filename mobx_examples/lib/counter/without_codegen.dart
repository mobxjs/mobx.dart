import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class SimpleCounter {
// highlight-start
  // Step 1
  final count = Observable(0);
// highlight-end

// highlight-start
  // Step 2
  void increment() {
    runInAction(() => count.value++);
  }
// highlight-end
}

class CounterView extends StatefulWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  CounterExampleState createState() => CounterExampleState();
}

class CounterExampleState extends State<CounterView> {
  final SimpleCounter counter = SimpleCounter();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('MobX Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
// highlight-start
              // Step 3
              Observer(
                  builder: (_) => Text(
                        '${counter.count.value}',
                        style: const TextStyle(fontSize: 40),
                      )),
// highlight-end
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: counter.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
