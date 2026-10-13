# Think in connected state

Store facts once. Describe everything you can derive from them. Let MobX discover which facts each consumer reads.

A shopping cart contains quantities and prices. Its subtotal, item count, and shipping eligibility are relationships, not additional state to synchronize. MobX keeps those relationships current without a list of manual subscriptions.

## Start with three pieces

```dart
import 'package:mobx/mobx.dart';

final quantity = Observable(1);                       // A fact
final total = Computed(() => quantity.value * 24);   // A relationship
final dispose = autorun((_) => print(total.value));  // A consumer
runInAction(() => quantity.value++);                // An intentional change
dispose();                                         // End the consumer's lifetime
```

An **observable** reports reads and changes. A **computed** expresses a pure derived value. An **action** groups writes into an operation. A **reaction**, including Flutter's `Observer`, consumes observable values. The triad is state, actions, and reactions; computeds keep state relationships declarative.

## Follow the learning path

| Step | Learn | Run it |
| --- | --- | --- |
| 1 | Observable reads, actions, and small `Observer` builders | [Counter](/gallery/counter) |
| 2 | Derive values instead of copying them | [Connected cart](/gallery/cart) |
| 3 | Track collection structure and derived filters | [Tasks](/gallery/tasks), [inventory](/gallery/collections) |
| 4 | Model pending, error, value, and completion explicitly | [Futures](/gallery/async), [streams](/gallery/stream) |
| 5 | Own and dispose side effects | [Reactions](/gallery/reactions) |
| 6 | Understand conditional tracking | [Dependencies](/gallery/dependencies) |
| 7 | Place stores, services, and features deliberately | [Application architecture](/learn/architecture) |
| 8 | Follow an observable read through the runtime | [Inside MobX](/development/reactivity) |

## Tracking is synchronous and specific

MobX tracks observable reads made during the tracked function, including ordinary synchronous helper calls. It does not watch every value reachable from an object. Reading a plain object's field does not make that field observable. A callback that executes later, after the builder returns or after an `await`, is outside that tracking pass.

```dart
Observer(builder: (_) {
  final title = store.title; // Read inside the tracked builder.
  return Text(title);
});
```

If a branch stops reading an observable, MobX removes that dependency after the run. [Try switching branches](/gallery/dependencies) to see the difference between a changed value and a changed dependency.

## Move to generated stores

Manual `Observable` wrappers make the mechanics visible. Annotations remove that wrapper syntax as a store grows:

```dart
import 'package:mobx/mobx.dart';
part 'cart.g.dart';

class Cart = CartBase with _$Cart;
abstract class CartBase with Store {
  @observable
  int quantity = 1;

  @computed
  int get total => quantity * 24;

  @action
  void add() => quantity++;
}
```

Run `dart run build_runner build --delete-conflicting-outputs` after changing annotated declarations. Generated accessors call the same runtime primitives as manual observables. See [annotations and tooling](/api/tooling) for read-only fields, equality, and generator configuration.

## Make the next decision deliberately

Use a computed for a value. Use a reaction for an external effect. Use an action for a state transition. Start with one store per cohesive feature, then share domain state when two features truly need the same facts. You do not need a global store, an event bus, or manual dependency registration to begin.
