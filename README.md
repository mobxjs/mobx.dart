# mobx.dart

[![pub package](https://img.shields.io/pub/v/mobx.svg)](https://pub.dartlang.org/packages/mobx)
[![Build Status](https://travis-ci.com/mobxjs/mobx.dart.svg?branch=master)](https://travis-ci.com/mobxjs/mobx.dart)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)

![](mobx/doc/mobx.png)

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

## Introduction


## Core Concepts

- Observables
- Computed
- Actions
- Reactions

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
