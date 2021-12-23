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
