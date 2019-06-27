# Changelog

## 0.3.3

- Wrapping all collection setters in conditional action wrappers. This removes the need to wrap collection mutating methods in explicit actions.

## 0.3.0 - 0.3.2+3

- API changes introduced to the `enforceActions` setting of `ReactiveConfig`. It is now called `writePolicy` and the enum `EnforceActions` has been renamed to `ReactiveWritePolicy`.
- Also introducing a `readPolicy` setting on `ReactiveConfig`. It is an enumeration with two values:
- Removing the "strict-mode" text in the exception message when the `ReactiveWritePolicy` is violated. This was a vestige from the `mobx.js` world.
- Exposing a boolean `isWithinBatch` on `ReactiveContext`, which tells if the current code is running inside a batch. This is used to conditionally apply an action-wrapper for `mobx_codegen`-generated setters.
- Introduced an action-wrapper called `conditionallyRunInAction()` that runs the given function in an action only when outside a batch.
- Increasing test coverage

```dart
enum ReactiveReadPolicy { always, never }
```

## 0.2.1+2

- Improving test coverage

## 0.2.1+1

- README updates

## 0.2.1

- An internal change was made to support the new restrictions around [non-covariant type variables in superinterfaces](https://github.com/dart-lang/language/blob/master/accepted/future-releases/contravariant-superinterface-2018/feature-specification.md). This was causing compile errors in the Flutter `beta`/`dev`/`master` channels.

## 0.2.0

- A breaking change has been introduced to the use of the `Store` type. Previously it was meant to be used as an _interface_, which has now changed to a **mixin**. Instead of doing:

```dart
abstract class UserBase implements Store {}
```

You now do:

```dart
abstract class UserBase with Store {}
```

This allows us to add more convenience methods to the `Store` mixin without causing any breaking change in the future. With the current use of the interface, this was not possible and was limiting the purpose. `Store` was just a marker interface without any core functionality. With a **mixin**, it opens up some flexibility in adding more functionality later.

- All the docs and example code have been updated to the use of the `Store` mixin.
