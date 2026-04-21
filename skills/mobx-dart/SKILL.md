---
name: mobx-dart
description: >-
  This skill should be used when working with MobX.dart for Dart/Flutter state management,
  when the user asks to "create a store", "add observable", "add action", "add computed",
  "use Observer widget", "set up reactions", "organize stores",
  or when code imports `package:mobx/mobx.dart`, `package:flutter_mobx/flutter_mobx.dart`,
  or `package:mobx_codegen/mobx_codegen.dart`.
  Covers observables, actions, reactions, Observer widget, store patterns,
  code generation with mobx_codegen, and reactive collections.
---

# MobX.dart

MobX.dart is a reactive state management library for Dart and Flutter built around three core concepts: **Observables** (reactive state), **Actions** (state mutations), and **Reactions** (side-effects). It uses `mobx_codegen` for annotation-based code generation to minimize boilerplate.

## Packages

| Package | Purpose |
|---------|---------|
| `mobx` | Core library: Observables, Actions, Reactions |
| `flutter_mobx` | Flutter integration: Observer widget, ReactionBuilder |
| `mobx_codegen` | Code generation: `@observable`, `@computed`, `@action` annotations |

## Store Declaration Pattern

Every store follows this boilerplate:

```dart
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = _Counter with _$Counter;

abstract class _Counter with Store {
  @observable
  int value = 0;

  @computed
  bool get isPositive => value > 0;

  @action
  void increment() {
    value++;
  }
}
```

Run code generation with:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Key Annotations

| Annotation | Target | Purpose |
|---|---|---|
| `@observable` | Field | Make field reactive |
| `@readonly` | Private field | Observable with auto-generated public getter; mutations only via `@action` |
| `@computed` | Getter | Derived state that auto-updates when dependencies change |
| `@action` | Method | Wrap mutations in a transaction; supports async |
| `@MakeObservable()` | Field | Advanced config (e.g., `useDeepEquals: true`) |

## Observer Widget

Wrap reactive UI in `Observer` from `flutter_mobx`:

```dart
Observer(builder: (_) => Text('${counter.value}'))
```

**Critical**: Only observables read in the **immediate execution context** of the builder are tracked. Observables read inside nested functions or callbacks are NOT tracked.

## Reactive Collections

Use `ObservableList`, `ObservableMap`, `ObservableSet` instead of plain Dart collections for item-level tracking. Use `ObservableFuture` and `ObservableStream` for async state.

## Reference Files

For detailed API documentation, patterns, and best practices, consult:

### Core

- **[`references/core-store-and-codegen.md`](references/core-store-and-codegen.md)** — Store class pattern, annotations, build_runner, generated output
- **[`references/core-observables.md`](references/core-observables.md)** — Observable, Computed, @observable, @readonly, @computed, reactive extensions
- **[`references/core-actions.md`](references/core-actions.md)** — @action, runInAction, untracked, transaction, async actions
- **[`references/core-reactions.md`](references/core-reactions.md)** — autorun, reaction, when, asyncWhen, custom schedulers

### Flutter Integration

- **[`references/features-observer-widget.md`](references/features-observer-widget.md)** — Observer, Observer.withBuiltChild, ReactionBuilder
- **[`references/features-reactive-collections.md`](references/features-reactive-collections.md)** — ObservableList/Map/Set/Future/Stream, Atom

### Best Practices

- **[`references/best-practices-store-organization.md`](references/best-practices-store-organization.md)** — Widget-Store-Service triad, store hierarchy, Provider integration
- **[`references/best-practices-reactivity-rules.md`](references/best-practices-reactivity-rules.md)** — When MobX reacts, tracking pitfalls, form validation
- **[`references/best-practices-json-serialization.md`](references/best-practices-json-serialization.md)** — json_serializable integration, custom converters

### Advanced

- **[`references/advanced-context-and-config.md`](references/advanced-context-and-config.md)** — ReactiveContext, ReactiveConfig, read/write policies
- **[`references/advanced-spy.md`](references/advanced-spy.md)** — Spy API for tracing and debugging reactive events

## Important Notes

- **No deep observability**: Unlike JS MobX, marking a complex object as `@observable` only tracks reference reassignment, not internal field changes. Mark individual fields with `@observable`.
- **Action enforcement**: By default, mutating an observed observable outside an action throws. Single-property setters in codegen stores are auto-wrapped.
- **Computed caching**: `.value` always re-evaluates, but notifications only fire when the result differs from the previous value.
