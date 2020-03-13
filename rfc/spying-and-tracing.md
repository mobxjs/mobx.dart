# Spying and Tracing

This feature adds the ability to expose the inner workings of MobX. It will report over console logs or DDT about the various activities happening inside MobX. This includes:

- When observables are read and written
- When actions are invoked
- When reactions are triggered

## Benefits

MobX so far has been somewhat of a black-box, nicely hiding all the details of how its reactive system works internally. Some users have seen this as "too much magic" and not sure of how/why things work. The problem exacerbates when you have runtime exceptions. The amount of detail exposed on the error may not be enough. It also lacks the complete trace of events that led to the failure.

Spying/Tracing will expose all these details and make it clear as to what is happening inside MobX. To generalize, we feel this feature would do the following:

- Give better visibility of MobX internals
- Enable better developer experience while debugging

## Implementation Strategy

Changes will be required in `mobx` and `mobx_codegen` packages. We are modeling the strategy around the way its done in **mobx.js**.

### `mobx` changes

- Create the `spy(listener)` function that will attach a spy. The return value is a function that can dispose the spy.

```dart
enum SpyEventType {
  observable, action, reaction
}
class SpyEvent {
  SpyEvent(this.type, this.object, {this.name, this.isStart, this.isEnd});

  final dynamic object;
  final SpyEventType type;
  final String name;

  final bool isStart;
  final bool isEnd;
}

typedef Dispose = void Function();
typedef SpyListener = void Function(SpyEvent event);

Dispose spy(SpyListener listener);
```

- A `spyReport(event)` function is needed to report a specific activity
- Some activities like actions / reactions, are transactional and have a distinct begin-end semantics. For those we will need a `spyReportStart(event)` and `spyReportEnd(event)` functions.

### `mobx_codegen` changes

WIP
