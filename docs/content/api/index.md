# Choose an API by responsibility

Start with `Observable`, `Computed`, actions, and `Observer`. The larger public surface includes collection notifications, custom adapters, generated-code support, and diagnostic hooks. This guide separates their roles without hiding the advanced APIs.

| Family | Use it for | Explanation and examples |
| --- | --- | --- |
| `Observable`, `ObservableValue`, `Computed`, `EqualityComparer` | Facts and derived values | [Observables](/api/observable), [fundamentals](/learn/) |
| `Action`, `runInAction`, `transaction`, `untracked`, `AsyncAction` | Group writes or control tracking | [Actions](/api/action), [runtime boundaries](/api/advanced) |
| `autorun`, `reaction`, `when`, `asyncWhen`, `Reaction`, `ReactionDisposer` | Effects and their lifetimes | [Reactions](/api/reaction), [live example](/gallery/reactions) |
| `ObservableList`, `ObservableMap`, `ObservableSet` and change/listener types | Reactive collections and mutation records | [Collections](/api/collections) |
| `ObservableFuture`, `FutureStatus`, `ObservableStream`, `StreamStatus` | Async state | [Async ownership](/api/async) |
| `observable`, `computed`, `action`, `readonly`, `alwaysNotify`, `MakeObservable`, `ComputedMethod`, `StoreConfig`, `Store` | Generated store declarations | [Annotations and tooling](/api/tooling) |
| `Observer`, `ReactionBuilder`, `MultiReactionBuilder` | Flutter rendering and effects | [Flutter integration](/api/flutter) |
| `StatelessObserverWidget`, `StatefulObserverWidget`, observer element and widget mixins | Custom Flutter reactive widgets | [Flutter integration](/api/flutter) |
| `ReactiveContext`, `ReactiveConfig`, read/write policies, `createContext`, `mainContext` | Isolated runtimes and enforcement | [Context](/api/context), [advanced APIs](/api/advanced) |
| `Atom`, `AtomSpyReporter`, `Derivation`, `ActionController`, `ActionRunInfo`, `ConditionalAction` | Adapters and generated-code machinery | [Advanced APIs](/api/advanced), [internals](/development/reactivity) |
| `Listenable`, `Listener`, `Listeners`, `Interceptable`, `Interceptor`, `Interceptors`, change notifications | Low-level mutation observation and interception | [Advanced APIs](/api/advanced) |
| `SpyEvent` and its subclasses, `SpyListener`, `ReactionErrorHandler`, exception types | Diagnostics and error reporting | [Spy](/api/spy), [advanced APIs](/api/advanced) |
| Primitive, collection, future, and stream extensions | Concise wrapping and operators | [Extensions](/api/extensions) |
| `StoreGenerator`, build configuration, package `version` values | Tooling and package identification | [Tooling](/api/tooling) |

## Complete local reference

The following pages are generated from this checkout's resolved exports. They include every exported declaration and its declared public members, including constructors and options. Standard inherited methods retain their Dart/Flutter contracts.

- [mobx public declarations and members](/api/mobx-public)
- [flutter_mobx public declarations and members](/api/flutter_mobx-public)
- [mobx_codegen public declarations and members](/api/mobx_codegen-public)

`dart run tool/docs_inventory.dart --check` fails when the inventory differs from the code. `node docs/scripts/api-reference.mjs` renders that inventory into the reference. This is a coverage guard, not a substitute for reviewing whether prose and examples teach an API well.

- [mobx_lint plugin entry point](/api/mobx_lint-public)
