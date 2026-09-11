---
title: flutter_mobx public API
outline: 2
---

# flutter_mobx public API

This reference is generated from the resolved exports of `package:flutter_mobx/flutter_mobx.dart`, including export filters and explicitly declared public members. Inherited Dart and Flutter members follow their platform contracts. Start with the [learning path](/learn/) for guided examples, or [API families](/api/) to choose the right abstraction. Low-level exports support adapters and generated code; exporting a symbol does not make it the best starting point for an application.

## MultiReactionBuilder

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
class MultiReactionBuilder extends MultiProvider
```

{@template multi_reaction_builder}
Merges multiple [ReactionBuilder] widgets into one widget tree.

[MultiReactionBuilder] improves the readability and eliminates the need
to nest multiple [ReactionBuilder]s.

By using [MultiReactionBuilder] we can go from:

```dart
ReactionBuilder(
  builder: (context) {},
  child: ReactionBuilder(
    builder: (context) {},
    child: ReactionBuilder(
      builder: (context) {},
      child: ChildA(),
    ),
  ),
)
```

to:

```dart
MultiReactionBuilder(
  builders: [
    ReactionBuilder(
      builder: (context) {},
    ),
    ReactionBuilder(
      builder: (context) {},
    ),
    ReactionBuilder(
      builder: (context) {},
    ),
  ],
  child: ChildA(),
)
```

[MultiReactionBuilder] converts the [ReactionBuilder] list into a tree of nested
[ReactionBuilder] widgets.
As a result, the only advantage of using [MultiReactionBuilder] is improved
readability due to the reduction in nesting and boilerplate.
{@endtemplate}

### MultiReactionBuilder

```dart
MultiReactionBuilder({Key? key, required List<ReactionBuilder> builders, required Widget child})
```

{@macro multi_reaction_builder}

## Observer

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
class Observer extends StatelessObserverWidget
```

A [StatelessObserverWidget] that delegate its [build] method to [builder].

See also:

- [Builder], which is the same thing but for [StatelessWidget] instead.

### Observer

```dart
Observer({Key? key, required Widget Function(BuildContext) builder, String? name, bool? warnWhenNoObservables})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### Observer.withBuiltChild

```dart
Observer.withBuiltChild({Key? key, required Widget Function(BuildContext, Widget) builder, required Widget child, String? name, bool? warnWhenNoObservables})
```

Observer which excludes the child branch from being rebuilt

- [builder] is a builder function with a child widget as a parameter;

- [child] is the widget to pass to the [builder] function.

### builder

```dart
Widget Function(BuildContext) builder
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### debugConstructingStackFrame

```dart
String? debugConstructingStackFrame
```

The stack frame pointing to the source that constructed this instance.

### builder

```dart
Widget Function(BuildContext) get builder
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### debugConstructingStackFrame

```dart
String? get debugConstructingStackFrame
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### getName

```dart
String getName()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### build

```dart
Widget build(BuildContext context)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### debugFindConstructingStackFrame

```dart
String? debugFindConstructingStackFrame([StackTrace? stackTrace])
```

Finds the first non-constructor frame in the stack trace.

[stackTrace] defaults to [StackTrace.current].

## ObserverElementMixin

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
mixin ObserverElementMixin on ComponentElement
```

A mixin that overrides [build] to listen to the observables used by
[ObserverWidgetMixin].

### reaction

```dart
ReactionImpl reaction
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### reaction

```dart
ReactionImpl get reaction
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### mount

```dart
void mount(Element? parent, dynamic newSlot)
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### invalidate

```dart
void invalidate()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### build

```dart
Widget build()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### unmount

```dart
void unmount()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ObserverWidgetMixin

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
mixin ObserverWidgetMixin on Widget
```

Observer observes the observables used in the `build` method and rebuilds
the Widget whenever any of them change. There is no need to do any other
wiring besides simply referencing the required observables.

Internally, [ObserverWidgetMixin] uses a [Reaction] around the `build`
method.

If your `build` method does not contain any observables,
[ObserverWidgetMixin] will print a warning on the console. This is a
debug-time hint to let you know that you are not observing any observables.

### warnWhenNoObservables

```dart
bool? warnWhenNoObservables
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### warnWhenNoObservables

```dart
bool? get warnWhenNoObservables
```

Whether to warn when there is no observables in the builder function
null means true

### getName

```dart
String getName()
```

An identifiable name that can be overriden for debugging.

### getContext

```dart
ReactiveContext getContext()
```

The context within which its reaction should be run. It is the
[mainContext] in most cases.

### createReaction

```dart
Reaction createReaction(dynamic Function() onInvalidate, {dynamic Function(Object, Reaction)? onError})
```

A convenience method used for testing.

### log

```dart
void log(String msg)
```

Convenience method to output console messages as debugging output. Logging
usually happens when some internal error needs to be surfaced to the user.

## ReactionBuilder

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
class ReactionBuilder extends SingleChildStatefulWidget
```

ReactionBuilder is useful for triggering reactions via a builder function rather
than creating a custom StatefulWidget for handling the same.
Without a [ReactionBuilder] you would normally have to create a StatefulWidget
where the `initState()` would be used to setup the reaction and then dispose it off
in the `dispose()` method.

Although simple, this little helper Widget eliminates the need to create such a
widget and handles the lifetime of the reaction correctly. To use it, pass a
[builder] that takes in a [BuildContext] and prepares the reaction. It should
end up returning a [ReactionDisposer]. This will be disposed when the [ReactionBuilder]
is disposed. The [child] Widget gets rendered as part of the build process.

### ReactionBuilder

```dart
ReactionBuilder({Key? key, Widget? child, required ReactionDisposer Function(BuildContext) builder})
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### builder

```dart
ReactionDisposer Function(BuildContext) builder
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### builder

```dart
ReactionDisposer Function(BuildContext) get builder
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### createState

```dart
ReactionBuilderState createState()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## ReactionBuilderFunction

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
typedef ReactionBuilderFunction = ReactionDisposer Function(BuildContext)
```

A builder function that creates a reaction

## StatefulObserverElement

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
class StatefulObserverElement extends StatefulElement with ObserverElementMixin
```

An [Element] that uses a [StatefulObserverWidget] as its configuration.

### StatefulObserverElement

```dart
StatefulObserverElement(StatefulObserverWidget widget)
```

Creates an element that uses the given widget as its configuration.

### widget

```dart
StatefulObserverWidget widget
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### widget

```dart
StatefulObserverWidget get widget
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## StatefulObserverWidget

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
abstract class StatefulObserverWidget extends StatefulWidget with ObserverWidgetMixin
```

A [StatefulWidget] that rebuilds when an [Observable] used inside
[State.build] updates.

See also:

- [Observer], which subclass this interface and delegate its `build` to a
  callback.
- [StatelessObserverWidget], similar to this class, but with no [State].

### StatefulObserverWidget

```dart
StatefulObserverWidget({Key? key, ReactiveContext? context, String? name})
```

Initializes [key], [context] and [name] for subclasses.

### getName

```dart
String getName()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### getContext

```dart
ReactiveContext getContext()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### createElement

```dart
StatefulObserverElement createElement()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## StatelessObserverElement

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
class StatelessObserverElement extends StatelessElement with ObserverElementMixin
```

An [Element] that uses a [StatelessObserverWidget] as its configuration.

### StatelessObserverElement

```dart
StatelessObserverElement(StatelessObserverWidget widget)
```

Creates an element that uses the given widget as its configuration.

### widget

```dart
StatelessObserverWidget widget
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### widget

```dart
StatelessObserverWidget get widget
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## StatelessObserverWidget

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
abstract class StatelessObserverWidget extends StatelessWidget with ObserverWidgetMixin
```

A [StatelessWidget] that rebuilds when an [Observable] used inside [build]
updates.

See also:

- [Observer], which subclass this interface and delegate its [build]
  to a callback.
- [StatefulObserverWidget], similar to this class, but that has a [State].

### StatelessObserverWidget

```dart
StatelessObserverWidget({Key? key, ReactiveContext? context, String? name, bool? warnWhenNoObservables})
```

Initializes [key], [context] and [name] for subclasses.

### warnWhenNoObservables

```dart
bool? warnWhenNoObservables
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### warnWhenNoObservables

```dart
bool? get warnWhenNoObservables
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### getName

```dart
String getName()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### getContext

```dart
ReactiveContext getContext()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

### createElement

```dart
StatelessObserverElement createElement()
```

Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.

## debugAddStackTraceInObserverName

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
bool get debugAddStackTraceInObserverName
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## debugAddStackTraceInObserverName setter

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
set debugAddStackTraceInObserverName(bool value)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## enableWarnWhenNoObservables

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
bool get enableWarnWhenNoObservables
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## enableWarnWhenNoObservables setter

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
set enableWarnWhenNoObservables(bool value)
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

## version

Import: `package:flutter_mobx/flutter_mobx.dart`

```dart
String get version
```

See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.

