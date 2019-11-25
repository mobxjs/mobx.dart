import 'package:dart_json_mapper/annotations.dart';
import 'package:mobx/mobx.dart';

part 'todo_json_mapper.g.dart';

@jsonSerializable
class TodoJsonMapper extends _TodoJsonMapper with _$TodoJsonMapper {
  TodoJsonMapper(String description) : super(description);
}

@jsonSerializable
abstract class _TodoJsonMapper with Store {
  _TodoJsonMapper(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}
