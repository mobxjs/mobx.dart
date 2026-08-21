---
name: best-practices-store-organization
description: Store hierarchy, Widget-Store-Service triad, inter-store communication, lifetimes, and Provider integration
---

# Organizing Stores

As applications scale, break down state into a hierarchy of stores with clear conceptual boundaries.

## Widget-Store-Service Triad

Three layers with top-down dependency:

| Layer | Responsibility |
|---|---|
| **Widget** | Renders reactive state using `Observer` widgets. Primarily stateless. |
| **Store** | Holds `@observable` and `@computed` fields, exposes `@action` methods. No heavy work — just reactive state. |
| **Service** | Performs actual work: API calls, data transformations, validation. Completely stateless — all inputs passed in. |

> Single Responsibility is the most important attribute of this pattern.

## Store Hierarchy

Start with one store. When it grows, split along **conceptual boundaries** (cohesiveness):

```dart
// Before: everything in one store
abstract class _MainStore with Store {
  @observable String title;
  @observable String name;
  @observable String email;
  @observable String phone;
}

// After: split into cohesive sub-stores
abstract class _MainStore with Store {
  @observable String title;
  final details = PersonDetails();  // not @observable — reference doesn't change
}

abstract class _PersonDetails with Store {
  @observable String name;
  @observable String email;
  @observable String phone;
}
```

## Inter-Store Communication

**Option 1: Pass parent to child** — child accesses parent's public interface:

```dart
class Parent {
  Parent() { child = Child(parent: this); }
  late Child child;
}

class Child {
  Child({required this.parent});
  Parent parent;
}
```

**Option 2: Callbacks** — looser coupling, child-to-parent direction:

```dart
class Child {
  void Function(String)? onChange;

  void perform() {
    onChange?.call('value changed');
  }
}
```

For complex dependency graphs (shared `ThemeStore`, `AuthStore`, etc.), use a **Service Locator** like `get_it`.

## Store Lifetimes

- **App-level stores**: Create before rendering UI (preferences, auth, themes)
- **Screen-level stores**: Create in `initState()`, dispose in `dispose()`

```dart
class _FormWidgetState extends State<FormWidget> {
  late FormStore store;

  @override
  void initState() {
    super.initState();
    store = FormStore();
    store.setupValidations();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }
}
```

## Provider Integration

Use the `provider` package to make stores available throughout the widget tree:

```dart
// Provide at app level
MultiProvider(
  providers: [
    Provider<MultiCounterStore>(create: (_) => MultiCounterStore()),
  ],
  child: MaterialApp(/* ... */),
)

// Consume in widgets
Widget build(BuildContext context) {
  final store = Provider.of<MultiCounterStore>(context);
  return Observer(builder: (_) => Text('${store.count}'));
}
```

Use `ProxyProvider` when stores depend on services:

```dart
MultiProvider(
  providers: [
    Provider<PreferencesService>(create: (_) => PreferencesService(prefs)),
    ProxyProvider<PreferencesService, SettingsStore>(
      update: (_, service, __) => SettingsStore(service),
    ),
  ],
)
```

## Store Design Principles

- Keep stores **independent** with dependencies fed via constructors
- Use **callbacks** for external communication from stores
- This improves **portability** and simplifies **testing** (pass mocks via constructor)

<!--
Source references:
- https://mobx.netlify.app/guides/stores
-->
