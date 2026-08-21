---
name: core-store-and-codegen
description: MobX Store class pattern with mobx_codegen annotations and build_runner setup
---

# Store Class and Code Generation

MobX Dart uses a code-generation approach via `mobx_codegen` to eliminate boilerplate. Stores are declared with a fixed pattern that enables `@observable`, `@computed`, and `@action` annotations.

## Required Packages

```yaml
dependencies:
  mobx: ^2.6.0
  flutter_mobx: ^2.0.0

dev_dependencies:
  build_runner: ^2.0.0
  mobx_codegen: ^2.0.0
```

## Store Declaration Pattern

Every store follows this boilerplate (the only repetitive part):

```dart
import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class Todo = _Todo with _$Todo;

abstract class _Todo with Store {
  /* observable fields, computed getters, action methods */
}
```

Key points:
- The part file name must match the containing file: `todo.dart` -> `todo.g.dart`
- The abstract class uses `_` prefix and mixes in `Store`
- The public class blends the abstract class with the generated mixin `_$Todo`

## Running Code Generation

```bash
# Continuous watch mode (recommended during development)
flutter pub run build_runner watch --delete-conflicting-outputs

# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

## Annotations Summary

| Annotation | Target | Purpose |
|---|---|---|
| `@observable` | Field | Makes field reactive, tracked by MobX |
| `@readonly` | Private field | Like `@observable` but auto-generates public getter; mutations only via `@action` |
| `@computed` | Getter | Derived state that auto-updates when dependencies change |
| `@action` | Method | Wraps mutations in a transaction; supports async |
| `@MakeObservable()` | Field | Advanced observable config (e.g., `useDeepEquals: true`) |

## What the Generated Code Contains

The `_$Todo` mixin in `todo.g.dart` generates:
- **Atom-based observables**: Each `@observable` field gets a backing `Atom` that handles `reportObserved()` and `reportChanged()` calls
- **Action wrappers**: Each `@action` method is wrapped in an `Action` for batched notifications
- **Computed getters**: Each `@computed` getter becomes a `Computed` instance with caching
- **Auto-action setters**: Property setters for `@observable` fields are auto-wrapped in actions

When debugging, you can inspect the `.g.dart` file to understand the reactive wiring.

## Troubleshooting Build Output

- If `build_runner` refuses to run, use `--delete-conflicting-outputs`
- If you get stale output, run `flutter pub run build_runner clean` first
- Ensure your SDK version is at least `2.12.0` in `pubspec.yaml`

## Important: No Deep Observability

Unlike JavaScript MobX, Dart MobX does **not** support deep observability. Marking a complex object as `@observable` only tracks reassignment of the reference, not changes to the object's fields. Mark individual fields with `@observable` if you need field-level tracking.

<!--
Source references:
- https://mobx.netlify.app/concepts
- https://mobx.netlify.app/guides/cheat-sheet
- https://mobx.netlify.app/guides/output
-->
