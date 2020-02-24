import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';

part 'todo.g.dart';

@jsonSerializable
@Json(allowCircularReferences: 1)
class Todo extends _Todo with _$Todo {
  Todo(String description) : super(description);
}

abstract class _Todo with Store {
  _Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}
