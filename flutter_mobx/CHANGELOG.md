## 1.1.0

- Exceptions are reported more reliably with `FlutterError.reportError`. This also includes the stack trace, as all caught exceptions are now wrapped inside `MobXCaughtException`.

## 1.0.0 - 1.0.1

- Ready for prime time!
- Fixing version resolution

## 0.3.7

- Refactoring `observer.dart` to separate out the `StatelessObserverWidget`, `StatefulObserverWidget` and the `ObserverWidgetMixin` into their own files.

## 0.3.6+1 - 0.3.6+2

- README updates
- Switching to [Github Actions](https://github.com/mobxjs/mobx.dart/actions) for all builds and publishing
- Upgraded to `Dart 2.7` as the min SDK

## 0.3.5 - 0.3.6

- Updated `mobx` dependency version to **0.4.0** in `flutter_mobx` `pubspec.yaml`
- Improved naming of `Observer` in debug-mode with the correct line in StackTrace.

Thanks to [Scott Hyndman](https://github.com/shyndman) for all the contributions in this release.

## 0.3.4 - 0.3.4+4

- Added two new `Observer`-widgets: `StatelessObserverWidget` and `StatefulObserverWidget`
- Improved the reporting of Flutter errors inside `Observer` widgets.
- Exposing the `debugAddStackTraceInObserverName` field
- Removing the deprecated `authors` field from `pubspec.yaml`

Thanks to [Scott Hyndman](https://github.com/shyndman) and [Remi Rousselet](https://github.com/rrousselGit) for the work done in this release!

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
