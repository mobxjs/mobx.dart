## 0.3.10+1

- Package updates

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
