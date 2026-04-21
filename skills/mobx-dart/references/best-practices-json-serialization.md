---
name: best-practices-json-serialization
description: JSON serialization of MobX stores using json_serializable with custom converters for ObservableList
---

# JSON Serialization of Stores

MobX stores can be serialized to/from JSON using `json_serializable`. The code generators coexist — both `mobx_codegen` and `json_serializable` write to the same `*.g.dart` file.

## Setup

```yaml
dependencies:
  json_annotation: ^4.0.0

dev_dependencies:
  json_serializable: ^6.0.0
```

## Annotate the Store

Add `@JsonSerializable()` to the **public** class (not the abstract base):

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo extends _Todo with _$Todo {
  Todo(String description) : super(description);

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

abstract class _Todo with Store {
  _Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}
```

## Custom Converters for Observable Collections

`ObservableList<T>` is not directly JSON-serializable. Write a `JsonConverter`:

```dart
class ObservableTodoListConverter
    extends JsonConverter<ObservableList<Todo>, Iterable<Map<String, dynamic>>> {
  const ObservableTodoListConverter();

  @override
  ObservableList<Todo> fromJson(Iterable<Map<String, dynamic>> json) =>
      ObservableList.of(json.map(Todo.fromJson));

  @override
  Iterable<Map<String, dynamic>> toJson(ObservableList<Todo> object) =>
      object.map((e) => e.toJson());
}
```

Apply it to the field:

```dart
abstract class _TodoList with Store {
  @observable
  @ObservableTodoListConverter()
  ObservableList<Todo> todos = ObservableList<Todo>();
}
```

## Excluding Computed Properties

Use `@JsonKey(ignore: true)` on computed properties that shouldn't be serialized (or `@JsonKey(includeFromJson: false, includeToJson: false)` in newer `json_annotation` versions where `ignore` is deprecated):

```dart
@computed
@JsonKey(ignore: true)
ObservableList<Todo> get visibleTodos { /* ... */ }
```

## Regenerate

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

<!--
Source references:
- https://mobx.netlify.app/guides/json
-->
