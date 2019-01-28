# mobx.dart

[![pub package](https://img.shields.io/pub/v/mobx.svg)](https://pub.dartlang.org/packages/mobx)
[![Build Status](https://travis-ci.com/mobxjs/mobx.dart.svg?branch=master)](https://travis-ci.com/mobxjs/mobx.dart)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)
[![Join the chat at https://gitter.im/mobxjs/mobx.dart](https://badges.gitter.im/mobxjs/mobx.dart.svg)](https://gitter.im/mobxjs/mobx.dart?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

![](mobx/doc/mobx.png)

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

## Introduction

MobX is a state-management library that makes it simple to connect the
reactive data of your application with the UI. This wiring is completely automatic
and feels very natural. As the application-developer, you focus purely on what reactive-data
needs to be consumed in the UI (and elsewhere) without worrying about keeping the two
in sync.

It's not really magic but it does have some smarts around what is being consumed (**observables**)
and where (**reactions**), and automatically tracks it for you. When the _observables_
change, all _reactions_ are re-run. What's interesting is that these reactions can be anything from a simple
console log, a network call to re-rendering the UI.

> MobX has been a very effective library for the JavaScript
> apps and this port to the Dart language aims to bring the same levels of productivity.

### Go deep

For a deeper coverage of MobX, do check out [MobX Quick Start Guide](https://www.packtpub.com/web-development/mobx-quick-start-guide). Although the book uses the JavaScript version of MobX, the concepts are **100% applicable** to Dart and Flutter.

<a href="https://www.packtpub.com/web-development/mobx-quick-start-guide"><img src="mobx/doc/book.png" height="128"></a>

## Core Concepts

![MobX Triad](mobx/doc/mobx-triad.png)

At the heart of MobX are three important concepts: **Observables**, **Actions** and **Reactions**.

### Observables

Observables represent the reactive-state of your application. They can be simple scalars to complex object trees. By
defining the state of the application as a tree of observables, you can expose a _reactive-state-tree_ that the UI
(or other observers in the app) consume.

A simple reactive-counter is represented by the following observable:

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

More complex observables, such as classes, can be created as well.

```dart
class Counter {
  Counter() {
    increment = Action(_increment);
  }

  final _value = Observable(0);
  int get value => _value.value;

  set value(int newValue) => _value.value = newValue;
  Action increment;

  void _increment() {
    _value.value++;
  }
}

```

On first sight, this does look like some boilerplate code which can quickly go out of hand!
This is why we added [mobx_codegen](mobx_codegen) to the mix that allows you to replace the above code with the following:

```dart
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = CounterBase with _$Counter;

abstract class CounterBase implements Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}

```

Note the use of annotations to mark the observable properties of the class. Yes, there is some header boilerplate here
but its fixed for any class. As you build more complex classes this boilerplate
will fade away and you will mostly focus on the code within the braces.

**Note**: Annotations are available via the [mobx_codegen](mobx_codegen) package.

### Actions

Actions are how you mutate the observables. Rather than mutating them directly, actions
add a semantic meaning to the mutations. For example, instead of just doing `value++`,
firing an `increment()` action carries more meaning. Besides, actions also batch up
all the notifications and ensure the changes are notified only after they complete.
Thus the observers are notified only upon the atomic completion of the action.

Note that actions can also be nested, in which case the notifications go out
when the top-most action has completed.

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

When creating actions inside a class, you can take advantage of annotations!

```dart
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = CounterBase with _$Counter;

abstract class CounterBase implements Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}

```

### Reactions

Reactions complete the _MobX triad_ of **observables**, **actions** and **reactions**. They are
the observers of the reactive-system and get notified whenever an observable they
track is changed. Reactions come in few flavors as listed below. All of them
return a `ReactionDisposer`, a function that can be called to dispose the reaction.

**`ReactionDisposer autorun(Function(Reaction) fn)`**

Runs the reaction immediately and also on any change in the observables used inside
`fn`.

**`ReactionDisposer reaction<T>(T Function(Reaction) predicate, void Function(T) effect)`**

Monitors the observables used inside the `predicate()` function and runs the `effect()` when
the predicate returns a different value. Only the observables inside `predicate()` are tracked.

**`ReactionDisposer when(bool Function(Reaction) predicate, void Function() effect)`**

Monitors the observables used inside `predicate()` and runs the `effect()` upon a change. After the `effect()` is run, `when` automatically disposes itself. So you can think of _when_ as a _one-time_ `reaction`.

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

Similar to `when` but returns a `Future`, which is fulfilled when the `predicate()` returns _true_. This is a convenient way of waiting for the `predicate()` to turn `true`.

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => _completed.value == true);

  print('Completed');
}
```

## Roadmap

### Observables

- [x] Create `Observable<T>` via `Observable<T>()`
- [x] Create `ObservableList<T>`
  - [x] observe hook
  - [ ] intercept hook
- [ ] Create `ObservableMap<K, T>`
  - [ ] observe hook
  - [ ] intercept hook
- [ ] Create `ObservableSet<T>`
  - [ ] observe hook
  - [ ] intercept hook
- [x] Atoms with `createAtom()`

### Computed Observables

- [x] Create `Computed<T>` via `Computed<T>()`
- [x] 2-phase change propagation

### Reactions

- [x] Create `Reaction` with `autorun()`
  - [x] with `delay`
- [x] Create `Reaction` with `reaction()`
  - [x] with `delay`
  - [x] with `fireImmediately`
- [x] Create `Reaction` with `when()`
- [x] Create `Reaction` with `asyncWhen()` returning `Future<T>`

### Actions

- [x] Create `Action`
- [x] Create untracked-action with `untracked<T>()`
- [x] Create transaction with `transaction<T>()`

### Cross cutting features

- [x] Use of a `ReactiveContext` and `ReactiveConfig` to isolate the reactivity. This is an _advanced_ feature and useful in
      case you are running multiple independent reactive systems without causing any interference between them. This is
      possible if a library chooses to use MobX internally and the library gets consumed by an app that also uses MobX. In that
      scenario, you want the reactivity of the library NOT to interfere with the reactivity within the app. For most cases, you don't
      have to worry about this. MobX will default to using the singleton `mainContext`, which is at the app level.
- [x] Observability API for `Observable` and `Computed`
  - [x] `observe`
  - [x] `intercept`
  - [x] `onBecomeObserved`
  - [x] `onBecomeUnobserved`
- [ ] Spying and Tracing
- [x] Global configuration
- [x] Exception handling and Error recovery
  - [x] Error boundary
  - [x] Disabling Error boundary in global config
- [ ] Debuggability

### Public facing

- [x] Logo
- [ ] Documentation
- [ ] Website (published on github.io)
