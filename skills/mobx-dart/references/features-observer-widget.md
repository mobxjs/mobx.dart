---
name: features-observer-widget
description: Flutter Observer widget, Observer.withBuiltChild optimization, and ReactionBuilder for reactive UI rendering
---

# Observer Widget and ReactionBuilder

The `Observer` widget from `flutter_mobx` is the primary way to connect MobX stores to Flutter UI. It rebuilds automatically when any observable read in its `builder` changes.

## Observer

```dart
import 'package:flutter_mobx/flutter_mobx.dart';

Observer(
  builder: (_) => Text('${counter.value}'),
)
```

### Critical Gotcha: Immediate Execution Context

The `builder` function only tracks observables read in its **immediate execution context**. Observables read inside nested functions, callbacks, or child widget constructors are **not** tracked.

```dart
// WRONG: observable read inside nested function — NOT tracked
Observer(builder: (_) {
  return GestureDetector(
    onTap: () => print(store.value), // not tracked!
    child: Text('tap me'),
  );
})

// CORRECT: read the observable directly in the builder
Observer(builder: (_) {
  final val = store.value; // tracked!
  return Text('$val');
})
```

If your `Observer` is not updating, check that observables are read in the immediate builder scope.

## Observer.withBuiltChild

Performance optimization that excludes a child subtree from rebuilds (same technique as `AnimatedBuilder`):

```dart
final obsColor = Observable(Colors.green);

Observer.withBuiltChild(
  builder: (context, child) {
    return Container(
      color: obsColor.value,  // rebuilds when color changes
      child: child,           // child is NOT rebuilt
    );
  },
  child: ListView.builder(   // expensive widget, built once
    itemCount: 1000,
    itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  ),
)
```

## ReactionBuilder

Run reactions tied to a widget's lifecycle without creating a `StatefulWidget`:

```dart
ReactionBuilder(
  builder: (context) {
    return reaction(
      (_) => store.connectivityStream.value,
      (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result == ConnectivityResult.none
              ? 'You\'re offline' : 'You\'re online')),
        );
      },
      delay: 4000,
    );
  },
  child: Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: const Text('Toggle connection to see response'),
  ),
)
```

- The `builder` returns a `ReactionDisposer` which is auto-disposed when the widget unmounts
- Keeps the outer widget as a `StatelessWidget` — no need for `initState`/`dispose` ceremony

## ObservableList in Observer

When passing an `ObservableList` to a child widget, call `.toList()` so the Observer tracks mutations:

```dart
Observer(builder: (_) {
  return ChildWidget(
    list: controller.observableList.toList(), // tracked!
  );
})
```

The child widget should accept `List<T>`, not `ObservableList<T>`, to keep the tracking context in the parent's Observer.

<!--
Source references:
- https://mobx.netlify.app/api/observers
- https://mobx.netlify.app/concepts
- https://mobx.netlify.app/api/observable
-->
