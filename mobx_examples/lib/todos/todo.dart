import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';

@jsonSerializable
@Json(allowCircularReferences: 1)
class Todo with Store {
  Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}
