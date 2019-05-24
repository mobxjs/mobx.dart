import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class Todo = _Todo with _$Todo;

abstract class _Todo with Store {
  _Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;

  @action
  // ignore: avoid_positional_boolean_parameters
  void markDone(bool flag) {
    done = flag;
  }
}
