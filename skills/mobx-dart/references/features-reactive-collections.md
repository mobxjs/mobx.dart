---
name: features-reactive-collections
description: ObservableList, ObservableMap, ObservableSet, ObservableFuture, ObservableStream and Atom for reactive data structures
---

# Reactive Collections and Wrappers

Dart's built-in `List`, `Map`, `Set`, `Future`, and `Stream` are not reactive. MobX provides observable wrappers that participate in the reactive system.

## ObservableList

Tracks additions, removals, and modifications of items:

```dart
final todos = ObservableList<String>();
todos.add('Buy milk');    // notifies observers
todos.removeAt(0);        // notifies observers

// From existing list
final items = ['a', 'b'].asObservable();
```

## ObservableMap

Tracks key additions, removals, and value modifications:

```dart
final settings = ObservableMap<String, dynamic>();
settings['theme'] = 'dark';  // notifies observers
```

## ObservableSet

Tracks value additions and removals:

```dart
final tags = ObservableSet<String>();
tags.add('flutter');  // notifies observers
```

## ObservableFuture

Reactive wrapper around `Future<T>` exposing `status`, `result`, and `error` as observables:

```dart
abstract class _GithubStore with Store {
  static ObservableFuture<List<Repository>> emptyResponse =
      ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Repository>> fetchReposFuture = emptyResponse;

  @action
  Future<void> fetchRepos() async {
    final future = client.repositories.listUserRepositories(user).toList();
    fetchReposFuture = ObservableFuture(future);
    await future;
  }
}

// In widget — show loading state
Observer(
  builder: (_) => store.fetchReposFuture.status == FutureStatus.pending
      ? const LinearProgressIndicator()
      : Container(),
)
```

`FutureStatus` values: `pending`, `fulfilled`, `rejected`

## ObservableStream

Reactive wrapper around `Stream<T>` exposing `data`, `error`, and `status`:

```dart
ObservableStream(
  myStream,
  initialValue: defaultValue,
  cancelOnError: false,
  equals: customEqualityFn,  // optional
)
```

## asObservable() Extension

Convert plain collections to observable versions:

```dart
final list = [1, 2, 3].asObservable();          // ObservableList<int>
final map = {'a': 1}.asObservable();             // ObservableMap<String, int>
final set = {1, 2, 3}.asObservable();            // ObservableSet<int>
```

## Atom

Low-level reactive primitive at the core of MobX. Does not store a value — only tracks observation and change notifications. `Observable` extends `Atom`. Rarely used directly.

```dart
class Clock {
  Clock() {
    _atom = Atom(
      name: 'Clock Atom',
      onObserved: _startTimer,
      onUnobserved: _stopTimer,
    );
  }

  DateTime get now {
    _atom.reportObserved();  // tell MobX this is being read
    return DateTime.now();
  }

  late Atom _atom;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();  // guard against re-entrance
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _atom.reportChanged();  // tell MobX value changed
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }
}
```

Use cases: custom reactive data sources (clocks, sensors, external event streams).

<!--
Source references:
- https://mobx.netlify.app/api/observable
- https://mobx.netlify.app/guides/cheat-sheet
- https://mobx.netlify.app/guides/when-does-mobx-react
-->
