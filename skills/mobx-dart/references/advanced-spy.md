---
name: advanced-spy
description: MobX Spy API for debugging, tracing reactive events, and inspecting observable/action/reaction activity
---

# Spy (Debugging)

Spy provides visibility into MobX internals by emitting events for all reactive activity.

## Setup

Enable spying and register a listener:

```dart
import 'package:mobx/mobx.dart';

void main() {
  mainContext.config = mainContext.config.clone(
    isSpyEnabled: true,  // must enable first
  );

  mainContext.spy(print);  // simple logging
  // or: mainContext.spy((event) { /* custom handling */ });

  runApp(MyApp());
}
```

`spy()` returns a `Dispose` function to stop listening.

## SpyEvent Types

| Event Class | What it captures |
|---|---|
| `ObservableValueSpyEvent` | Observable value changes (old/new value) |
| `ComputedValueSpyEvent` | Computed re-evaluations |
| `ReactionSpyEvent` | Reaction execution start |
| `ReactionErrorSpyEvent` | Errors inside reactions |
| `ReactionDisposedSpyEvent` | Reaction disposal |
| `ActionSpyEvent` | Action execution start |
| `EndedSpyEvent` | End of action/reaction/observable event |

## Example Output

For a counter increment:

```
action(START) _Counter.increment
observable(START) _Counter.value=1, previously=0
observable(END) _Counter.value
action(END after 1ms) _Counter.increment
reaction(START) Observer
reaction(END after 0ms) Observer
```

This trace shows: action fired -> observable updated -> Observer widget rebuilt.

## Use Cases

- Debugging why a reaction isn't firing
- Tracing the chain of events leading to a state change
- Integrating with external logging/monitoring tools
- Understanding execution order of nested actions and reactions

<!--
Source references:
- https://mobx.netlify.app/api/spy
-->
