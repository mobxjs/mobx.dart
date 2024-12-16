## 2.7.0

 - **FIX**: package upgrades, analysis issue fixes.
 - **FIX**: error with code generation when file has unnamed extension (#1020).
 - **FIX**: make readonly work with computed (#710).
 - **FIX**: ObservableStream.listen() should also keep observable values updated (#708).
 - **FEAT**: add keepAlive to Computed (#976).
 - **FEAT**: support late observables (#973).
 - **FEAT**: Adds `useEquatable` for creating observables (#971).
 - **FEAT**: require `analyzer: ^5.12.0` (#934).
 - **FEAT**: Adds custom `equals` for creating observables. (#907).
 - **FEAT**: Adds support for annotations (#904).
 - **FEAT**: Allow use custom context (#770).

## 2.6.2

- Fixes [error with code generation when file has unnamed extension](https://github.com/mobxjs/mobx.dart/issues/1010) by [@amondnet](https://github.com/amondnet) in [#1020](https://github.com/mobxjs/mobx.dart/pull/1020)

## 2.6.1+1

- Fixing some analyzer errors related to deprecated types.

## 2.6.1

- Upgrading packages and sdk

## 2.6.0+1

- `pubspec.yaml` updated to include homepage and topics

## 2.6.0

- Add `keepAlive` to `Computed` to avoids suspending computed values when they are not being observed by anything.

## 2.5.0

- Support `late` observables by [@amondnet](https://github.com/amondnet). fix [#919](https://github.com/mobxjs/mobx.dart/issues/919)

## 2.4.1

- Adds `useDeepEquality` for creating observables by [@amondnet](https://github.com/amondnet)

## 2.4.0

- Require `analyzer: ^5.12.0`
- Support the latest package:analyzer
- Require Dart 3.0

## 2.3.0

- Adds `@alwaysNotify` annotation support for creating always notify observables. [@amondnet](https://github.com/amondnet) in [#907](https://github.com/mobxjs/mobx.dart/pull/907)
- Adds custom `equals` for creating observables. [@amondnet](https://github.com/amondnet) in [#907](https://github.com/mobxjs/mobx.dart/pull/907)

## 2.2.0

- Adds support for annotations `@protected`, `@visibleForTesting` and `@visibleForOverriding` for actions, observables futures and observables stream.

## 2.1.0 - 2.1.1

- Update analyzer version to `>=4.4.0 <6.0.0`
- Dart formatting fixes

## 2.0.7+2 - 2.0.7+3

- Moved the version into its own file (`version.dart`) and exported from the main library file
- Bringing the `version.dart` file in sync with `pubspec.yaml`

## 2.0.7+1

- Fixed issue in showing issue tracker link on pub.dev

## 2.0.7

- Update codegen templates to ignore newly recommended lint rules in generated code

## 2.0.6+2

- Package upgrades

## 2.0.6+1

- Upgrading `mobx` to `2.0.7` - @amondnet

## 2.0.6

- Globally disable `toString()` method generation

## 2.0.5 - 2.0.5+2

- Fixed some tests not picking the right path for data files
- Package upgrades
- Adopting the recommended linting for Dart

## 2.0.4

- make readonly work with computed - @Ascenio

## 2.0.3

- Moved `analyzer` package to `2.0.0` - @davidmartos96

## 2.0.2

- Package upgrades

## 2.0.1+3

- Adding a test specifically for `late` observables

## 2.0.1 - 2.0.1+2

- Adds `@readonly` annotation support for creating read-only observables. Thanks to [Ascenio](https://github.com/Ascenio)
  for the [PR](https://github.com/mobxjs/mobx.dart/pull/649).

## 2.0.0

- Full support for Null Safety

## 2.0.0-nullsafety.0 - 2.0.0-nullsafety.2

- Support for null safety

## 1.1.2

- Fixing some analyzer errors related to deprecated types. Now using the
  newer types as the analyzer package has been upgraded to `^0.39`

## 1.1.1+2 - 1.1.1+3

- Fixed a test related to typedef-ed identifiers with prefixes
- Fixed analyzer errors for the dev channel

## 1.1.1 - 1.1.1+1

- Upgraded our `analyzer` dependency's to support a range from **0.39.1**, up to latest **0.40.x** in order to be compatible with other packages.
- Formatting changes to improve pub.dev score

## 1.1.0+2

- Reformatting for improving the pub.dev score

## 1.1.0 - 1.1.0+1

- Added the ability to **spy** on changes happening inside MobX. You can now setup a `spy()` to see all these changes. See [this](https://github.com/mobxjs/mobx.dart/blob/5095e966fe591d223c7730579de2f4778a7ff465/mobx_examples/lib/main.dart#L26) for an example. The changes in `mobx_codegen` help in the reporting of updates to observables.
- Simplified the handling of tests and coverage. We are no longer dependent on the `test_coverage` package, which was causing issues on CI.
- Adding an ignore for the analyzer warning for `unnecessary_brace_in_string_interps`
- Syncing versions with pubspec.yaml
- Fixes a test that was not including an analyzer warning

## 1.0.3

- Upgrading `mobx` to `1.1.0`

## 1.0.2

- Added automatic generation of `toString` method with `@StoreConfig` annotation

Thanks to [@hawkbee1](https://github.com/hawkbee1)

## 1.0.0 - 1.0.1

- Ready for prime time!
- Fixing version resolution

## 0.4.2

- Upgraded the `build_resolvers` dependency to 1.3.2, which fixes issues with certain
  versions of Dart being unable to resolve `dart:ui` types.

## 0.4.1+2

- Going back to original `test_coverage` package

## 0.4.1+1

- README updates
- Switching to [Github Actions](https://github.com/mobxjs/mobx.dart/actions) for all builds and publishing

## 0.4.1

There were a number of bugs with the previous implementation of the `LibraryScopedNameFinder`. This resolves them, as well as ensures that a single code path is followed whether or not the analyzed source code contains named imports, reducing the potential for future bugs.

The following bugs have been corrected when using named imports:

- Missing type arguments on classes
- Missing type arguments on function typedefs
- Missing prefixes from imported typedefs
- Missing prefixes from implicit type argument bounds

## 0.4.0 - 0.4.0+1

- Upgraded our `analyzer` dependency's minimum version to **0.38.5** in order to
  workaround a bug where collection types would resolve to dynamic
- Updated `pubspec.yaml` to not include the reference to the `@store` annotation. It has been removed.

## 0.3.13

- Fixes the extraction of generic return-types which have nested generic type arguments, eg: `Future<List<User>>`
- Also fixes the issue reported in #367

## 0.3.12 - 0.3.12+1

- Removed the experimental use of `@store` annotation. It fails for some cases and has now been removed. We will explore
  other use cases with this annotation in future PRs.
- Package updates
- Added the Flutter Favorite logo

## 0.3.10+1 - 0.3.11

- Package updates
- Upgraded dependency version for the `analyzer` package

## 0.3.9+1 - 0.3.10

- Alters the analyzer dependency to support a range — from the previously supported version
  (0.36.3), up to latest (0.39.0).
- Adds support for library prefixes in all situations (`import 'package:foo' as foo`),
  so type names are prefixed in generated part files.

## 0.3.8 - 0.3.9+1

- Fixes a minor issue where types in generated code would appear as dynamic when they shouldn't.
- Added a version constant that matches the `pubspec.yaml`

## 0.3.7

- This is mostly about providing better error reporting on classes that don't meet the necessary constraints.
  - A class using the Store mixin, must be marked abstract. This will be reported if not the case.
  - A class using the @store annotation, must be marked private. This will be reported if not the case.
- Bit of refactoring to separate things out a bit.

## 0.3.6

- Fixes the type resolution bug that prevented using types from packages like `dart:ui`
- Fixes the type resolution of other public `Store` classes referenced in the `@store` based generation

Thanks to [@shyndman](https://github.com/shyndman) for the tremendous work on this release.

## 0.3.5

- Added the ability to create `Store` classes using the `@store` annotation. It can be added to a private class, which will result in a public generated class.

## 0.3.4

- Refactored some tests that rely on `source-text` to not be based on hard-coded strings. These have been moved to a separate file for easier maintenance. The outputs resulting from the generator are also in a separate file. This allows scaling to more variations of `source-text` in the future.
- Added checks to ensure `@observable` and `@computed` are used for the correct members of the class. These are reported as errors during the codegen process.
- Upgraded `test_coverage`
- Fixed a bunch of analyzer errors

## 0.3.1 - 0.3.3+1

- Adding a conditional action-wrapper for field setters.
- Increasing test coverage
- Adapting to the API change in `mobx 0.3.3`
- Formatting changes

## 0.3.0 - 0.3.0+1

- Adapting to the API changes in `mobx 0.3.0`
- README.md updates

## 0.2.1+2

- Removing the code in `/example` folder and instead having a simple `README.md` in it.

## 0.2.1+1

- README updates

## 0.2.1

- Upgrading to use the `0.2.1` version of `mobx`, which makes it compatible with the latest `beta`/`dev`/`master` channels

## 0.2.0

- A breaking change has been introduced to the use of the `Store` type. Previously it was meant to be used as an _interface_, which has now changed to a **mixin**.

## 0.0.2 - 0.1.3

- Move all the codegen parts to separate templates
- Documentation updates
- Support for async actions
- CircleCI integration improvements

## 0.0.1 - First Release

- Added support for `@observable`, `@computed` and `@action`
