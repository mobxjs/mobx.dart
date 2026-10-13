# Architect applications around ownership

A good MobX architecture makes it easy to answer: who owns this state, who can change it, and when does its work stop?

## Keep four responsibilities clear

| Responsibility | Owns | Does not need to own |
| --- | --- | --- |
| Repository or service | HTTP, persistence, stream sources, cancellation | Flutter widgets or reactive presentation flags |
| Domain or feature store | Observable facts, computed relationships, actions | Navigation or `BuildContext` |
| Feature coordinator | Cross-store commands, effects, lifetime | A second copy of each store's data |
| Widget | Layout and user intent, small `Observer` builders | Business rules duplicated from the store |

Inject repositories into stores and stores into their consumers. Provider is one option for providing instances; it does not replace MobX's dependency tracking. Create a store in an owner such as a route or application scope, not on every widget build.

## Share facts across features

A product page, cart badge, and checkout should read the same cart instance. Put `total` in a computed on that cart. Do not create reactions that copy quantity into three other stores.

```dart
class CheckoutStore {
  CheckoutStore(this.cart);
  final Cart cart;
  late final canCheckout = Computed(() => cart.quantity > 0);
  void clearCart() => runInAction(() => cart.quantity = 0);
}
```

This sketch uses the generated `Cart` from the [learning guide](/learn/). A parent owner constructs both instances and injects them. When a command updates several stores in the same context, put the entire command in one outer action so reactions see its final synchronous state.

## Derivation is not orchestration

Keep computeds deterministic and free of writes, I/O, and navigation. A reaction is appropriate for analytics, persistence, or a notification. Track only the value that should trigger the effect; reads inside a `reaction` effect are untracked.

```dart
final stopSaving = reaction<String>(
  (_) => settings.theme,
  (theme) => preferences.saveTheme(theme),
);
// Owner's dispose:
stopSaving();
```

The snippet assumes injected `settings` and `preferences`. If saving is asynchronous, decide ordering, error handling, and cancellation in the persistence layer. MobX does not serialize overlapping requests for you.

## Async state needs a request policy

`ObservableFuture` exposes a future's state; it does not cancel the underlying operation or make the latest request win. Use an operation ID for replaceable searches, and cancel the transport when supported:

```dart
int generation = 0;
Future<void> search(String query) async {
  final request = ++generation;
  final result = await repository.search(query);
  if (request != generation) return;
  runInAction(() => results = result);
}
void dispose() => generation++;
```

This pattern belongs in a store with injected `repository` and observable `results`; handle errors under the same generation check. Async actions allow writes in asynchronous continuations, but do not turn an entire `await` chain into one atomic transaction. Intermediate states can be visible between continuations.

## Dispose at the same level that creates

Route stores own route requests and subscriptions. App stores own long-lived sessions. Dispose reaction disposers, timer handles, subscriptions, and controllers when their owner ends. A computed normally releases dependencies when no longer observed; `keepAlive` changes that tradeoff and requires a deliberate lifetime plan.

Use `ReactionBuilder` or `MultiReactionBuilder` for effects whose lifetime is a widget subtree. Avoid constructing reactions directly inside `build`. See [Flutter integration](/api/flutter) and the [live disposal example](/gallery/reactions).

## Test relationships before pixels

Test actions and computeds using ordinary Dart tests. Attach a reaction when testing notification counts or retained computed caching. Use widget tests for `Observer` boundaries, replacement of store instances, and disposal. Use a controllable future or stream source for races, errors, and route exit; avoid timing tests that rely on a real network.

## Scale by dependency direction

Keep domain stores independent of widgets. Prefer a coordinator depending on two feature stores to those stores calling back into each other. A cycle in the object graph is not always a reactive cycle, but reactions that repeatedly write each other's inputs can fail to stabilize. The runtime's iteration limit diagnoses this; increasing it does not repair the architecture.
