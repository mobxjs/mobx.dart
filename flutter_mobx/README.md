# flutter_mobx

[![pub package](https://img.shields.io/pub/v/flutter_mobx.svg?label=flutter_mobx&color=blue)](https://pub.dartlang.org/packages/flutter_mobx)
[![CircleCI](https://circleci.com/gh/mobxjs/mobx.dart.svg?style=svg)](https://circleci.com/gh/mobxjs/mobx.dart)

> Flutter integration with [MobX.dart](https://pub.dartlang.org/packages/mobx).

Provides the **`Observer`** widget that listens to observables and automatically
rebuilds on changes.

### Example

```dart
class CounterExample extends StatefulWidget {
  const CounterExample({Key key}) : super(key: key);

  @override
  _CounterExampleState createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  final _counter = Counter();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Observer(
                  builder: (_) => Text(
                        '${_counter.value}',
                        style: const TextStyle(fontSize: 20),
                      )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _counter.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}

```

Notice the use of the `Observer` widget that listens to `_counter.value`, an observable, and rebuilds on changes.

**You can [go here](https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx/example) for more examples**

### Observer

`Observer(Widget Function(BuildContext context) builder)`

The **`builder`** function will be monitored by MobX and tracks all
the _observables_ that are being used inside it. When any of the
_observables_ change, builder will be called again to rebuild the
`Widget`. This gives you a seamless way to create a reactive `Widget`.

Note that the `Observer` will also throw an `AssertionError` if no observables are discovered in the `builder` function.
