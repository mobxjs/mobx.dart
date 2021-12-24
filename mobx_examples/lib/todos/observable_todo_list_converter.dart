import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/todos/todo.dart';

class ObservableTodoListConverter extends JsonConverter<ObservableList<Todo>,
    Iterable<Map<String, dynamic>>> {
  const ObservableTodoListConverter();

  @override
  ObservableList<Todo> fromJson(Iterable<Map<String, dynamic>> json) =>
      ObservableList.of(json.map(Todo.fromJson));

  @override
  Iterable<Map<String, dynamic>> toJson(ObservableList<Todo> object) =>
      object.map((element) => element.toJson());
}
