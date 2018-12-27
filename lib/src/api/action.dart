import 'package:mobx/src/core/action.dart';

Action action(Function fn, {String name}) {
  return Action(fn, name: name);
}
