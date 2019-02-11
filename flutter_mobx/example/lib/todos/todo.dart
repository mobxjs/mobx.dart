import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class Todo = _Todo with _$Todo;

abstract class _Todo implements Store {
  _Todo(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;

  @action
  void markDone({bool value}) => done = value;
}
