---
name: core-reactions
description: Reaction APIs (autorun, reaction, when, asyncWhen) for responding to observable changes with custom schedulers
---

# Reactions

Reactions are the observer side of the MobX reactive system. They automatically track observables read during execution and re-run when those observables change. All reactions return a `ReactionDisposer` function.

## autorun

Runs immediately and re-runs whenever any tracked observable changes.

```dart
final greeting = Observable('Hello World');

final dispose = autorun((_) {
  print(greeting.value);
});

greeting.value = 'Hello MobX';
dispose(); // stop tracking

// Prints: Hello World, Hello MobX
```

Signature: `ReactionDisposer autorun(Function(Reaction) fn, {String? name, int? delay, ReactiveContext? context, Timer Function(void Function())? scheduler, void Function(Object, Reaction)? onError})`

## reaction

Monitors a tracking function and runs an effect only when the tracked value changes. Does **not** run the effect immediately (unlike autorun).

```dart
final greeting = Observable('Hello World');

final dispose = reaction(
  (_) => greeting.value,      // tracking function
  (msg) => print(msg),        // effect
);

greeting.value = 'Hello MobX'; // prints: Hello MobX
dispose();
```

Signature: `ReactionDisposer reaction<T>(T Function(Reaction) fn, void Function(T) effect, {String? name, int? delay, bool? fireImmediately, EqualityComparer<T>? equals, ReactiveContext? context, Timer Function(void Function())? scheduler, void Function(Object, Reaction)? onError})`

Key options:
- `fireImmediately`: Run effect on first evaluation too
- `equals`: Custom equality comparison for the tracked value
- `delay`: Throttle the effect in milliseconds

## when

One-time reaction that runs the effect when predicate becomes true, then auto-disposes.

```dart
final greeting = Observable('Hello World');

final dispose = when(
  (_) => greeting.value == 'Hello MobX',
  () => print('Someone greeted MobX'),
);

greeting.value = 'Hello MobX'; // runs effect and disposes
```

## asyncWhen

Like `when` but returns a `Future` instead of taking an effect callback:

```dart
final completed = Observable(false);

Future<void> waitForCompletion() async {
  await asyncWhen(() => completed.value == true);
  print('Completed');
}
```

## Custom Scheduler

Control when reactions re-execute using a scheduler:

```dart
Timer customScheduler(void Function() fn) {
  return Timer(Duration(milliseconds: 100), fn);
}

final dispose = autorun(
  (_) => print('Counter: ${counter.value}'),
  scheduler: customScheduler,
);

// Rapid changes are batched; only final value printed after delay
counter.value = 1;
counter.value = 2;
counter.value = 3;
```

## Disposing Reactions

Always dispose reactions when no longer needed (e.g., in `State.dispose()`):

```dart
abstract class _MyStore with Store {
  late ReactionDisposer _dispose;

  void setupReactions() {
    _dispose = autorun((_) { /* ... */ });
  }

  void dispose() {
    _dispose();
  }
}
```

<!--
Source references:
- https://mobx.netlify.app/api/reaction
- https://mobx.netlify.app/concepts
- https://mobx.netlify.app/guides/cheat-sheet
-->
