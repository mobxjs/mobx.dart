# Flutter reads state where it renders

`Observer` tracks synchronous reads in its builder and rebuilds when their observable dependencies change. Put it around the smallest useful rendering unit, so unrelated layout does not rebuild with a badge.

```dart
Observer(builder: (_) => Text('${cart.total.value}'))
```

A nested callback that runs later is outside this builder's tracking pass. Read the observable in the builder or put another `Observer` around the later consumer.

## Keep a stable child

`Observer.withBuiltChild` builds an invariant child outside tracking and passes it to the builder. Use it for expensive content that does not read the changing state:

```dart
Observer.withBuiltChild(
  child: const Text('Cart total'),
  builder: (_, child) => Row(children: [
    child,
    Text('${cart.total.value}'),
  ]),
)
```

## Own effects with widgets

`ReactionBuilder` creates a reaction for its widget lifetime and disposes it when unmounted. The builder returns the disposer:

```dart
ReactionBuilder(
  builder: (_) => reaction<int>(
    (_) => cart.quantity.value,
    (quantity) => analytics.recordCartSize(quantity),
  ),
  child: const CartScreen(),
)
```

This sketch assumes injected `cart` and `analytics`. `MultiReactionBuilder` composes several `ReactionBuilder`s around one child. When replacing an input store, ensure the reaction is recreated for that input; use an appropriate key or an owner that explicitly replaces and disposes its reaction. Do not keep a closure over a stale store instance.

## Extend the integration deliberately

`StatelessObserverWidget` and `StatefulObserverWidget` are bases for reusable reactive widgets. Their corresponding elements and `ObserverWidgetMixin` / `ObserverElementMixin` implement tracking around Flutter builds and invalidation scheduling. These are adapter APIs; ordinary app code normally uses `Observer`.

`name` and a custom reactive `context` help diagnostics and isolated runtimes. `enableWarnWhenNoObservables` controls warnings about builders with no tracked reads; `debugAddStackTraceInObserverName` controls debug naming detail. Do not suppress warnings to hide a misplaced read.

The [generated Flutter reference](/api/flutter_mobx-public) lists constructors, options, mixin hooks, and public members. The gallery runs actual Flutter widgets and `flutter_mobx`, with one shared web engine and removable views.
