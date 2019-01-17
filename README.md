# mobx.dart

[![pub package](https://img.shields.io/pub/v/mobx.svg)](https://pub.dartlang.org/packages/mobx)
[![Build Status](https://travis-ci.com/mobxjs/mobx.dart.svg?branch=master)](https://travis-ci.com/mobxjs/mobx.dart)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)

![](mobx/doc/mobx.png)

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

## Building blocks

### Observables

- [x] Create `ObservableValue<T>` via `observable<T>()`
- [x] Create `ObservableList<T>`
  - [x] observe hook
  - [ ] intercept hook
- [ ] Create `ObservableMap<K, T>`
- [x] Atoms with `createAtom()`

### Computed Observables

- [x] Create `ComputedValue<T>` via `computed<T>()`
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

- [x] Create `Action` with `action()`
- [x] Create untracked-action with `untracked<T>()`
- [x] Create transaction with `transaction<T>()`

## Cross cutting features

- [x] Observability API for `ObservableValue` and `ComputedValue`
  - [x] `observe`
  - [x] `intercept`
  - [x] `onBecomeObserved`
  - [x] `onBecomeUnobserved`
- [ ] Spying and Tracing
- [x] Global configuration
- [ ] Exception handling and Error recovery
  - [x] Error boundary
  - [x] Disabling Error boundary in global config
- [ ] Debuggability

## Public facing

- [x] Logo
- [ ] Documentation
- [ ] Website (published on github.io)

