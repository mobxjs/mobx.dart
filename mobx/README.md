# mobx.dart

[![pub package](https://img.shields.io/pub/v/mobx.svg)](https://pub.dartlang.org/packages/mobx)
[![Build Status](https://travis-ci.com/mobxjs/mobx.dart.svg?branch=master)](https://travis-ci.com/mobxjs/mobx.dart)
[![Coverage Status](https://coveralls.io/repos/github/mobxjs/mobx.dart/badge.svg?branch=master)](https://coveralls.io/github/mobxjs/mobx.dart?branch=master)

![](doc/mobx.png)

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

## Building blocks

### Observables

- [x] Create `Observable<T>` via `Observable<T>()`
- [x] Create `ObservableList<T>`
  - [ ] `observe` and `intercept`
  - [ ] `onBecomeObserved` and `onBecomeUnobserved`
- [ ] Create `ObservableMap<K, T>`
- [x] Atoms with `Atom()`

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
  - [x] `when` with timeout
  - [x] `when()` returning `Future<T>`

### Actions

- [x] Create `Action` with `Action()`
- [x] Execute within `runInAction`
- [x] Create untracked-action with `untracked<T>()`
- [x] Create transaction with `transaction<T>()`

## Cross cutting features

- [x] Observability API for `Observable` and `Computed`
  - [x] `observe`
  - [x] `intercept`
  - [x] `onBecomeObserved`
  - [x] `onBecomeUnobserved`
- [ ] Spying and Tracing
- [x] Exception handling and Error recovery
  - [x] `onReactionError` on the context for catching global errors
  - [x] `onError` handler for reactions
  - [x] `disableErrorBoundaries` option for the reactive context
- [ ] Debuggability

## Public facing

- [x] Logo
- [ ] Documentation
- [ ] Website (published on github.io)
