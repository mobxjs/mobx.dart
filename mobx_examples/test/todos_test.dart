import 'package:flutter_test/flutter_test.dart';
import 'package:mobx_examples/todos/todo_list.dart';

void main() {
  TodoList list;

  setUp(() {
    list = TodoList();
  });

  test('TodoList starts with default configuration', () {
    expect(list.todos.length, equals(0));
    expect(list.filter, equals(VisibilityFilter.all));
    expect(list.currentDescription, equals(''));
  });

  test('when a todo is added, the computed properties are updated', () {
    list.addTodo('first one');

    expect(list.todos.first.description, equals('first one'));
    expect(list.hasPendingTodos, isTrue);
    expect(list.hasCompletedTodos, isFalse);
  });
}
