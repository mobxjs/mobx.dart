# Runtime boundaries and adapter APIs

Use these APIs when building integrations, diagnosing behavior, or maintaining generated code. Application stores normally need only the higher-level primitives.

## Actions, transactions, and untracked work

`runInAction` and `Action` provide an action boundary: writes are allowed according to policy, tracking is suspended within the action, and dependent reactions flush after the outer batch ends. `transaction` groups notifications but is not a substitute for action write permissions. `untracked` prevents reads from becoming dependencies; it does not make writes transactional.

Always balance low-level `startBatch` / `endBatch` and tracking/policy push/pop operations in `try/finally`. Prefer the scoped helpers. An action is not rollback: if its body throws after a write, that write remains.

`ActionController`, `ActionRunInfo`, and `ConditionalAction` support generated wrappers and internal action bookkeeping. Avoid storing a run token for reuse across unrelated calls. `AsyncAction` owns its asynchronous execution context; it does not provide mutual exclusion.

## Build an observable adapter

An `Atom` is a dependency signal without its own application value:

```dart
class Reading {
  final atom = Atom(name: 'Reading');
  int _value = 0;
  int get value { atom.reportObserved(); return _value; }
  void update(int value) => runInAction(() {
    if (_value == value) return;
    _value = value;
    atom.reportChanged();
  });
}
```

Lifecycle hooks can start external observation when the atom becomes observed and stop it when unused. `AtomSpyReporter.reportRead` and `reportWrite` add policy/equality/spy integration used by generated accessors. A custom adapter must report every meaningful change and own external-resource cleanup.

`ObservableValue` is the read-only value contract implemented by observable values. `Derivation` is exposed for runtime integration but includes library-private machinery: it is not a convenient external subclassing API. Prefer `Computed` and reactions.

## Contexts are separate reactive runtimes

`mainContext` is the default. `createContext` and `ReactiveContext` allow isolated configuration. Construct observables, actions, and reactions with the same context; reading across contexts does not establish a reliable shared dependency graph.

`ReactiveConfig` configures read/write policies, reaction error boundaries, and the stabilization limit. `ReactiveReadPolicy` and `ReactiveWritePolicy` define enforcement choices. Context methods that manipulate tracking, pending reactions, or computation depth are runtime machinery; incorrect balancing can corrupt subsequent work.

## Notifications and interception

`Listenable`, `Listener`, and `Listeners` describe low-level observation. `Interceptable`, `Interceptor`, and `Interceptors` can inspect or replace a proposed change, or reject it by returning null where supported. `WillChangeNotification` represents a proposal; `ChangeNotification` represents the committed result, classified by `OperationType`.

```dart
final score = Observable(0);
final stop = score.intercept((change) => change.newValue! < 0 ? null : change);
runInAction(() => score.value = -1); // Rejected by the interceptor.
stop();
```

Use action-level validation for ordinary business rules. Interception is a lower-level mechanism with ordering and reentrancy consequences. Observe the committed value, not an assumption about the original proposal.

## Diagnostics have lifetimes too

`context.spy` returns a `Dispose` callback. `SpyListener` receives `SpyEvent` subclasses for action, observable, computed, reaction, disposal, error, and end events. Enable this only when needed: event construction and serialization add work.

```dart
final stop = mainContext.spy((event) => print(event.type));
// Perform the operation being diagnosed.
stop();
```

`onReactionError` installs a `ReactionErrorHandler` and returns a disposer. Per-reaction `onError` can handle local errors. `MobXCaughtException` retains an original exception and stack; `MobXCyclicReactionException` identifies a graph that did not stabilize; `MobXException` is the common error type. Reporting errors must not itself create a write loop.

`Reaction` exposes tracking and lifecycle functionality for adapters; `ReactionDisposer` is the callable owner handle returned by effect helpers. Dispose it once its owner is finished. Use `when` for a cancellable one-shot effect, and `asyncWhen` for awaiting a condition with an appropriate timeout.
