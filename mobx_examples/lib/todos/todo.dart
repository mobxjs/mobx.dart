import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'todo.g.dart';

@JsonSerializable(nullable: false)
class Todo extends _Todo with _$Todo {
  Todo(String description) : super(description);

  static Todo fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  static Map<String, dynamic> toJson(Todo todo) => _$TodoToJson(todo);
}

abstract class _Todo with Store {
  _Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}
