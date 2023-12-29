import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class SimpleCounter {
// highlight-start
  // Step 1
  // ======
  // Setup the observable state.
  // In this case its a simple count as an integer.
  final count = Observable(0);
// highlight-end

// highlight-start
  // Step 2
  // ======
  // Setup the action to increment the count
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
              // ======
              // Display the count using the Observer (a reaction)
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
