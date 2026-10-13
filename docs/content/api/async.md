# Futures and streams have observable state

Use async wrappers to expose an operation's progress. Keep ownership and cancellation explicit: wrapping an operation does not transfer ownership of its network request, timer, or subscription.

## Observe a future

```dart
final request = ObservableFuture(Future.value(['A', 'B']));
final stop = autorun((_) {
  switch (request.status) {
    case FutureStatus.pending: print('Loading');
    case FutureStatus.fulfilled: print(request.value);
    case FutureStatus.rejected: print(request.error);
  }
});
await request;
stop();
```

`status`, `value`, `error`, and `result` describe the current outcome. `match` maps the outcome through callbacks; omitted callbacks can produce null. `ObservableFuture.value` and `.error` construct already-settled wrappers. The `Future` methods (`then`, `catchError`, `whenComplete`, and others) retain their future contracts: handle failures in chains you create, including chains returned by cleanup callbacks.

Store a replaceable request in an observable field when the UI must follow a new request instance. If requests can overlap, choose a policy: ignore while pending, replace with latest, queue, or cancel. The [project example](/gallery/async) ignores duplicate loads while pending and lets you trigger a rejected response.

## Observe a stream

```dart
final values = ObservableStream<int>(source, initialValue: 0);
final stop = autorun((_) => print('${values.status}: ${values.value}'));
// When the observation is no longer needed:
stop();
```

Here `source` is a `Stream<int>` owned by your service. `StreamStatus` is `waiting`, `active`, or `done`; `hasError` and `error` distinguish an error event from a value. A null value can be valid for nullable streams, so do not infer status from `value == null`. `match` supports waiting, active, error, and done callbacks.

Single-subscription and broadcast sources retain their different subscription rules. An observable-only single-subscription stream pauses when observation ends; an explicit subscription has its own cancellation lifetime. Keep and cancel that subscription when you own it. Close controllers you create. `configure` produces a configured wrapper; do not use it to manufacture a second independent subscription to a single-subscription source.

With `cancelOnError: true`, the first error ends observation and publishes `done`. With the default `false`, a later value may recover from an error. Completion, empty streams, nullable values, and error stacks are distinct cases. [Send each event in the live stream example](/gallery/stream).

## Async actions are write boundaries

Generated async `@action` methods use `AsyncAction`. Its `run` method maintains action behavior in asynchronous continuations. It does not keep all observers frozen throughout a long request. Use a short `runInAction` when publishing several fields together after awaiting service work.

All participating observables and reactions must use the intended `ReactiveContext`. The [architecture guide](/learn/architecture) covers stale-result guards and disposal.
