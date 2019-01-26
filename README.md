# mobx.dart

[![pub package](https://img.shields.io/pub/v/mobx.svg)](https://pub.dartlang.org/packages/mobx)
[![Build Status](https://travis-ci.com/mobxjs/mobx.dart.svg?branch=master)](https://travis-ci.com/mobxjs/mobx.dart)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)

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

## Core Concepts

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
  final _value = Observable(0);

  int get value => _value.value;
  set value(int newValue) => _value.value = newValue;
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

### Reactions

## Roadmap

### Observables

- [x] Create `Observable<T>` via `Observable<T>()`
- [x] Create `ObservableList<T>`
  - [x] observe hook
  - [ ] intercept hook
- [x] Create `ObservableMap<K, T>`
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
- [x] Create `Reaction` with `when()` returning `Future<T>`

### Actions

- [x] Create `Action`
- [x] Create untracked-action with `untracked<T>()`
- [x] Create transaction with `transaction<T>()`

## Cross cutting features

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

## Public facing

- [x] Logo
- [ ] Documentation
- [ ] Website (published on github.io)
