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
