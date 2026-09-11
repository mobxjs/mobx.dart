# Collections that report change

Use an observable collection when adding, removing, replacing, or iterating entries should affect a consumer. Making a `List` field observable only tracks replacement of the list reference; it does not make a plain list's mutations observable.

```dart
final names = ObservableList<String>.of(['Ada']);
final scores = ObservableMap<String, int>.of({'Ada': 10});
final selected = ObservableSet<String>();
final stop = autorun((_) => print('${names.length}: ${scores['Ada']}'));
runInAction(() {
  names.add('Lin');
  scores['Ada'] = 12;
  selected.add('Lin');
});
stop();
```

## Pick the structure that represents your facts

`ObservableList` preserves order and duplicates. `ObservableMap` represents keyed values. `ObservableSet` represents unique membership. Their constructors and usual Dart collection operations appear in the [complete reference](/api/mobx-public). Reads and writes use the collection's reactive context.

These collections track at the collection level. Do not assume per-index or per-key subscriptions. An item can contain its own observable fields when fine-grained item updates matter. Collection wrappers do not recursively convert nested values into observables.

## Derive filtered views

```dart
final tasks = ObservableList<String>.of(['Write', 'Review']);
final completed = ObservableSet<String>();
final remaining = Computed(() =>
    tasks.where((task) => !completed.contains(task)).toList());
```

Return a derived snapshot when consumers need a stable result. Do not mutate a collection during its own iteration. Keep predicates in `removeWhere` and `retainWhere` pure; their invocation order is not a synchronization mechanism.

## Change listeners are a lower-level tool

`observe` returns a disposer and reports `ListChange`, `MapChange`, or `SetChange`. Their listener typedefs describe the callback shape. These records are useful for bridges and audit adapters. Prefer computeds and reactions for application relationships: low-level listeners describe mutations, whereas reactions consume the resulting state.

```dart
final items = ObservableList<int>();
final stop = items.observe((change) => print(change));
runInAction(() => items.addAll([1, 2, 3]));
stop();
```

An action delays reactive effects until its outer batch ends. It is not a database transaction and does not roll back a partially completed collection operation after an exception. [Run the inventory example](/gallery/collections) to see one action coordinate a list, map, and set.
