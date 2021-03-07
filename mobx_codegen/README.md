# mobx_codegen

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
<img height="128" src="https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/flutter-favorite.png">
</a>
<br><br>

[![pub package](https://img.shields.io/pub/v/mobx_codegen.svg?label=mobx_codegen&color=blue)](https://pub.dartlang.org/packages/mobx_codegen)
[![Build Status](https://github.com/mobxjs/mobx.dart/workflows/Build/badge.svg)](https://github.com/mobxjs/mobx.dart/actions)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)

> MobX Code Generation library

Adds support for annotating your MobX code with **`@observable`**, **`@computed`**, **`@action`**, making it
super simple to use MobX.

> Note that these annotations only work inside store-classes.

**store-classes** are abstract and use the **`Store`** mixin. When you run the `build_runner`, it will automatically generate the `*.g.dart file` that must be imported in your file.

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
