# mobx_codegen

[![pub package](https://img.shields.io/pub/v/mobx_codegen.svg?label=mobx_codegen&color=blue)](https://pub.dartlang.org/packages/mobx_codegen)
[![CircleCI](https://circleci.com/gh/mobxjs/mobx.dart.svg?style=svg)](https://circleci.com/gh/mobxjs/mobx.dart)

> MobX Code Generation library

Adds support for annotating your MobX code with **`@observable`**, **`@computed`**, **`@action`**, making it
super simple to use MobX.

> Note that these annotations only work inside store-classes.

**store-classes** are abstract and implement the **`Store`** interface. When you run the `build_runner`, it will automatically generate the `*.g.dart file` that must be imported in your file.

```
$> cd $YOUR_PROJECT_DIR
$> flutter packages pub run build_runner build
```

### Example

```dart
import 'package:mobx/mobx.dart';

// Include generated file
part 'todos.g.dart';

// This is the class used by rest of your codebase
class Todo = TodoBase with _$Todo;

// The store-class
abstract class TodoBase with Store {
  TodoBase(this.description);

  @observable
  String description = '';

  @observable
  bool done = false;
}
```
