# Examples

## Annotations

Annotations drastically simplify the usage of MobX by tastefully tucking away all the boilerplate in the generated files (`*.g.dart`).

> These examples use annotations, which is supported by the [`mobx_codegen`](https://pub.dartlang.org/packages/mobx_codegen) package. To run
> the code-generator, we are using the following command:

```text
$> cd $PATH_TO_MOBX_DART/mobx/example
$> flutter packages pub run build_runner build
```

## Counter ([`counter.dart`](https://github.com/mobxjs/mobx.dart/blob/master/mobx/example/lib/counter.dart))

A really simple **Counter**. After all this is how you start off a Dart/Flutter project :-)

```dart
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = CounterBase with _$Counter;

abstract class CounterBase implements Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}

```

Notice the **`@observable`** `value` property and the **`@action`** `increment()`that mutates it.

## Todos ([`todos.dart`](https://github.com/mobxjs/mobx.dart/blob/master/mobx/example/lib/todos.dart))

This example showcases some of the core features of MobX such as `Observable`, `Computed` and `Action`. We have intentionally left out `Reaction` to keep it simple.

The **Todos** example is a classic way of showcasing a framework or a library. Here, you can see how MobX can simplify your code.

### Todo

A `Todo` entity is at the heart of the **Todos** example. A bit of boilerplate is needed to make the code-generator do the rest for you.

```dart
import 'package:mobx/mobx.dart';

part 'example.g.dart';

class Todo = TodoBase with _$Todo;

abstract class TodoBase implements Store {
  TodoBase(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}

```

#### Observables

The `TodoList` manages the list of `Todo`. Notice the use of annotations to make the code more readable. MobX follows the princple:

> What can be derived, should be derived. Automatically.

This is achieved with a small _core-state_ (the `@observable` properties) and the _derived-state_ (the `@computed` properties).

```dart
enum VisibilityFilter { all, pending, completed }

class TodoList = TodoListBase with _$TodoList;

abstract class TodoListBase implements Store {
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  @observable
  VisibilityFilter filter = VisibilityFilter.all;

  @observable
  String currentDescription = '';

  @computed
  ObservableList<Todo> get pendingTodos =>
      ObservableList.of(todos.where((todo) => todo.done != true));

  @computed
  ObservableList<Todo> get completedTodos =>
      ObservableList.of(todos.where((todo) => todo.done == true));

  @computed
  bool get hasCompletedTodos => completedTodos.isNotEmpty;

  @computed
  bool get hasPendingTodos => pendingTodos.isNotEmpty;

  @computed
  String get itemsDescription =>
      '${pendingTodos.length} pending, ${completedTodos.length} completed';

  @computed
  ObservableList<Todo> get visibleTodos {
    switch (filter) {
      case VisibilityFilter.pending:
        return pendingTodos;
      case VisibilityFilter.completed:
        return completedTodos;
      default:
        return todos;
    }
  }

  // ...
}
```

Notice how you can have `derived-state` that depends on other _derived-state_. For example, **`itemsDescription`** depends on `pendingTodos` and `completedTodos`, which are also computed (aka derived) properties.

#### Actions

The operations that can be performed on the TodoList are marked with `@action`. These are simple functions, which can be invoked like normal dart functions! There is no extra ceremony to invoke an action.

```dart
class TodoList = TodoListBase with _$TodoList;

abstract class TodoListBase implements Store {
  // ...

  @action
  void addTodo(String description) {
    final todo = Todo(description);
    todos.add(todo);
    currentDescription = '';
  }

  @action
  void removeTodo(Todo todo) {
    todos.removeWhere((x) => x == todo);
  }

  @action
  void changeDescription(String description) =>
      currentDescription = description;

  @action
  void changeFilter(VisibilityFilter filter) => this.filter = filter;

  @action
  void removeCompleted() {
    todos.removeWhere((todo) => todo.done);
  }

  @action
  void markAllAsCompleted() {
    for (final todo in todos) {
      todo.done = true;
    }
  }
}

```
