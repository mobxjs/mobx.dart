---
title: mobx public API
outline: 2
---

# mobx public API

This reference is generated from the resolved exports of `package:mobx/mobx.dart`, including export filters and explicitly declared public members. Inherited Dart and Flutter members follow their platform contracts. Start with the [learning path](/learn/) for guided examples, or [API families](/api/) to choose the right abstraction. Low-level exports support adapters and generated code; exporting a symbol does not make it the best starting point for an application.

## Action

Import: `package:mobx/mobx.dart`

```dart
class Action with DebugCreationStack
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Action

```dart
Action(Function fn, {ReactiveContext? context, String? name})
```

Creates an action that encapsulates all the mutations happening on the
observables.

Wrapping mutations inside an action ensures the depending observers
are only notified when the action completes. This is useful to silent the notifications
when several observables are being changed together. You will want to run your
reactions only when all the mutations complete. This also helps in keeping
the state of your application consistent.

You can give a debug-friendly [name] to identify the action.

```dart
var x = Observable(10);
var y = Observable(20);
var total = Observable(0);

autorun((){
  print('x = ${x}, y = ${y}, total = ${total}');
});

var totalUp = Action((){
  x.value++;
  y.value++;

  total.value = x.value + y.value;
}, name: 'adder');
```
Even though we are changing 3 observables (`x`, `y` and `total`), the [autorun()]
is only executed once. This is the benefit of action. It batches up all the change
notifications and propagates them only after the completion of the action. Actions
can also be nested inside, in which case the change notification will propagate when
the top-level action completes.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### call

```dart
dynamic call([List<dynamic> args = const [], Map<String, dynamic>? namedArgs])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ActionController

Import: `package:mobx/mobx.dart`

```dart
class ActionController
```

`ActionController` is used to define the start/end boundaries of code which
should be wrapped inside an action. This ensures all observable mutations are neatly
encapsulated.

You would rarely need to use this directly. This is primarily meant for the **`mobx_codegen`** package.


### ActionController

```dart
ActionController({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### startAction

```dart
ActionRunInfo startAction({String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### endAction

```dart
void endAction(ActionRunInfo info)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ActionRunInfo

Import: `package:mobx/mobx.dart`

```dart
class ActionRunInfo
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ActionRunInfo

```dart
ActionRunInfo({required String name, DateTime? startTime, Derivation? prevDerivation, bool prevAllowStateChanges = true})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### prevDerivation

```dart
Derivation? prevDerivation
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### prevAllowStateChanges

```dart
bool prevAllowStateChanges
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### startTime

```dart
DateTime? startTime
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### prevDerivation

```dart
Derivation? get prevDerivation
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### prevAllowStateChanges

```dart
bool get prevAllowStateChanges
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### startTime

```dart
DateTime? get startTime
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ActionSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class ActionSpyEvent extends SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ActionSpyEvent

```dart
ActionSpyEvent({required String name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## AsyncAction

Import: `package:mobx/mobx.dart`

```dart
class AsyncAction
```

AsyncAction uses a [Zone] to keep track of async operations like [Future], timers and other
kinds of micro-tasks.

You would rarely need to use this class directly. Instead, use the `@action` annotation along with
the `mobx_codegen` package.

### AsyncAction

```dart
AsyncAction(String name, {ReactiveContext? context})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### run

```dart
Future<R> run<R>(Future<R> Function() body)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Atom

Import: `package:mobx/mobx.dart`

```dart
class Atom with DebugCreationStack
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Atom

```dart
Atom({String? name, dynamic Function()? onObserved, dynamic Function()? onUnobserved, ReactiveContext? context})
```

Creates a simple Atom for tracking its usage in a reactive context. This is useful when
you don't need the value but instead a way of knowing when it becomes active and inactive
in a reaction.

Use the [onObserved] and [onUnobserved] handlers to know when the atom is active and inactive
respectively. Use a debug [name] to identify easily.

### context

```dart
ReactiveContext context
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isBeingObserved

```dart
bool isBeingObserved
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### hasObservers

```dart
bool hasObservers
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### context

```dart
ReactiveContext get context
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isBeingObserved

```dart
bool get isBeingObserved
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### hasObservers

```dart
bool get hasObservers
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reportObserved

```dart
void reportObserved()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reportChanged

```dart
void reportChanged()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### onBecomeObserved

```dart
void Function() onBecomeObserved(void Function() fn)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### onBecomeUnobserved

```dart
void Function() onBecomeUnobserved(void Function() fn)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## AtomSpyReporter

Import: `package:mobx/mobx.dart`

```dart
extension AtomSpyReporter on Atom
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### reportRead

```dart
void reportRead()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reportWrite

```dart
void reportWrite<T>(T newValue, T oldValue, void Function() setNewValue, {bool Function(T?, T?)? equals, bool? useDeepEquality})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## BoolExtension

Import: `package:mobx/mobx.dart`

```dart
extension BoolExtension on bool
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### obs

```dart
Observable<bool> obs({ReactiveContext? context, String? name})
```

turns a bool into Observable

## ChangeNotification

Import: `package:mobx/mobx.dart`

```dart
class ChangeNotification<T>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ChangeNotification

```dart
ChangeNotification<T>({OperationType? type, T? newValue, T? oldValue, dynamic object})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType? type
```

One of add | update | delete

### oldValue

```dart
T? oldValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
T? newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
dynamic object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType? get type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### oldValue

```dart
T? get oldValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
T? get newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
dynamic get object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
set newValue(T? value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
set object(dynamic value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Computed

Import: `package:mobx/mobx.dart`

```dart
class Computed<T> extends Atom implements Derivation, ObservableValue<T>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Computed

```dart
Computed<T>(T Function() fn, {String? name, ReactiveContext? context, bool Function(T?, T?)? equals, bool? keepAlive})
```

Creates a computed value with an optional [name].

The passed in function: [fn], is used to give back the computed value.
Computed values can depend on other observables and computed values!
This makes them both an *observable* and an *observer*.
Computed values are also referred to as _derived-values_ because they inherently _derive_ their
value from other observables. Don't underestimate the power of the **computed**.
They are possibly the most powerful observables in your application.

A computed's value is read with the `value` property.

It is possible to override equality comparison (when deciding whether to notify observers)
by providing an [equals] comparator.

[keepAlive]
This avoids suspending computed values when they are not being observed by anything.
Can potentially create memory leaks.

```dart
var x = Observable(10);
var y = Observable(10);
var total = Computed((){
  return x.value + y.value;
});

x.value = 100; // recomputes total
y.value = 100; // recomputes total again

print('total = ${total.value}'); // prints "total = 200"
```

A computed value is _cached_ and it recomputes only when the dependent observables actually
change. This makes them fast and you are free to use them throughout your application. Internally
MobX uses a 2-phase change propagation that ensures no unnecessary computations are performed.

### equals

```dart
bool Function(T?, T?)? equals
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### errorValue

```dart
MobXCaughtException? errorValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### equals

```dart
bool Function(T?, T?)? get equals
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### errorValue

```dart
MobXCaughtException? get errorValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T get value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### computeValue

```dart
T? computeValue({required bool track})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observe

```dart
void Function() observe(void Function(ChangeNotification<T>) handler, {bool? fireImmediately})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ComputedMethod

Import: `package:mobx/mobx.dart`

```dart
class ComputedMethod
```

Internal class only used for code-generation with `mobx_codegen`.

During code-generation, this type is detected to identify a `Computed`

### ComputedMethod

```dart
ComputedMethod({bool? keepAlive})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### keepAlive

```dart
bool? keepAlive
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### keepAlive

```dart
bool? get keepAlive
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ComputedValueSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class ComputedValueSpyEvent extends SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ComputedValueSpyEvent

```dart
ComputedValueSpyEvent(dynamic object, {required String name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ConditionalAction

Import: `package:mobx/mobx.dart`

```dart
extension ConditionalAction on ReactiveContext
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### conditionallyRunInAction

```dart
void conditionallyRunInAction(void Function() fn, Atom atom, {String? name, ActionController? actionController})
```

Only run within an action if outside a batch
[fn] is the function to execute. Optionally provide a debug-[name].

## Derivation

Import: `package:mobx/mobx.dart`

```dart
abstract class Derivation
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Derivation

```dart
Derivation()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### errorValue

```dart
MobXCaughtException? errorValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### errorValue

```dart
MobXCaughtException? get errorValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Dispose

Import: `package:mobx/mobx.dart`

```dart
typedef Dispose = void Function()
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## DoubleExtension

Import: `package:mobx/mobx.dart`

```dart
extension DoubleExtension on double
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### obs

```dart
Observable<double> obs({ReactiveContext? context, String? name})
```

turns a double into Observable

## EndedSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class EndedSpyEvent extends SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### EndedSpyEvent

```dart
EndedSpyEvent({required String type, required String name, Duration? duration})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## EqualityComparer

Import: `package:mobx/mobx.dart`

```dart
typedef EqualityComparer<in T> = bool Function(T?, T?)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## FutureStatus

Import: `package:mobx/mobx.dart`

```dart
enum FutureStatus
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### FutureStatus

```dart
FutureStatus()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### pending

```dart
FutureStatus pending
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### rejected

```dart
FutureStatus rejected
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### fulfilled

```dart
FutureStatus fulfilled
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<FutureStatus> values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### pending

```dart
FutureStatus get pending
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### rejected

```dart
FutureStatus get rejected
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### fulfilled

```dart
FutureStatus get fulfilled
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<FutureStatus> get values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## IntExtension

Import: `package:mobx/mobx.dart`

```dart
extension IntExtension on int
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### obs

```dart
Observable<int> obs({ReactiveContext? context, String? name})
```

turns an int into Observable

## Interceptable

Import: `package:mobx/mobx.dart`

```dart
abstract class Interceptable<T>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Interceptable

```dart
Interceptable<T>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### intercept

```dart
void Function() intercept(WillChangeNotification<T>? Function(WillChangeNotification<T>) interceptor)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Interceptor

Import: `package:mobx/mobx.dart`

```dart
typedef Interceptor<inout T> = WillChangeNotification<T>? Function(WillChangeNotification<T>)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## Interceptors

Import: `package:mobx/mobx.dart`

```dart
class Interceptors<T> extends NotificationHandlers<WillChangeNotification<T>>
```

Stores the intercept-handlers that have been attached to a specific Observable.

When `observableInstance.intercept(handler)` is invoked, the passed-in handler
is stored inside the `Interceptors&lt;T>`.
This is an internal class and should not be used directly.

### Interceptors

```dart
Interceptors<T>(ReactiveContext context)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### add

```dart
void Function() add(WillChangeNotification<T>? Function(WillChangeNotification<T>) handler)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### interceptChange

```dart
WillChangeNotification<T>? interceptChange(WillChangeNotification<T> change)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ListChange

Import: `package:mobx/mobx.dart`

```dart
class ListChange<T>
```

Stores the change related information when items was modified, added or removed from [list].

The [elementChanges] object stores change mappings for the indexes of changed elements.
The [rangeChanges] object stores mappings of the changed ranges to the indexes of the first
elements of this ranges.
These two objects cannot overlap (cannot contain the same indexes of changed elements), in
most cases only one of them will be defined.

### ListChange

```dart
ListChange<T>({required ObservableList<T> list, List<ElementChange<T>>? elementChanges, List<RangeChange<T>>? rangeChanges})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### list

```dart
ObservableList<T> list
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### elementChanges

```dart
List<ElementChange<T>>? elementChanges
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### rangeChanges

```dart
List<RangeChange<T>>? rangeChanges
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### list

```dart
ObservableList<T> get list
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### elementChanges

```dart
List<ElementChange<T>>? get elementChanges
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### rangeChanges

```dart
List<RangeChange<T>>? get rangeChanges
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ListChangeListener

Import: `package:mobx/mobx.dart`

```dart
typedef ListChangeListener<in TNotification> = void Function(ListChange<TNotification>)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## Listenable

Import: `package:mobx/mobx.dart`

```dart
abstract class Listenable<TNotification>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Listenable

```dart
Listenable<TNotification>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observe

```dart
void Function() observe(void Function(TNotification) listener, {bool fireImmediately = false})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Listener

Import: `package:mobx/mobx.dart`

```dart
typedef Listener<in TNotification> = void Function(TNotification)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## Listeners

Import: `package:mobx/mobx.dart`

```dart
class Listeners<TNotification> extends NotificationHandlers<TNotification>
```

Stores the handler functions that have been attached via [Observable.observe] method
This is an internal class and should not be used directly.

### Listeners

```dart
Listeners<TNotification>(ReactiveContext context)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### add

```dart
void Function() add(void Function(TNotification) handler)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### notifyListeners

```dart
void notifyListeners(TNotification change)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## MakeObservable

Import: `package:mobx/mobx.dart`

```dart
class MakeObservable
```

Internal class only used for code-generation with `mobx_codegen`.

During code-generation, this type is detected to identify an `Observable`
[readOnly] indicates that the field is only modifiable within the Store.
It is possible to override equality comparison of new values with [equals].
```dart

bool _alwaysNotEqual(_, __) => false;

@MakeObservable(equals: _alwaysNotEqual)
String alwaysNotifyObservable = 'hello';

bool _equals(oldValue, newValue) => oldValue == newValue;

@MakeObservable(equals: _equals)
String withEquals = 'world';
```

### MakeObservable

```dart
MakeObservable({bool readOnly = false, Function? equals, bool useDeepEquality = true})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### readOnly

```dart
bool readOnly
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### equals

```dart
Function? equals
```

A [Function] to use check whether the value of an observable has changed.

Must be a top-level or static [Function] that takes two arguments and
returns a [bool].
The arguments are the old value and the new value of the observable.
If the function returns `true`, the values are equal and no reaction is triggered.
If the function returns `false`, the value has changed and reactions are notified.
If no function is provided, the default behavior is to only trigger if
: `oldValue != newValue`.

### useDeepEquality

```dart
bool useDeepEquality
```

By default, MobX uses the `==` to compare the previous value. This is fine for
primitives, but for Iterable and Map, you may want to use a deep equality on collections. When
using deep equal, no reaction will occur if all elements are equal.

### readOnly

```dart
bool get readOnly
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### equals

```dart
Function? get equals
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### useDeepEquality

```dart
bool get useDeepEquality
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## MapChange

Import: `package:mobx/mobx.dart`

```dart
class MapChange<K, V>
```

Stores the information related to changes happening in an [ObservableMap]. This is
used when firing the change notifications to all the listeners

### MapChange

```dart
MapChange<K, V>({OperationType? type, K? key, V? newValue, V? oldValue, required ObservableMap<K, V> object})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType? type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### key

```dart
K? key
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
V? newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### oldValue

```dart
V? oldValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
ObservableMap<K, V> object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType? get type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### key

```dart
K? get key
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
V? get newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### oldValue

```dart
V? get oldValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
ObservableMap<K, V> get object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## MapChangeListener

Import: `package:mobx/mobx.dart`

```dart
typedef MapChangeListener<in K, in V> = void Function(MapChange<K, V>)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## MobXCaughtException

Import: `package:mobx/mobx.dart`

```dart
class MobXCaughtException extends MobXException
```

This captures the stack trace when user-land code throws an exception

### MobXCaughtException

```dart
MobXCaughtException(Object exception, {required StackTrace stackTrace})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### exception

```dart
Object exception
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### stackTrace

```dart
StackTrace? stackTrace
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### exception

```dart
Object get exception
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### stackTrace

```dart
StackTrace? get stackTrace
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## MobXCyclicReactionException

Import: `package:mobx/mobx.dart`

```dart
class MobXCyclicReactionException extends MobXException
```

This exception would be fired when an reaction has a cycle and does
not stabilize in [ReactiveConfig.maxIterations] iterations

### MobXCyclicReactionException

```dart
MobXCyclicReactionException(String message)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## MobXException

Import: `package:mobx/mobx.dart`

```dart
class MobXException extends Error implements Exception
```

An Exception class to capture MobX specific exceptions

### MobXException

```dart
MobXException(String message)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### message

```dart
String message
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### message

```dart
String get message
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### message

```dart
set message(String value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Observable

Import: `package:mobx/mobx.dart`

```dart
class Observable<T> extends Atom implements Interceptable<T>, Listenable<ChangeNotification<T>>, ObservableValue<T>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Observable

```dart
Observable<T>(T initialValue, {String? name, ReactiveContext? context, bool Function(T?, T?)? equals})
```

Create an observable value with an [initialValue] and an optional [name]

Observable values are tracked inside MobX. When a reaction uses them
they are implicitly added as a dependency of the reaction. When its value changes
the linked reaction is re-triggered.

An Observable's value is read with the `value` property.

It is possible to override equality comparison of new values with [equals].

```dart
var x = Observable(10);
var message = Observable('hello');

print('x = ${x.value}'); // read an Observable's value
```

### equals

```dart
bool Function(T?, T?)? equals
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableValue

```dart
T nonObservableValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### equals

```dart
bool Function(T?, T?)? get equals
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T get value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableValue

```dart
T get nonObservableValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
set value(T value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observe

```dart
void Function() observe(void Function(ChangeNotification<T>) listener, {bool fireImmediately = false})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### intercept

```dart
void Function() intercept(WillChangeNotification<T>? Function(WillChangeNotification<T>) interceptor)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableBoolExtension

Import: `package:mobx/mobx.dart`

```dart
extension ObservableBoolExtension on Observable<bool>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### toggle

```dart
void toggle()
```

lets you toggle the internal value of ObservableBool

## ObservableFuture

Import: `package:mobx/mobx.dart`

```dart
class ObservableFuture<T> implements Future<T>, ObservableValue<T?>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ObservableFuture

```dart
ObservableFuture<T>(Future<T> future, {ReactiveContext? context, String? name})
```

Create a new observable future that tracks the state of the provided future.

### ObservableFuture.value

```dart
ObservableFuture<T>.value(T value, {ReactiveContext? context, String? name})
```

Create a new future that is completed with a value.

[status] is immediately [FutureStatus.fulfilled].

### ObservableFuture.error

```dart
ObservableFuture<T>.error(Object error, {ReactiveContext? context, String? name})
```

Create a new future that is completed with an error.

[status] is immediately [FutureStatus.rejected].

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### status

```dart
FutureStatus status
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T? value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### error

```dart
dynamic error
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### result

```dart
dynamic result
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### status

```dart
FutureStatus get status
```

Observable status of this.

### value

```dart
T? get value
```

Value if this completed with a value.

Null otherwise.

### error

```dart
dynamic get error
```

Error value if this completed with an error

Null otherwise.

### result

```dart
dynamic get result
```

Error or value of this.

Null if this hasn't yet completed.

### match

```dart
R? match<R>({R Function(T)? fulfilled, R Function(dynamic)? rejected, R Function()? pending})
```

Maps the current state of this.

Returns null if a handler for the current state is not provided.

### replace

```dart
ObservableFuture<T> replace(Future<T> nextFuture)
```

Returns a new future that starts with the [status] and [result] of this.

The [status] and [result] changes when the provided future completes.
Useful when you don't want to clear the result of the previous operation while
executing the new operation.

### asStream

```dart
ObservableStream<T> asStream()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### catchError

```dart
ObservableFuture<T> catchError(Function onError, {bool Function(Object)? test})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### then

```dart
ObservableFuture<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### timeout

```dart
ObservableFuture<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### whenComplete

```dart
ObservableFuture<T> whenComplete(FutureOr<dynamic> Function() action)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableFutureExtension

Import: `package:mobx/mobx.dart`

```dart
extension ObservableFutureExtension<T> on Future<T>
```

Turn the Future into an ObservableFuture.

### asObservable

```dart
ObservableFuture<T> asObservable({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableList

Import: `package:mobx/mobx.dart`

```dart
class ObservableList<T> with ListBase<T> implements Listenable<ListChange<T>>
```

The ObservableList tracks the various read-methods (eg: [List.first], [List.last]) and
write-methods (eg: [List.add], [List.insert]) making it easier to use it inside reactions.

As the name suggests, this is the Observable-counterpart to the standard Dart `List&lt;T>`.

```dart
final list = ObservableList<int>.of([1]);

autorun((_) {
  print(list.first);
}) // prints 1

list[0] = 100; // autorun prints 100
```

### ObservableList

```dart
ObservableList<T>({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### ObservableList.of

```dart
ObservableList<T>.of(Iterable<T> elements, {ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableInner

```dart
List<T> nonObservableInner
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
int length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### iterator

```dart
Iterator<T> iterator
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### single

```dart
T single
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### first

```dart
T first
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableInner

```dart
List<T> get nonObservableInner
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

The name used to identify for debugging purposes

### length

```dart
int get length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### iterator

```dart
Iterator<T> get iterator
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### single

```dart
T get single
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
set length(int value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### first

```dart
set first(T value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### +

```dart
List<T> +(List<T> other)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### []

```dart
T [](int index)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### []=

```dart
void []=(int index, T value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### add

```dart
void add(T element)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### addAll

```dart
void addAll(Iterable<T> iterable)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### lastIndexWhere

```dart
int lastIndexWhere(bool Function(T) test, [int? start])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### lastWhere

```dart
T lastWhere(bool Function(T) test, {T Function()? orElse})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### sublist

```dart
List<T> sublist(int start, [int? end])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### asMap

```dart
Map<int, T> asMap()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### cast

```dart
List<R> cast<R>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toList

```dart
List<T> toList({bool growable = true})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### clear

```dart
void clear()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### fillRange

```dart
void fillRange(int start, int end, [T? fill])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### insert

```dart
void insert(int index, T element)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### insertAll

```dart
void insertAll(int index, Iterable<T> iterable)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### remove

```dart
bool remove(Object? element)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeAt

```dart
T removeAt(int index)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeLast

```dart
T removeLast()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeRange

```dart
void removeRange(int start, int end)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeWhere

```dart
void removeWhere(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### replaceRange

```dart
void replaceRange(int start, int end, Iterable<T> newContents)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### retainWhere

```dart
void retainWhere(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### setAll

```dart
void setAll(int index, Iterable<T> iterable)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### setRange

```dart
void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### shuffle

```dart
void shuffle([Random? random])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### sort

```dart
void sort([int Function(T, T)? compare])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observe

```dart
void Function() observe(void Function(ListChange<T>) listener, {bool fireImmediately = false})
```

Attach a [listener] to the changes happening in the list.

You can choose to receive the change notification immediately (with [fireImmediately])
or on the first change

## ObservableListExtension

Import: `package:mobx/mobx.dart`

```dart
extension ObservableListExtension<T> on List<T>
```

Turn the List into an ObservableList.

### asObservable

```dart
ObservableList<T> asObservable({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableMap

Import: `package:mobx/mobx.dart`

```dart
class ObservableMap<K, V> with MapBase<K, V> implements Listenable<MapChange<K, V>>
```

The ObservableMap tracks the various read-methods (eg: [Map.length], [Map.isEmpty]) and
write-methods (eg: [Map.[]=], [Map.clear]) making it easier to use it inside reactions.

As the name suggests, this is the Observable-counterpart to the standard Dart `Map&lt;K,V>`.

```dart
final map = ObservableMap<String, int>.of({'first': 1});

autorun((_) {
  print(map['first']);
}) // prints 1

map['first'] = 100; // autorun prints 100
```

### ObservableMap

```dart
ObservableMap<K, V>({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### ObservableMap.of

```dart
ObservableMap<K, V>.of(Map<K, V> other, {ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### ObservableMap.linkedHashMapFrom

```dart
ObservableMap<K, V>.linkedHashMapFrom(Map<K, V> other, {ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### ObservableMap.splayTreeMapFrom

```dart
ObservableMap<K, V>.splayTreeMapFrom(Map<K, V> other, {int Function(K, K)? compare, bool Function(dynamic)? isValidKey, ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableInner

```dart
Map<K, V> nonObservableInner
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### keys

```dart
Iterable<K> keys
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
int length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isNotEmpty

```dart
bool isNotEmpty
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isEmpty

```dart
bool isEmpty
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableInner

```dart
Map<K, V> get nonObservableInner
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### keys

```dart
Iterable<K> get keys
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
int get length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isNotEmpty

```dart
bool get isNotEmpty
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isEmpty

```dart
bool get isEmpty
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### []

```dart
V? [](Object? key)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### []=

```dart
void []=(K key, V value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### addAll

```dart
void addAll(Map<K, V> other)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### addEntries

```dart
void addEntries(Iterable<MapEntry<K, V>> newEntries)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### updateAll

```dart
void updateAll(V Function(K, V) update)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeWhere

```dart
void removeWhere(bool Function(K, V) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### clear

```dart
void clear()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### cast

```dart
Map<RK, RV> cast<RK, RV>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### remove

```dart
V? remove(Object? key)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### containsKey

```dart
bool containsKey(Object? key)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observe

```dart
void Function() observe(void Function(MapChange<K, V>) listener, {bool fireImmediately = false})
```

Used to attach a listener for getting notified on changes happening to the map

You can also choose to receive the notifications immediately (with [fireImmediately])

## ObservableMapExtension

Import: `package:mobx/mobx.dart`

```dart
extension ObservableMapExtension<K, V> on Map<K, V>
```

Turn the Map into an ObservableMap.

### asObservable

```dart
ObservableMap<K, V> asObservable({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableSet

Import: `package:mobx/mobx.dart`

```dart
class ObservableSet<T> with SetBase<T> implements Listenable<SetChange<T>>
```

ObservableSet provides a reactive set that notifies changes when a member is added or removed.

```dart
final set = ObservableSet.of([1, 2, 3]);

const disposer = autorun((_){
  print(set);
});

set.add(4); // prints {1, 2, 3, 4}

```

### ObservableSet

```dart
ObservableSet<T>({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### ObservableSet.of

```dart
ObservableSet<T>.of(Iterable<T> other, {ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### ObservableSet.splayTreeSetFrom

```dart
ObservableSet<T>.splayTreeSetFrom(Iterable<T> other, {int Function(T, T)? compare, bool Function(dynamic)? isValidKey, ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableInner

```dart
Set<T> nonObservableInner
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### iterator

```dart
Iterator<T> iterator
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
int length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nonObservableInner

```dart
Set<T> get nonObservableInner
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### iterator

```dart
Iterator<T> get iterator
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
int get length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### add

```dart
bool add(T value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### addAll

```dart
void addAll(Iterable<T> elements)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeAll

```dart
void removeAll(Iterable<Object?> elements)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### retainAll

```dart
void retainAll(Iterable<Object?> elements)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### removeWhere

```dart
void removeWhere(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### retainWhere

```dart
void retainWhere(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### contains

```dart
bool contains(Object? element)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### lookup

```dart
T? lookup(Object? element)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### remove

```dart
bool remove(Object? value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### clear

```dart
void clear()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### cast

```dart
Set<R> cast<R>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toSet

```dart
Set<T> toSet()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observe

```dart
void Function() observe(void Function(SetChange<T>) listener, {bool fireImmediately = false})
```

Attaches a listener to changes happening in the [ObservableSet]. You have
the option to be notified immediately ([fireImmediately]) or wait for until the first change.

## ObservableSetExtension

Import: `package:mobx/mobx.dart`

```dart
extension ObservableSetExtension<T> on Set<T>
```

Turn the Set into an ObservableSet.

### asObservable

```dart
ObservableSet<T> asObservable({ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableStream

Import: `package:mobx/mobx.dart`

```dart
class ObservableStream<T> implements Stream<T>, ObservableValue<T?>
```

Stream that tracks the emitted values of the provided stream and makes
them available as a MobX observable value.

The latest events emitted by the stream are captured an made available as
MobX observable values via properties such as [data], [value], [error],
[hasError] and [status].

If the source `stream` is a single-subscription stream, this stream will
also be single-subscription. Either calling [listen] or observing [value],
etc. in a reaction will start the stream. Both can be done at the same time.

If the observation ends, and a subscription was never created via [listen],
the stream will be paused. If a subscription (created via [listen]) is
cancelled, the stream ends, and [value] etc. can no longer be observed
inside a reaction.

If the source `stream` is a broadcast stream, this stream will also be a
broadcast stream. This means the observable stream can be listened to
multiple times.

### ObservableStream

```dart
ObservableStream<T>(Stream<T> stream, {T? initialValue, bool cancelOnError = false, ReactiveContext? context, String? name, bool Function(dynamic, dynamic)? equals})
```

Create a stream that tracks the emitted values of the provided stream and
makes them available as a MobX observable value.

If the source `stream` is a single-subscription stream, this stream will
also be single-subscription. If the source `stream` is a broadcast stream,
this stream will also be a broadcast stream.

If `initialValue` is provided, [value] will use it as the initial value
while waiting for the first item to be emitted from the source stream.
If the stream is a single-subscription stream, `initialValue` will also be
the first value emitted to the subscription created by [listen].

If `cancelOnError` is `true`, the stream will be cancelled when an error
event is emitted by the source stream. The observable status becomes
[StreamStatus.done] and downstream listeners receive the error followed
by done, unless their own subscription cancels on error. The default
value is `false`.

It is possible to override equality comparison of new values with [equals].

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### data

```dart
dynamic data
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T? value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### error

```dart
dynamic error
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### hasError

```dart
bool hasError
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### status

```dart
StreamStatus status
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### first

```dart
ObservableFuture<T> first
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isBroadcast

```dart
bool isBroadcast
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isEmpty

```dart
ObservableFuture<bool> isEmpty
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### last

```dart
ObservableFuture<T> last
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
ObservableFuture<int> length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### single

```dart
ObservableFuture<T> single
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### data

```dart
dynamic get data
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T? get value
```

Current value or null if waiting and no initialValue, or null if data is an error.

### error

```dart
dynamic get error
```

Current error or null if not failed.

### hasError

```dart
bool get hasError
```

Current data is an error.

### status

```dart
StreamStatus get status
```

Current stream status.

### first

```dart
ObservableFuture<T> get first
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isBroadcast

```dart
bool get isBroadcast
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isEmpty

```dart
ObservableFuture<bool> get isEmpty
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### last

```dart
ObservableFuture<T> get last
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### length

```dart
ObservableFuture<int> get length
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### single

```dart
ObservableFuture<T> get single
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### match

```dart
R? match<R>({R Function()? waiting, R Function(T)? active, R Function(dynamic)? error, R Function(T?, dynamic)? done})
```

Maps the current status and value or error into a value.

Returns null if a callback is not provided for the active status.
If [done] is null, [active] and [error] are used instead.

### configure

```dart
ObservableStream<T> configure({T? initialValue, bool cancelOnError = false})
```

Create a new stream with the provided initialValue and cancelOnError.

### close

```dart
Future<void> close()
```

Close the observable stream, and stop any future updates to observable
properties or any stream subscribers.

Most of the time, this method doesn't need to be called. ObservableStream
can clean-up automatically. This is always true if the original stream
is a broadcast stream.

However, if the original stream is a single-subscription stream and you
previously observed the stream's properties ([data], [value], [error],
[hasError], [status], etc.) but then stopped the observation (thereby
pausing the stream), then this method can be used to ensure the original
paused stream closes correctly.

Note that if you [listen] to this observable stream, the observable stream
will be closed automatically when you cancel the subscription.

### any

```dart
ObservableFuture<bool> any(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### asBroadcastStream

```dart
ObservableStream<T> asBroadcastStream({void Function(StreamSubscription<T>)? onListen, void Function(StreamSubscription<T>)? onCancel})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### asyncExpand

```dart
ObservableStream<E> asyncExpand<E>(Stream<E>? Function(T) convert)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### asyncMap

```dart
ObservableStream<E> asyncMap<E>(FutureOr<E> Function(T) convert)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### cast

```dart
ObservableStream<R> cast<R>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### contains

```dart
ObservableFuture<bool> contains(Object? needle)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### distinct

```dart
ObservableStream<T> distinct([bool Function(T, T)? equals])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### drain

```dart
ObservableFuture<E> drain<E>([E? futureValue])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### elementAt

```dart
ObservableFuture<T> elementAt(int index)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### every

```dart
ObservableFuture<bool> every(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### expand

```dart
ObservableStream<S> expand<S>(Iterable<S> Function(T) convert)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### firstWhere

```dart
ObservableFuture<T> firstWhere(bool Function(T) test, {T Function()? orElse})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### fold

```dart
ObservableFuture<S> fold<S>(S initialValue, S Function(S, T) combine)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### forEach

```dart
ObservableFuture<dynamic> forEach(void Function(T) action)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### handleError

```dart
ObservableStream<T> handleError(Function onError, {bool Function(dynamic)? test})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### join

```dart
ObservableFuture<String> join([String separator = ''])
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### lastWhere

```dart
ObservableFuture<T> lastWhere(bool Function(T) test, {T Function()? orElse})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### listen

```dart
StreamSubscription<T> listen(void Function(T)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### map

```dart
ObservableStream<S> map<S>(S Function(T) convert)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### pipe

```dart
ObservableFuture<dynamic> pipe(StreamConsumer<T> streamConsumer)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reduce

```dart
ObservableFuture<T> reduce(T Function(T, T) combine)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### singleWhere

```dart
ObservableFuture<T> singleWhere(bool Function(T) test, {T Function()? orElse})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### skip

```dart
ObservableStream<T> skip(int count)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### skipWhile

```dart
ObservableStream<T> skipWhile(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### take

```dart
ObservableStream<T> take(int count)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### takeWhile

```dart
ObservableStream<T> takeWhile(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### timeout

```dart
ObservableStream<T> timeout(Duration timeLimit, {void Function(EventSink<T>)? onTimeout})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toList

```dart
ObservableFuture<List<T>> toList()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toSet

```dart
ObservableFuture<Set<T>> toSet()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### transform

```dart
ObservableStream<S> transform<S>(StreamTransformer<T, S> streamTransformer)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### where

```dart
ObservableStream<T> where(bool Function(T) test)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableStreamExtension

Import: `package:mobx/mobx.dart`

```dart
extension ObservableStreamExtension<T> on Stream<T>
```

Turn the Stream into an ObservableStream.

### asObservable

```dart
ObservableStream<T> asObservable({T? initialValue, bool cancelOnError = false, ReactiveContext? context, String? name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableValue

Import: `package:mobx/mobx.dart`

```dart
abstract class ObservableValue<T>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ObservableValue

```dart
ObservableValue<T>()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T get value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObservableValueSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class ObservableValueSpyEvent extends SpyEvent
```

Used for reporting value changes on an Observable

### ObservableValueSpyEvent

```dart
ObservableValueSpyEvent(dynamic object, {dynamic newValue, dynamic oldValue, required String name, bool isEnd = false})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
dynamic newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### oldValue

```dart
dynamic oldValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
dynamic get newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### oldValue

```dart
dynamic get oldValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## OperationType

Import: `package:mobx/mobx.dart`

```dart
enum OperationType
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### OperationType

```dart
OperationType()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### add

```dart
OperationType add
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### update

```dart
OperationType update
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### remove

```dart
OperationType remove
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<OperationType> values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### add

```dart
OperationType get add
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### update

```dart
OperationType get update
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### remove

```dart
OperationType get remove
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<OperationType> get values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## Reaction

Import: `package:mobx/mobx.dart`

```dart
abstract class Reaction implements Derivation
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### Reaction

```dart
Reaction()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isDisposed

```dart
bool isDisposed
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### debugCreationStack

```dart
StackTrace? debugCreationStack
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isDisposed

```dart
bool get isDisposed
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### debugCreationStack

```dart
StackTrace? get debugCreationStack
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### dispose

```dart
void dispose()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactionDisposedSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class ReactionDisposedSpyEvent extends SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ReactionDisposedSpyEvent

```dart
ReactionDisposedSpyEvent({required String name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactionDisposer

Import: `package:mobx/mobx.dart`

```dart
class ReactionDisposer
```

A callable class that is used to dispose a [reaction], [autorun] or [when]

```dart
var dispose = autorun((){
  // ...
});

dispose(); // dispose the autorun()
```

In the above code, `dispose` is of type `ReactionDisposer`.

### ReactionDisposer

```dart
ReactionDisposer(Reaction reaction)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reaction

```dart
Reaction reaction
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reaction

```dart
Reaction get reaction
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### call

```dart
void call()
```

Invoking it will dispose the underlying [reaction]

## ReactionErrorHandler

Import: `package:mobx/mobx.dart`

```dart
typedef ReactionErrorHandler = void Function(Object, Reaction)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## ReactionErrorSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class ReactionErrorSpyEvent extends SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ReactionErrorSpyEvent

```dart
ReactionErrorSpyEvent(Object error, {required String name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### error

```dart
Object error
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### error

```dart
Object get error
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactionSpyEvent

Import: `package:mobx/mobx.dart`

```dart
class ReactionSpyEvent extends SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ReactionSpyEvent

```dart
ReactionSpyEvent({required String name})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactiveConfig

Import: `package:mobx/mobx.dart`

```dart
class ReactiveConfig
```

Configuration used by [ReactiveContext]

### ReactiveConfig

```dart
ReactiveConfig({bool disableErrorBoundaries = false, ReactiveWritePolicy writePolicy = ReactiveWritePolicy.observed, ReactiveReadPolicy readPolicy = ReactiveReadPolicy.never, int maxIterations = 100, bool isSpyEnabled = false})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### main

```dart
ReactiveConfig main
```

The main or default configuration used by [ReactiveContext]

### disableErrorBoundaries

```dart
bool disableErrorBoundaries
```

Whether MobX should throw exceptions instead of catching them and store
as [Derivation.errorValue].

### writePolicy

```dart
ReactiveWritePolicy writePolicy
```

Enforce mutation of observables inside an action

### readPolicy

```dart
ReactiveReadPolicy readPolicy
```

Enforce the use of reactions for reading observables

### maxIterations

```dart
int maxIterations
```

Max number of iterations before bailing out for a cyclic reaction

### isSpyEnabled

```dart
bool isSpyEnabled
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### main

```dart
ReactiveConfig get main
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### disableErrorBoundaries

```dart
bool get disableErrorBoundaries
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### writePolicy

```dart
ReactiveWritePolicy get writePolicy
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### readPolicy

```dart
ReactiveReadPolicy get readPolicy
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### maxIterations

```dart
int get maxIterations
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isSpyEnabled

```dart
bool get isSpyEnabled
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### clone

```dart
ReactiveConfig clone({bool? disableErrorBoundaries, ReactiveWritePolicy? writePolicy, ReactiveReadPolicy? readPolicy, int? maxIterations, bool? isSpyEnabled})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactiveContext

Import: `package:mobx/mobx.dart`

```dart
class ReactiveContext
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### ReactiveContext

```dart
ReactiveContext({ReactiveConfig? config})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### config

```dart
ReactiveConfig config
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nextId

```dart
int nextId
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isWithinBatch

```dart
bool isWithinBatch
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isSpyEnabled

```dart
bool isSpyEnabled
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### config

```dart
ReactiveConfig get config
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nextId

```dart
int get nextId
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isWithinBatch

```dart
bool get isWithinBatch
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isSpyEnabled

```dart
bool get isSpyEnabled
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### config

```dart
set config(ReactiveConfig newValue)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### nameFor

```dart
String nameFor(String prefix)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### spy

```dart
void Function() spy(void Function(SpyEvent) listener)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### spyReport

```dart
void spyReport(SpyEvent event)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### startBatch

```dart
void startBatch()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### endBatch

```dart
void endBatch()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### enforceReadPolicy

```dart
void enforceReadPolicy(Atom atom)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### enforceWritePolicy

```dart
void enforceWritePolicy(Atom atom)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### trackDerivation

```dart
T? trackDerivation<T>(Derivation d, T Function() fn)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reportObserved

```dart
void reportObserved(Atom atom)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### addPendingReaction

```dart
void addPendingReaction(Reaction reaction)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### runReactions

```dart
void runReactions()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### propagateChanged

```dart
void propagateChanged(Atom atom)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### clearObservables

```dart
void clearObservables(Derivation derivation)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isComputingDerivation

```dart
bool isComputingDerivation()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### startUntracked

```dart
Derivation? startUntracked()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### endUntracked

```dart
void endUntracked(Derivation? prevDerivation)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### untracked

```dart
T untracked<T>(T Function() fn)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### onReactionError

```dart
void Function() onReactionError(void Function(Object, Reaction) handler)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### startAllowStateChanges

```dart
bool startAllowStateChanges({bool allow = true})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### endAllowStateChanges

```dart
void endAllowStateChanges({bool allow = true})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### pushComputation

```dart
void pushComputation()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### popComputation

```dart
void popComputation()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactiveReadPolicy

Import: `package:mobx/mobx.dart`

```dart
enum ReactiveReadPolicy
```

Defines the behavior for observables read outside actions and reactions

`always`: If observables are read outside actions/reactions, throw an Exception
`never`: Allow unrestricted reading of observables everywhere. This is the default.

### ReactiveReadPolicy

```dart
ReactiveReadPolicy()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### always

```dart
ReactiveReadPolicy always
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### never

```dart
ReactiveReadPolicy never
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<ReactiveReadPolicy> values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### always

```dart
ReactiveReadPolicy get always
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### never

```dart
ReactiveReadPolicy get never
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<ReactiveReadPolicy> get values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactiveWritePolicy

Import: `package:mobx/mobx.dart`

```dart
enum ReactiveWritePolicy
```

Defines the behavior for observables mutated outside actions

`observed`: If there are observers for the mutated observable, then throw. Else allow mutation outside an action.
`always`: Always throw if an observable is mutated outside an action
`never`: Allow mutating observables outside actions

### ReactiveWritePolicy

```dart
ReactiveWritePolicy()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observed

```dart
ReactiveWritePolicy observed
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### always

```dart
ReactiveWritePolicy always
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### never

```dart
ReactiveWritePolicy never
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<ReactiveWritePolicy> values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### observed

```dart
ReactiveWritePolicy get observed
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### always

```dart
ReactiveWritePolicy get always
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### never

```dart
ReactiveWritePolicy get never
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<ReactiveWritePolicy> get values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## SetChange

Import: `package:mobx/mobx.dart`

```dart
class SetChange<T>
```

Capture the change related information for an [ ObservableSet]. This is used
as the notification instance.

### SetChange

```dart
SetChange<T>({required ObservableSet<T> object, required OperationType type, required T? value})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
ObservableSet<T> object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T? value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
ObservableSet<T> get object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType get type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### value

```dart
T? get value
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## SetChangeListener

Import: `package:mobx/mobx.dart`

```dart
typedef SetChangeListener<in T> = void Function(SetChange<T>)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## SpyEvent

Import: `package:mobx/mobx.dart`

```dart
abstract class SpyEvent
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### object

```dart
dynamic object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
String type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### duration

```dart
Duration? duration
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isStart

```dart
bool isStart
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isEnd

```dart
bool isEnd
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### sentinel

```dart
String sentinel
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
dynamic get object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### name

```dart
String get name
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
String get type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### duration

```dart
Duration? get duration
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isStart

```dart
bool get isStart
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### isEnd

```dart
bool get isEnd
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### sentinel

```dart
String get sentinel
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### toString

```dart
String toString()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## SpyListener

Import: `package:mobx/mobx.dart`

```dart
typedef SpyListener = void Function(SpyEvent)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## Store

Import: `package:mobx/mobx.dart`

```dart
mixin Store on Object
```

The `Store` mixin is primarily meant for code-generation and used as part of the
`mobx_codegen` package.

A class using this mixin is considered a MobX store and `mobx_codegen`
weaves the code needed to simplify the usage of MobX. It will detect annotations like
`@observables`, `@computed` and `@action` and generate the code needed to support these behaviors.

### context

```dart
ReactiveContext context
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### context

```dart
ReactiveContext get context
```

Override this method to use a custom context.

## StoreConfig

Import: `package:mobx/mobx.dart`

```dart
class StoreConfig
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### StoreConfig

```dart
StoreConfig({bool hasToString = true})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### hasToString

```dart
bool hasToString
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### hasToString

```dart
bool get hasToString
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## StreamStatus

Import: `package:mobx/mobx.dart`

```dart
enum StreamStatus
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### StreamStatus

```dart
StreamStatus()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### waiting

```dart
StreamStatus waiting
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### active

```dart
StreamStatus active
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### done

```dart
StreamStatus done
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<StreamStatus> values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### waiting

```dart
StreamStatus get waiting
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### active

```dart
StreamStatus get active
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### done

```dart
StreamStatus get done
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### values

```dart
List<StreamStatus> get values
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## StringExtension

Import: `package:mobx/mobx.dart`

```dart
extension StringExtension on String
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### obs

```dart
Observable<String> obs({ReactiveContext? context, String? name})
```

turns a String into Observable

## WillChangeNotification

Import: `package:mobx/mobx.dart`

```dart
class WillChangeNotification<T>
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

### WillChangeNotification

```dart
WillChangeNotification<T>({OperationType? type, T? newValue, dynamic object})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType? type
```

One of add | update | delete

### newValue

```dart
T? newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
dynamic object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### unchanged

```dart
WillChangeNotification<dynamic> unchanged
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### type

```dart
OperationType? get type
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
T? get newValue
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### object

```dart
dynamic get object
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### unchanged

```dart
WillChangeNotification<dynamic> get unchanged
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### newValue

```dart
set newValue(T? value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### unchanged

```dart
set unchanged(WillChangeNotification<dynamic> value)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## action

Import: `package:mobx/mobx.dart`

```dart
MakeAction get action
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## alwaysNotify

Import: `package:mobx/mobx.dart`

```dart
MakeObservable get alwaysNotify
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## asyncWhen

Import: `package:mobx/mobx.dart`

```dart
Future<void> asyncWhen(bool Function(Reaction) predicate, {String? name, int? timeout, ReactiveContext? context})
```

A variant of [when()] which returns a Future. The Future completes when the [predicate()] turns true.
Note that there is no effect function here. Typically you would await on the Future and execute the
effect after that.

```dart
await asyncWhen((_) => x.value > 10);
// ... execute the effect ...
```

## autorun

Import: `package:mobx/mobx.dart`

```dart
ReactionDisposer autorun(dynamic Function(Reaction) fn, {String? name, int? delay, ReactiveContext? context, Timer Function(void Function())? scheduler, void Function(Object, Reaction)? onError})
```

Executes the specified [fn], whenever the dependent observables change. It returns
a disposer that can be used to dispose the autorun.

Optional configuration:
* [name]: debug name for this reaction
* [delay]: Number of milliseconds that can be used to throttle the effect function. If zero (default), no throttling happens.
* [context]: the [ReactiveContext] to use. By default the [mainContext] is used.
* [scheduler]: Set a custom scheduler to determine how re-running the autorun function should be scheduled. It takes a function that should be invoked at some point in the future.
* [onError]: By default, any exception thrown inside an reaction will be logged, but not further thrown. This is to make sure that an exception in one reaction does not prevent the scheduled execution of other, possibly unrelated reactions. This also allows reactions to recover from exceptions. Throwing an exception does not break the tracking done by MobX, so subsequent runs of the reaction might complete normally again if the cause for the exception is removed. This option allows overriding that behavior. It is possible to set a global error handler or to disable catching errors completely using [ReactiveConfig].

```dart
var x = Observable(10);
var y = Observable(20);
var total = Observable(0);

var dispose = autorun((_){
  print('x = ${x}, y = ${y}, total = ${total}');
});

x.value = 20; // will cause autorun() to re-trigger.

dispose(); // This disposes the autorun() and will not be triggered again

x.value = 30; // Will not cause autorun() to re-trigger as it's disposed.
```

## computed

Import: `package:mobx/mobx.dart`

```dart
ComputedMethod get computed
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## createContext

Import: `package:mobx/mobx.dart`

```dart
ReactiveContext createContext({ReactiveConfig? config})
```

Create a new context for running actions and reactions.

You can use this to run a reactivity system in parallel to the [mainContext].
All actions, reactions will be run within this context. Make sure to pass
this context in calls to `autorun`, `reaction`, `when`, `action`, `observable`, etc.

Most of the time you should be fine with the [mainContext]

## mainContext

Import: `package:mobx/mobx.dart`

```dart
ReactiveContext get mainContext
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## observable

Import: `package:mobx/mobx.dart`

```dart
MakeObservable get observable
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## observableAlwaysNotEqual

Import: `package:mobx/mobx.dart`

```dart
bool observableAlwaysNotEqual(dynamic _, dynamic _)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## reaction

Import: `package:mobx/mobx.dart`

```dart
ReactionDisposer reaction<T>(T Function(Reaction) fn, void Function(T) effect, {String? name, int? delay, bool? fireImmediately, bool Function(T?, T?)? equals, ReactiveContext? context, Timer Function(void Function())? scheduler, void Function(Object, Reaction)? onError})
```

Executes the [fn] function and tracks the observables used in it. Returns
a function to dispose the reaction.

Optional configuration:
* [name]: debug name for this reaction
* [delay]: Number of milliseconds that can be used to throttle the effect function. If zero (default), no throttling happens.
* [context]: the [ReactiveContext] to use. By default the [mainContext] is used.
* [scheduler]: Set a custom scheduler to determine how re-running the autorun function should be scheduled. It takes a function that should be invoked at some point in the future.
* [onError]: By default, any exception thrown inside an reaction will be logged, but not further thrown. This is to make sure that an exception in one reaction does not prevent the scheduled execution of other, possibly unrelated reactions. This also allows reactions to recover from exceptions. Throwing an exception does not break the tracking done by MobX, so subsequent runs of the reaction might complete normally again if the cause for the exception is removed. This option allows overriding that behavior. It is possible to set a global error handler or to disable catching errors completely using [ReactiveConfig].

The [fn] is supposed to return a value of type T. When it changes, the
[effect] function is executed.

*Note*: Only the [fn] function is tracked and not the [effect].

You can also pass in an optional [name], a throttling [delay] in milliseconds. Use
[fireImmediately] if you want to invoke the effect immediately without waiting for
the [fn] to change its value. It is possible to define a custom [equals] function
to override the default comparison for the value returned by [fn], to have fined
grained control over when the reactions should run. By default, the [mainContext]
is used, but you can also pass in a custom [context].
You can also pass in an optional [onError] handler for errors thrown during the [fn] execution.
You can also pass in an optional [scheduler] to schedule the [effect] execution.

## readonly

Import: `package:mobx/mobx.dart`

```dart
MakeObservable get readonly
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## runInAction

Import: `package:mobx/mobx.dart`

```dart
T runInAction<T>(T Function() fn, {String? name, ReactiveContext? context})
```

Executes the mutation function [fn] within an `Action`. This ensures that all change notifications
are fired only at the end of the `Action` block. Note that actions can be nested, in which case
the notifications go out when the outermost `Action` completes.

Giving a [name] makes it easier to identify this action during debugging. You can also run this in a
custom [context]. By default the `mainContext` will be used.

## transaction

Import: `package:mobx/mobx.dart`

```dart
T transaction<T>(T Function() fn, {ReactiveContext? context})
```

During a transaction, no derivations ([Reaction] or [Computed]) will be run
and will be deferred until the end of the transaction (batch). Transactions can
be nested, in which case, no derivation will be run until the top-most batch completes

## untracked

Import: `package:mobx/mobx.dart`

```dart
T untracked<T>(T Function() fn, {ReactiveContext? context})
```

Untracked ensures there is no tracking derivation while the given action runs.
This is useful in cases where no observers should be linked to a running (tracking) derivation.

## version

Import: `package:mobx/mobx.dart`

```dart
String get version
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## when

Import: `package:mobx/mobx.dart`

```dart
ReactionDisposer when(bool Function(Reaction) predicate, void Function() effect, {String? name, ReactiveContext? context, int? timeout, void Function(Object, Reaction)? onError})
```

A one-time reaction that auto-disposes when the [predicate] becomes true. It also
executes the [effect] when the predicate turns true.

You can read it as: "*when* [predicate()] turns true, the [effect()] is executed."

Returns a function to dispose pre-maturely.

