## 2.6.0

 - Upgrading sdk and Analyzer fixes

 - **FIX**: update observableAlwaysNotEqual function signature to accept nullable Object parameters.
 - **FIX**: package upgrades, analysis issue fixes.
 - **FIX**: Observable.value setter (covariant) (#993).
 - **FIX**: stacktrace in computed (#988).
 - **FIX**: observableset and observablemap notify all listeners when one is added with fireimmediately true (#962).
 - **FIX**: revert #784 (#842).
 - **FIX**: ObservableStream.listen() should also keep observable values updated (#708).
 - **FIX**: Widgets failed to call super.dispose() (#334).
 - **FIX**: issue 62 (#64).
 - **FEAT**: add scheduler option to autorun and reaction (#979).
 - **FEAT**: add keepAlive to Computed (#976).
 - **FEAT**: Adds `useEquatable` for creating observables (#971).
 - **FEAT**: Adds custom `equals` for creating observables. (#907).
 - **FEAT**: Adds support for annotations (#904).
 - **FEAT**: Allow a custom equals parameter for ObservableStream (#771).
 - **FEAT**: Allow use custom context (#770).

## 2.5.0

 - **FIX**: package upgrades, analysis issue fixes.
 - **FIX**: Observable.value setter (covariant) (#993).
 - **FIX**: stacktrace in computed (#988).
 - **FIX**: observableset and observablemap notify all listeners when one is added with fireimmediately true (#962).
 - **FIX**: revert #784 (#842).
 - **FIX**: ObservableStream.listen() should also keep observable values updated (#708).
 - **FIX**: Widgets failed to call super.dispose() (#334).
 - **FIX**: issue 62 (#64).
 - **FEAT**: add scheduler option to autorun and reaction (#979).
 - **FEAT**: add keepAlive to Computed (#976).
 - **FEAT**: Adds `useEquatable` for creating observables (#971).
 - **FEAT**: Adds custom `equals` for creating observables. (#907).
 - **FEAT**: Adds support for annotations (#904).
 - **FEAT**: Allow a custom equals parameter for ObservableStream (#771).
 - **FEAT**: Allow use custom context (#770).

## 2.4.0

- Add `scheduler` to `reaction` and `autorun` to allow customizing the scheduler used to schedule the reaction. By [@amondnet]((https://github.com/amondnet).

## 2.3.3+1 - 2.3.3+2

- Analyzer fixes

## 2.3.3

- Upgrading packages and sdk

## 2.3.2

- Fix Observable.value setter when class with operator ==(covariant) is used as a value

## 2.3.1

- Fix preserving stacktrace in Computed and Reaction when exception thrown inside argument function

## 2.3.0+1

- `pubspec.yaml` updated to include homepage and topics

## 2.3.0

- Add `keepAlive` to `Computed` to avoid suspending computed values when they are not being observed by anything.

## 2.2.3+1

Make the change in `2.2.3` optional. If you want the use this behavior , modify `@observable` to
`@MakeObservable(useDeepEquality: true)`.

- Adds `useDeepEquality` for creating observables by [@amondnet](https://github.com/amondnet)

## 2.2.3

- Avoid unnecessary observable notifications of `@observable` `Iterable` or `Map` fields of Stores by [@amondnet](https://github.com/amondnet) in [#951](https://github.com/mobxjs/mobx.dart/pull/951)

## 2.2.2

- Fix [#956](https://github.com/mobxjs/mobx.dart/issues/956): ObservableSet`and`ObservableMap`should not notify all listeners when`observe` with fireImmediately. by [@amondnet](https://github.com/amondnet) in [#962](https://github.com/mobxjs/mobx.dart/pull/962)

## 2.2.1

- Reduces unnecessary iterations while using `Iterables` with `addAll`, `insertAll`, `replaceRange`, `setAll` and `setRange` methods. [#942](https://github.com/mobxjs/mobx.dart/pull/942).

## 2.2.0

- Allows a reaction to be fired even if the value hasn't changed by [@amondnet](https://github.com/amondnet) in [#907](https://github.com/mobxjs/mobx.dart/pull/907)
- Adds custom `equals` for creating observables. [@amondnet](https://github.com/amondnet) in [#907](https://github.com/mobxjs/mobx.dart/pull/907)

## 2.1.4

- Allow users to bypass observability system for performance by [@fzyzcjy](https://github.com/fzyzcjy) in [#844](https://github.com/mobxjs/mobx.dart/pull/844)
- Fix Reaction lacks toString, so cannot see which reaction causes the error by [@fzyzcjy](https://github.com/fzyzcjy) in [#844](https://github.com/mobxjs/mobx.dart/pull/844)
- Add StackTrace to reactions in debug mode to easily spot which reaction it is by [@fzyzcjy](https://github.com/fzyzcjy) in [#844](https://github.com/mobxjs/mobx.dart/pull/844)

  Breaking changes:

- Avoid unnecessary observable notifications of @observable fields of Stores by [@fzyzcjy](https://github.com/fzyzcjy) in [#844](https://github.com/mobxjs/mobx.dart/pull/844)

## 2.1.2 - 2.1.3+1

- Fix tests in dart 2.19 - [@amondnet](https://github.com/amondnet)
- Dart formatting fixes
- Refactor `atom.dart` to make code cleaner by [@fzyzcjy](https://github.com/fzyzcjy) in [#854](https://github.com/mobxjs/mobx.dart/pull/854)

## 2.1.1

- Allow a custom equals parameter for ObservableStream - [@amondnet](https://github.com/amondnet)

## 2.1.0

- `ObservableSet` now uses `Set` to maintain order of iteration
- `ObservableSet.linkedHashSetFrom()` removed. Use `ObservableSet()` or `ObservableSet.of()` instead.

## 2.0.7+7

- Moved the version into its own file (`version.dart`) and exported from the main library file

## 2.0.7+6

- Fixed issue in showing issue tracker link on pub.dev

## 2.0.7+5

- revert #784 - [@amondnet](https://github.com/amondnet)

## 2.0.7+4

fixes:

- shortened `1.asObservable()` to `1.obs()` (same for boolean, double, String) - [@subzero911](https://github.com/subzero911)
- removed experimental typedefs from `2.0.7`

## 2.0.7+3

- Fixed unnecessary ActionSpyEvents being triggered for AsyncAction

## 2.0.7+1 - 2.0.7+2

- Package upgrades

## 2.0.7

- Type aliases for primitive types.\
  So instead of `Observable<int>` you can now write `ObservableInt`.
- `.asObservable()` extension for primitive types.\
  Now you can easily convert literals to observables like:
  ```dart
  var name = ''.asObservable(); // infers ObservableString
  var counter = 0.asObservable(); // infers ObservableInt
  ```
- `toggle()` method for `ObservableBool`. Lets you toggle the internal value of `ObservableBool`
  ```dart
  var lights = true.asObservable();
  lights.toggle(); // now it has a value of false
  ```
  Changes made by [@subzero911](https://github.com/subzero911)
- Allow use custom context(#770) - @amondnet

## 2.0.6 - 2.0.6+1

- Improved performance when spying is disabled. Thanks to @Ascenio.
- Package upgrades
- Adopting the recommended linting for Dart

## 2.0.5

- Fix for `ObservableStream.listen()` should also keep observable values updated (#708) - @brianrobles204
- Added missing parameter to `asyncWhen` - @easeccy

## 2.0.4

- Moved `analyzer` package to `2.0.0` - @davidmartos96
- Fixed a bug in `Computed` that was not propagating values after an exception - @brianrobles204
- Several documentations typo fixes - @sno2, @Ascenio

## 2.0.2 - 2.0.3

- Fixes #681: ObservableStream.value throws Exception when data is null
- Removes `mockito` as a dependency and using `mocktail` instead.

## 2.0.1 - 2.0.1+1

- Adds `@readonly` annotation support for creating read-only observables.

## 2.0.0

- Full support for Null Safety

## 2.0.0-nullsafety.6

- Adding support for `@readonly` annotation, as per this [issue](https://github.com/mobxjs/mobx.dart/issues/220)

## 2.0.0-nullsafety.0 - 2.0.0-nullsafety.5

- Null safe migration
- Formatting fixes to improve Pub Points

## 1.2.1+2 - 1.2.1+4

- Reformatting for improving the pub.dev score
- Regenerated the example files

## 1.2.1 - 1.2.1+1

- Improved `observe()` API for `ObservableList`. We now get better change events with accurate details about what has changed. Thanks to
  @darkstarx for the PR (#490)
- API docs update for reaction. Rewording the _debouncing_ to _throttle_, since the behavior is more like throttling.
- Syncing versions with pubspec.yaml

## 1.2.0

- Added the ability to **spy** on changes happening inside MobX. You can now setup a `spy()` to see all these changes. See [this](https://github.com/mobxjs/mobx.dart/blob/5095e966fe591d223c7730579de2f4778a7ff465/mobx_examples/lib/main.dart#L26) for an example.
- Simplified the handling of tests and coverage. We are no longer dependent on the `test_coverage` package, which was causing issues on CI.
- A custom `EqualityComparer<T>` can now be specified for `Computed<T>`. This can be passed in with the `equals` parameter in the constructor.
- Several documentation updates from various contributors.

## 1.1.0 - 1.1.1

- All exceptions caught inside MobX reactions are now reported as `MobXCaughtException`. Previously they were reported as-is and that caused issues in `flutter_mobx`, where the stack traces were not visible. The stack trace is now being captured as part of the exception, so `flutter_mobx` can show the complete trace. This helps a lot during debugging.
- `MobXException` now extends from `Error` to capture the stack trace. This is done because Dart only captures stack traces automatically for `Error` instances.
- Bringing test coverage back to 98% in `1.1.1`

## 1.0.2 - 1.0.2+2

- Added `@StoreConfig` annotation ([@hawkbee1](https://github.com/hawkbee1))
- Fixed to link to pt-BR translation on github
- Fixed anchor link inside README.md

## 1.0.1

- Fix for ObservableMap not adding null values (#417), thanks to @Vardiak

## 1.0.0

- Ready for prime time!

## 0.4.0+3 - 0.4.0+4

- Going back to original `test_coverage` package
- Some cleanups in the tests

## 0.4.0+2

- README updates
- Switching to [Github Actions](https://github.com/mobxjs/mobx.dart/actions) for all builds and publishing

## 0.4.0 - 0.4.0+1

- Removing the deprecated `authors` field from `pubspec.yaml`
- Added extension methods to create an Observable{List,Set,Map,Future,Stream} from a regular List, Set, Map, Future, Stream. Thanks
  to the work done by [Jacob Moura](https://github.com/jacobaraujo7)
- `README.md` translated to Portuguese, thanks to [Jacob Moura](https://github.com/jacobaraujo7)

## 0.3.10

- Removed `Store.dispose`
- Fixed some analyzer errors related to `unused_element`

## 0.3.9+3

- Documentation comments for many of the public methods and classes
- Package updates

## 0.3.9 - 0.3.9+1

- Added `toString` override for `MobXException`
- Added an interface `ObservableValue` that is a common interface for all observables: `Observable`, `Computed`, `ObservableFuture`, `ObservableStream`. Thanks to [@t-artikov](https://github.com/t-artikov)
- Added chat link to Discord. It is now: [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)

## 0.3.7 - 0.3.8+1

- Fixes the type resolution bug that prevented using types from packages like `dart:ui`
- Fixes the type resolution of other public `Store` classes referenced in the `@store` based generation

Thanks to [@shyndman](https://github.com/shyndman) for the tremendous work on this release.

- Added a version constant that matches the `pubspec.yaml`

## 0.3.6

- Added new way to create `Store` classes using the `@store` annotation. This will exist as an alternative to the mixin based approach we already have.
- Includes a new option for `reaction` for using a custom `EqualityComparator<T, T>`. This is useful when you want to avoid expensive reactions by plugging in a custom comparison function for the _previous_ and _next_ values of the predicate.

## 0.3.5 - 0.3.5+1

- Fixed a bug where the `ObservableFuture<T>` would not show the correct status. This was happening because of the lazy evaluation strategy. We are now being eager in creating the status and monitoring the inner `Future<T>` immediately.
- Upgraded `test_coverage`

## 0.3.3+1 - 0.3.4

- Removed the `@experimental` annotations for `Observable{Future,Stream}` and `reaction`.
- Removed the dependency on the `meta` package.
- Some formatting changes
- Reporting update or change only when the new value is different than the old value. This is mostly for observable collections like list, set, map.

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
