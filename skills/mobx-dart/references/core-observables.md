---
name: core-observables
description: Observable and Computed APIs including @observable, @readonly, @computed annotations and reactive extensions
---

# Observables and Computed Properties

Observables are the reactive state of a MobX application. State divides into **core state** (inherent to domain) and **derived state** (computed from core state).

## Observable

```dart
// Direct API
final counter = Observable(0);
counter.value = 1; // fires notification

// With annotations in a Store
abstract class _Todo with Store {
  @observable
  String description = '';

  @observable
  bool done = false;
}
```

Constructor: `Observable(T initialValue, {String? name, ReactiveContext? context})`

### Reactive Extensions

Convert primitives to observables with `.obs()`:

```dart
var name = ''.obs();       // ObservableString
var counter = 0.obs();     // ObservableInt
var flag = true.obs();
flag.toggle();             // flips boolean value
```

### @readonly Annotation

Creates a public getter for a private observable field. The field can only be mutated inside `@action` methods:

```dart
abstract class _Counter with Store {
  @readonly
  int _value = 0;  // must be private

  @action
  void increment() {
    _value++;  // only actions can mutate
  }
}
// Usage: counter.value (read-only from outside)
```

### Deep Equality for Collections

Use `@MakeObservable(useDeepEquals: true)` to compare collections by element equality instead of reference:

```dart
abstract class _Todos with Store {
  @MakeObservable(useDeepEquals: true)
  List<Todo> _todos = [];
}
```

## Computed

Derived state that auto-updates when underlying observables change. Computed values are **cached** — notifications only fire when the computed value actually differs from the previous one.

```dart
// Direct API
final first = Observable('Jane');
final last = Observable('Doe');
final fullName = Computed(() => '${first.value} ${last.value}');

// With annotations
abstract class _Contact with Store {
  @observable
  String first = '';

  @observable
  String last = '';

  @computed
  String get fullName => '$first $last';
}
```

Constructor: `Computed(T Function() fn, {String name, ReactiveContext context, EqualityComparer<T>? equals, bool? keepAlive})`

### Key Behavior

- Calling `.value` always re-evaluates the function (the result is not cached between reads)
- **Notification caching**: the previous value is cached; notifications only fire when the computed value differs from the cached value
- `keepAlive: true` prevents suspension when unobserved (risk of memory leaks)
- Use `@computed` to move conditional logic out of widgets into the store

### Power of @computed

Move business logic from widgets into computed properties:

```dart
// Instead of checking in widget:
// if (store.loadOperation != null && store.loadOperation.status == FutureStatus.fulfilled)

// Create a computed:
@computed
bool get hasResults =>
    loadOperation != null &&
    loadOperation.status == FutureStatus.fulfilled;

// Widget becomes simple:
Observer(builder: (_) => store.hasResults ? ContactView(store) : Container())
```

<!--
Source references:
- https://mobx.netlify.app/api/observable
- https://mobx.netlify.app/concepts
- https://mobx.netlify.app/guides/cheat-sheet
-->
