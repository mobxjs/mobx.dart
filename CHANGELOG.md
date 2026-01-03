# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-12-28

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mobx_codegen` - `v2.7.5`](#mobx_codegen---v275)

---

#### `mobx_codegen` - `v2.7.5`

 - Upgrading sdk and Analyzer fixes

 - **FIX**: fixing lints in tests.
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


## 2025-12-28

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mobx` - `v2.6.0`](#mobx---v260)

---

#### `mobx` - `v2.6.0`

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


## 2024-12-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`flutter_mobx` - `v2.3.0`](#flutter_mobx---v230)
 - [`mobx` - `v2.5.0`](#mobx---v250)
 - [`mobx_codegen` - `v2.7.0`](#mobx_codegen---v270)
 - [`mobx_examples` - `v1.1.0`](#mobx_examples---v110)
 - [`mobx_lint` - `v1.1.0`](#mobx_lint---v110)

---

#### `flutter_mobx` - `v2.3.0`

 - **REFACTOR**: export `MultiReactionBuilder` from `flutter_mobx.dart` (#946).
 - **FIX**: package upgrades, analysis issue fixes.
 - **FIX**: stacktrace in computed (#988).
 - **FIX**: If builder of Observer errors, further error LateInitializationError: Local 'built' has not been initialized. will happen in addition to the actual error, reducing developer experience #780.
 - **FIX**: Disable button Remove Completed, when the completed task is occult on screen. (#73).
 - **FEAT**: add `MultiReactionBuilder` widget (#917).

#### `mobx` - `v2.5.0`

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

#### `mobx_codegen` - `v2.7.0`

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

#### `mobx_examples` - `v1.1.0`

 - **FEAT**: Adds support for annotations (#904).

#### `mobx_lint` - `v1.1.0`

 - **FIX**: package upgrades, analysis issue fixes.
 - **FEAT**: add wrap with observer assist (#949).

