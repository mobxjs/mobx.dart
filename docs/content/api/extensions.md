# Convenience extensions

Extensions construct ordinary observable wrappers; they do not introduce a second reactive model.

```dart
final count = 0.obs();
final names = ['Ada'].asObservable();
final selected = <String>{}.asObservable();
final prices = {'Notebook': 24}.asObservable();
final request = Future.value(42).asObservable();
final signal = Stream.value(1).asObservable();
```

`IntExtension`, `DoubleExtension`, `BoolExtension`, and `StringExtension` wrap primitive values. `ObservableListExtension`, `ObservableSetExtension`, and `ObservableMapExtension` wrap collections. `ObservableFutureExtension` and `ObservableStreamExtension` wrap async sources. `ObservableBoolExtension` supplies boolean operations. Check [their signatures](/api/mobx-public) for supported names, contexts, and options.

An extension call creates a wrapper; it does not change the original object's type or convert everything reachable from it. Keep the wrapper in the owning store instead of constructing it during every build.
