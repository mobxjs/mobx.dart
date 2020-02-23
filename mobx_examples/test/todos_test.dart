import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dart_json_mapper_mobx/dart_json_mapper_mobx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/todos/todo_list.dart';

import 'todos_test.reflectable.dart';

void main() {
  initializeReflectable();
  JsonMapper().useAdapter(mobXAdapter);

  TodoList list;

  setUp(() {
    list = TodoList();
  });

  test('TodoList JSON serialization/(de)serialization', () {
    expect(list.todos.length, equals(0));
    list..addTodo('first one')..addTodo('second one');

    const targetJson = '''
{
 "todos": [
  {
   "description": "first one",
   "done": false
  },
  {
   "description": "second one",
   "done": false
  }
 ],
 "filter": "VisibilityFilter.all",
 "currentDescription": "",
 "pendingTodos": [
  {
   "description": "first one",
   "done": false
  },
  {
   "description": "second one",
   "done": false
  }
 ],
 "completedTodos": [],
 "hasCompletedTodos": false,
 "hasPendingTodos": true,
 "itemsDescription": "2 pending todos, 0 completed",
 "canRemoveAllCompleted": false,
 "canMarkAllCompleted": true
}''';

    final listJson = JsonMapper.serialize(list);
    expect(listJson, targetJson);

    final listInstance = JsonMapper.deserialize<TodoList>(listJson);
    expect(list.todos.length, listInstance.todos.length);
    expect(list.canMarkAllCompleted, listInstance.canMarkAllCompleted);
    expect(list.itemsDescription, listInstance.itemsDescription);
  });

  test('TodoList starts with default configuration', () {
    expect(list.todos.length, equals(0));
    expect(list.filter, equals(VisibilityFilter.all));
    expect(list.currentDescription, equals(''));
  });

  test('when a todo is added, the computed properties are updated', () {
    expect(list.todos.length, equals(0));

    list.addTodo('first one');

    expect(list.todos.first.description, equals('first one'));
    expect(list.hasPendingTodos, isTrue);
    expect(list.hasCompletedTodos, isFalse);
  });

  test('when a todo is completed, the computed properties are updated', () {
    list.addTodo('test');

    list.todos.first.done = true;

    expect(list.hasPendingTodos, isFalse);
    expect(list.hasCompletedTodos, isTrue);
  });

  test('when a todo is added, the pendingTodos count increases by 1', () {
    var pendingCount = 0;

    // Setup a when-reaction to update the count
    final d = when((_) => list.pendingTodos.length == 1, () {
      pendingCount++;
    });

    list.addTodo('test');

    expect(pendingCount, equals(1));
    d();
  });

  test('when a todo is removed, the computed properties update', () {
    list.addTodo('first');
    // ignore: cascade_invocations
    list.addTodo('second');

    expect(list.pendingTodos.length, equals(2));

    // ignore: cascade_invocations
    list.removeTodo(list.todos.first);

    expect(list.hasPendingTodos, isTrue);
    expect(list.hasCompletedTodos, isFalse);
    expect(list.pendingTodos.length, equals(1));
    expect(list.completedTodos.length, equals(0));
    expect(list.itemsDescription, equals('1 pending todo, 0 completed'));
  });

  test('when all todos are marked completed, the properties are updated', () {
    list.addTodo('first');
    // ignore: cascade_invocations
    list.addTodo('second');

    // ignore: cascade_invocations
    list.markAllAsCompleted();

    expect(list.hasPendingTodos, isFalse);
    expect(list.hasCompletedTodos, isTrue);
    expect(list.pendingTodos.length, equals(0));
    expect(list.completedTodos.length, equals(2));
    expect(list.itemsDescription, equals('0 pending todos, 2 completed'));
  });

  test('when all todos are removed, the properties are updated', () {
    list.addTodo('first');
    // ignore: cascade_invocations
    list.addTodo('second');

    // ignore: cascade_invocations
    list.markAllAsCompleted();
    // ignore: cascade_invocations
    list.removeCompleted();

    expect(list.hasPendingTodos, isFalse);
    expect(list.hasCompletedTodos, isFalse);
    expect(list.pendingTodos.length, equals(0));
    expect(list.completedTodos.length, equals(0));
    expect(list.itemsDescription,
        equals("There are no Todos here. Why don't you add one?."));
  });

  group('when filter is set to "all"', () {
    setUp(() {
      list = TodoList()..addTodo('first');

      // ignore: cascade_invocations
      list.addTodo('second');
      // ignore: cascade_invocations
      list.addTodo('third');

      // ignore: cascade_invocations
      list.filter = VisibilityFilter.all;
    });

    test('all todos are visible', () {
      expect(list.visibleTodos.length, equals(3));
    });

    test('when there are no completed todos, can-remove-all-completed is false',
        () {
      expect(list.canRemoveAllCompleted, isFalse);
    });

    test('when there are no pending todos, can-mark-all-completed is false',
        () {
      list.markAllAsCompleted(); // no more pending todos
      expect(list.canMarkAllCompleted, isFalse);
    });
  });

  group('when filter is set to "completed"', () {
    setUp(() {
      list = TodoList()..addTodo('first');

      // ignore: cascade_invocations
      list.addTodo('second');
      // ignore: cascade_invocations
      list.addTodo('third');

      list.todos.first.done = true; // only mark the first one completed

      // ignore: cascade_invocations
      list.filter = VisibilityFilter.completed;
    });

    test('only completed todos are visible', () {
      expect(list.visibleTodos.length, equals(1));
    });

    test('batch actions are enabled as appropriate', () {
      expect(list.canRemoveAllCompleted, isTrue);
      expect(list.canMarkAllCompleted, isFalse);
    });
  });

  group('when filter is set to "pending"', () {
    setUp(() {
      list = TodoList()..addTodo('first');

      // ignore: cascade_invocations
      list.addTodo('second');
      // ignore: cascade_invocations
      list.addTodo('third');

      list.todos.first.done = true; // only mark the first one completed

      // ignore: cascade_invocations
      list.filter = VisibilityFilter.pending;
    });

    test('only pending todos are visible', () {
      expect(list.visibleTodos.length, equals(2));
    });

    test('batch actions are enabled as appropriate', () {
      expect(list.canRemoveAllCompleted, isFalse);
      expect(list.canMarkAllCompleted, isTrue);
    });
  });
}
