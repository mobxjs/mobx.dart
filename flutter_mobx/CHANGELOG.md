## 0.3.3+3

- More documentation comments

## 0.3.2 - 0.3.3+1

- Errors that occur internal to the `setState()` call are now reported via `FlutterError.reportError` so they don't go unnoticed by the user.
- Added a version constant that matches the `pubspec.yaml`

## 0.3.0 - 0.3.1+1

- Adapting to the API changes in `mobx 0.3.0`
- Formatting changes
- Using `StackTrace.current` as the name for an `Observer`, when not provided. This helps in quickly jumping to the location of the `Observer`-usage during debugging.
- Docs update

## 0.2.3+1

- `Observer` is relaying the exception caught during the tracking phase. This is done using the `errorValue` field present on the `reaction` instance.

## 0.2.2

- CHANGELOG updates which got missed out in previous versions
- The `Observer` does not trap exceptions occurring during the `build()` anymore. Previously, this used to be the case, which made it difficult to get proper stack traces.

## 0.2.1+1

- README updates

## 0.2.1

- Upgrading to use the `0.2.1` version of `mobx`, which makes it compatible with the latest `beta`/`dev`/`master` channels

## 0.2.0

- Upgrading to use the `0.2.0` version of `mobx`

### 0.0.2 - 0.1.3

- Warn when no observables are found in the `Observer`'s `builder` function. This was originally an `AssertionError`, which was deemed to be too strong and caused apps to crash in debug mode.
- Updates to tests
- Updates to documentation

## 0.0.1 - First release.

- Observer component that re-renders when reactive variables change.
