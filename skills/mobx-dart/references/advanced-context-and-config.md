---
name: advanced-context-and-config
description: ReactiveContext and ReactiveConfig for custom MobX contexts, read/write policies, and error boundaries
---

# ReactiveContext and Configuration

MobX operates within a `ReactiveContext` that manages observables and reactions. By default, the singleton `mainContext` is used. Custom contexts are an advanced feature for isolating reactive systems.

## ReactiveContext

Create a custom context for isolated reactivity (e.g., a library using MobX internally that shouldn't share context with the host app):

```dart
final myContext = ReactiveContext(config: ReactiveConfig(
  writePolicy: ReactiveWritePolicy.always,
));

final counter = Observable(0, context: myContext);
```

## ReactiveConfig

```dart
ReactiveConfig({
  bool disableErrorBoundaries = false,
  ReactiveWritePolicy writePolicy = ReactiveWritePolicy.observed,
  ReactiveReadPolicy readPolicy = ReactiveReadPolicy.never,
  int maxIterations = 100,
})
```

### Write Policy

Controls enforcement of mutations inside actions:

| Policy | Behavior |
|---|---|
| `observed` (default) | Throws only if the mutated observable is currently being observed |
| `always` | Always requires mutations inside an action |
| `never` | No enforcement (discouraged) |

### Read Policy

Controls enforcement of reading observables inside reactive contexts:

| Policy | Behavior |
|---|---|
| `never` (default) | Reads allowed anywhere |
| `always` | Reads must happen inside an Action or Reaction |

### Error Boundaries

`disableErrorBoundaries: true` makes MobX not catch exceptions in reactions (useful for debugging). Default is `false` — MobX catches and logs unhandled exceptions.

### Max Iterations

`maxIterations` (default: 100) limits reaction cycles. If reactions keep triggering more reactions beyond this limit, MobX throws to prevent infinite loops from cyclical dependencies.

## Modifying mainContext

```dart
mainContext.config = mainContext.config.clone(
  writePolicy: ReactiveWritePolicy.always,
  isSpyEnabled: true,
);
```

<!--
Source references:
- https://mobx.netlify.app/api/context
-->
