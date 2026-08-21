---
name: core-actions
description: Action API for mutating observables including @action, runInAction, untracked, transaction, and async actions
---

# Actions

Actions encapsulate mutations on observables, providing semantic naming and batched notifications.

## Action

```dart
// Direct API
final counter = Observable(0);
final increment = Action(() { counter.value++; });
increment([]);  // invoke with empty args list

// With annotations (preferred)
abstract class _Counter with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
```

Constructor: `Action(Function fn, {ReactiveContext? context, String? name})`

### Guarantees

- **Atomic notifications**: Changes are only notified at the end of the action
- **Nested actions**: For nested action calls, notifications sent only when the top-most action completes
- **Deferred reactions**: Linked reactions run only after the action finishes

### Enforcement

By default, MobX throws an exception if you mutate an observed observable outside an action. This is controlled by `ReactiveWritePolicy` in `ReactiveConfig`. Single-property setters in codegen stores are auto-wrapped in actions.

### Async Actions

Action methods can be `async`. The code generator ensures all mutations are wrapped in actions using Dart **zones**:

```dart
@action
Future<List<Repository>> fetchRepos() async {
  repositories = [];
  final future = client.repositories.listUserRepositories(user).toList();
  fetchReposFuture = ObservableFuture(future);
  return repositories = await future;
}
```

## runInAction

One-off action wrapper for ad-hoc mutations:

```dart
runInAction(() {
  counter.value = 10;
  name.value = 'MobX';
});
```

Signature: `T runInAction<T>(T Function() fn, {String? name, ReactiveContext? context})`

## untracked

Read observables inside a reaction without MobX tracking them:

```dart
final x = Observable(0);

autorun((_) {
  untracked(() => print(x.value));
});

x.value++; // autorun will NOT re-execute
```

## transaction

Low-level batching primitive (used internally by Action). Guarantees no notifications until the function completes:

```dart
transaction(() {
  counter.value = 10;
  name.value = 'MobX';
});
```

<!--
Source references:
- https://mobx.netlify.app/api/action
- https://mobx.netlify.app/concepts
-->
