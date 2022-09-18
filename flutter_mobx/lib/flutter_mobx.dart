/// Provides bindings for using MobX observables with Flutter.
/// The primary way of consuming the observables in Flutter is via the `Observer` widget.
///
/// The example below shows the use of an `Observer` that has a `builder` function
/// that consumes the `counter.value` observable.
/// ```
///   Widget build(BuildContext context) => Scaffold(
///        appBar: AppBar(
///          backgroundColor: Colors.blue,
///          title: const Text('MobX Counter'),
///        ),
///        body: Center(
///          child: Column(
///            mainAxisAlignment: MainAxisAlignment.center,
///            children: <Widget>[
///              const Text(
///                'You have pushed the button this many times:',
///              ),
///              Observer(
///                  builder: (_) => Text(
///                        '${counter.value}',
///                        style: const TextStyle(fontSize: 40),
///                      )),
///            ],
///          ),
///        ),
///        floatingActionButton: FloatingActionButton(
///          onPressed: counter.increment,
///          tooltip: 'Increment',
///          child: const Icon(Icons.add),
///        ),
///      );
///

library flutter_mobx;

export 'package:flutter_mobx/src/observer.dart';
export 'package:flutter_mobx/src/observer_widget_mixin.dart';
export 'package:flutter_mobx/src/reaction_builder.dart'
    hide ReactionBuilderState;
export 'package:flutter_mobx/src/stateful_observer_widget.dart';
export 'package:flutter_mobx/src/stateless_observer_widget.dart';

export 'version.dart';
