---
name: best-practices-reactivity-rules
description: Rules of MobX reactivity, common tracking pitfalls, and when to use Observable collections vs plain Dart types
---

# When Does MobX React?

Understanding MobX's tracking rules prevents common bugs where reactions don't fire as expected.

## Rules of Reactivity

### 1. Notifications fire when an observable changes value

Every observable notifies linked reactions on value change. If no reactions observe it, the notification is lost.

### 2. Tracking is automatic when a read happens

Reading an observable inside a reaction's tracking function is enough — no explicit subscription needed:

```dart
reaction((_) => person.name, (name) => print(name));
// person.name is automatically tracked
```

### 3. Read the Observable, not the value

If you extract a value before the reaction, MobX cannot track it:

```dart
// WRONG: 'value' is a plain int, not an observable
final count = Observable(10);
var value = count.value;
reaction((_) => value, (v) => print(v));  // never re-executes!

// CORRECT: read the observable inside the tracking function
reaction((_) => count.value, (v) => print(v));  // works!
```

### 4. Observer builder must read in immediate context

`Observer` only tracks observables read in the **immediate execution** of its `builder` function. Observables read in nested functions, callbacks, or passed-down closures are **not** tracked.

```dart
// NOT tracked: observable read in nested closure
Observer(builder: (_) {
  return GestureDetector(
    onTap: () => doSomething(store.value),  // not tracked
    child: Text('tap'),
  );
})

// Tracked: read in immediate context
Observer(builder: (_) {
  final v = store.value;  // tracked!
  return Text('$v');
})
```

## List<T> vs ObservableList<T>

`List<T>` has no notion of observability. Adding/removing items won't notify MobX. Use `ObservableList<T>` for reactive collections:

```dart
// NOT reactive
@observable
List<String> items = [];  // reassignment tracked, but add/remove NOT tracked

// Reactive
final items = ObservableList<String>();  // add/remove/modify all tracked
```

Same applies to `Map` vs `ObservableMap`, `Set` vs `ObservableSet`, `Future` vs `ObservableFuture`, `Stream` vs `ObservableStream`.

## Form Validation Pattern

Use `reaction()` as side-effects for field validation:

```dart
abstract class _FormStore with Store {
  @observable String name = '';
  final error = FormErrorState();

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => name, validateName),
      reaction((_) => email, validateEmail),
    ];
  }

  @action
  void validateName(String value) {
    error.name = value.isEmpty ? 'Cannot be blank' : null;
  }

  void dispose() {
    for (final d in _disposers) { d(); }
  }
}
```

## Nested Stores

Stores are regular Dart classes. Compose them freely:

```dart
abstract class _FormStore with Store {
  final FormErrorState error = FormErrorState();
  // error.username, error.email etc. are all observable
}
```

<!--
Source references:
- https://mobx.netlify.app/guides/when-does-mobx-react
- https://mobx.netlify.app/api/observers
- https://mobx.netlify.app/examples/form
-->
