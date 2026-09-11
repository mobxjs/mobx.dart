# Annotations and tooling

`mobx_codegen` generates accessors and action wrappers; `mobx` supplies the runtime they call. Keep them as separate dependencies: the runtime in `dependencies`, the generator and `build_runner` in `dev_dependencies`.

## Control generated state

| Declaration | Meaning |
| --- | --- |
| `@observable` | Track reads and writes to a field |
| `@readonly` | Generate public read access to a private observable field |
| `@computed` | Derive a value from observable reads in a getter |
| `@action` | Wrap a method's writes in an action; async methods use `AsyncAction` |
| `@alwaysNotify` | Use `observableAlwaysNotEqual` to notify even for equal assignments |
| `@MakeObservable(equals: ...)` | Select a top-level or static equality comparer |
| `@ComputedMethod(keepAlive: true)` | Retain a computed beyond ordinary observation; use deliberately |
| `@StoreConfig(hasToString: false)` | Disable the generated store string representation |

```dart
bool sameId(Item? a, Item? b) => a?.id == b?.id;

// Inside a generated Store; Item is your domain type.
@MakeObservable(equals: sameId)
Item? selected;

@readonly
int _revision = 0;
```

An equality comparer returns **true for equal values**, suppressing notification. `alwaysNotify` deliberately returns false. Deep comparison is an option for generated values; it is not recursive observation and may be expensive for large collections. Prefer equality that matches the value's meaning.

## Generate and inspect

Run `dart run build_runner build --delete-conflicting-outputs`. Keep the `part` declaration and mixin name aligned with the file and store class. Do not hand-edit generated `.g.dart` files. [Build output](/guides/output) explains the generated structure.

`StoreGenerator` is the exported generator entry point for build integrations. Ordinary app code uses annotations, not the generator object. `build.yaml` defines the builder integration. The package `version` constants expose the installed package version for diagnostics; alias imports if reading several packages' identically named constants.

## Lint support

`mobx_lint` supplies a custom-lint plugin and an assist for wrapping widgets with `Observer`. Enable the analyzer plugin and configure custom_lint in the consuming project's development toolchain. Its plugin entry point is tooling, not a reactive application API. The lint package is resolved separately in this repository because its analyzer constraints differ from the generator workspace.

Keep SDK and generator upgrades coordinated. Run generator tests and regenerate examples whenever changing analyzer or source-generation dependencies.

The secondary `package:mobx_codegen/builder.dart` entry point exports `storeGenerator(BuilderOptions)`, which creates the `SharedPartBuilder` consumed by build_runner. The isolated `package:mobx_lint/mobx_lint.dart` entry point exports `createPlugin()`. [The lint reference](/api/mobx_lint-public) documents that tooling boundary; neither belongs in a Flutter application's runtime imports.
