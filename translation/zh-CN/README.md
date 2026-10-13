语言: [英语](../../README.md) | [葡萄牙语](../pt-BR/README.md) | [中文](README.md) | [日语](translation/ja-JP/README.md) | [韩语](translation/ko-KR/README.md)

# mobx.dart

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
<img height="128" src="https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/flutter-favorite.png">
</a>
<br><br>

[![pub package](https://img.shields.io/pub/v/mobx.svg?label=mobx&color=blue)](https://pub.dartlang.org/packages/mobx)
[![pub package](https://img.shields.io/pub/v/flutter_mobx.svg?label=flutter_mobx&color=blue)](https://pub.dartlang.org/packages/flutter_mobx)
[![pub package](https://img.shields.io/pub/v/mobx_codegen.svg?label=mobx_codegen&color=blue)](https://pub.dartlang.org/packages/mobx_codegen)

[![Build Status](https://github.com/mobxjs/mobx.dart/workflows/Build/badge.svg)](https://github.com/mobxjs/mobx.dart/actions)
[![Publish](https://github.com/mobxjs/mobx.dart/workflows/Publish/badge.svg)](https://github.com/mobxjs/mobx.dart/actions)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)
[![Netlify Status](https://api.netlify.com/api/v1/badges/05330d31-0411-4aac-a278-76615bcaff9e/deploy-status)](https://app.netlify.com/sites/mobx/deploys)

[![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)

![](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx.png)

[MobX](https://github.com/mobxjs/mobx) Dart语言版本.

> 通过使用透明的函数响应式编程（TFRP）加强你的 Dart 应用中的状态管理。

- **[介绍](#介绍)**
- **[核心概念](#核心概念)**
  - [可观察对象（Observables）](#可观察对象（Observables）)
  - [可计算观察对象（Computed Observables）](#可计算观察对象（Computed&nbsp;Observables）)
  - [动作（Actions）](#动作（Actions）)
  - [反应（Reactions）](#反应（Reactions）)
- **[如何贡献](#如何贡献)**

## 介绍

MobX是一种状态管理库，它让应用程序的响应式数据与 UI 关联起来变得很简单。
这种关联是完全自动的，感觉像是自然发生的一样。作为应用程序开发人员，您仅关注于需要在 UI（或其他任何地方）中使用哪些响应式数据，而不必担心使两者保持同步。

这并不是真正的魔术，但是它确实对正在消费的（可观察的对象）和在哪里（反应）有一些了解，并会自动为您跟踪。当观察对象值改变时，所有反应都将重新运行。有趣的是，从简单的控制台日志，网络调用到重新呈现 UI，这些反应可以是任何东西。

> MobX 的 JavaScript 版本非常成熟。
> 应用程序和 Dart 语言的这种移植旨在带来相同水平的生产力。

### 赞助商

我们非常感谢赞助商们，能够让我们成为其开源软件（OSS）计划的一部分。 [[Become a sponsor](https://opencollective.com/mobx#sponsor)]

- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/publicis-sapient-sponsor.png" height="64">](https://publicis.sapient.com)
- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/wunderdog-sponsor.png" height="64">](https://wunderdog.fi)
- [<img src="https://www.netlify.com/img/global/badges/netlify-color-bg.svg" height="64">](https://www.netlify.com)

### 开始

[MobX.dart 官网的入门指南](https://mobx.netlify.app/getting-started).

### 深入

更深入地学习 Mob，请看 [MobX 快速入门指南](https://www.packtpub.com/web-development/mobx-quick-start-guide). 虽然这本书使用的是 JavaScript 版本的 MobX，但是核心的概念是完全适用于 Dart 和 Flutter 版本的。

[![](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/book.png)](https://www.packtpub.com/web-development/mobx-quick-start-guide)

## 核心概念

![MobX Triad](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx-triad.png)

MobX 的核心是三个重要的概念：可观察的对象（Observables），动作（Actions）和反应（Reactions）。

### 可观察对象（Observables）

可观察对象表示应用程序的响应式状态。它们可以是复杂对象树的简单标量。通过将应用程序的状态定义为可观察树，您可以暴露一个 UI（或应用程序中的其他观察者）使用的_reactive-state-tree_。

一个简单的响应式计数器由以下可观察对象表示：

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

也可以创建更复杂的可观察对象，例如类。

```dart
class Counter {
  Counter() {
    increment = Action(_increment);
  }

  final _value = Observable(0);
  int get value => _value.value;

  set value(int newValue) => _value.value = newValue;
  Action increment;

  void _increment() {
    _value.value++;
  }
}
```

乍一看，这看起来确实有些模板代码，它们很快就会失去控制！
这就是为什么我们添加 **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** 的原因，该组合允许您将上面的代码替换为以下代码：

```dart
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = CounterBase with _$Counter;

abstract class CounterBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
```

请注意使用批注来标记类的可观察属性。是的，这里有一些类似头部的样板代码，但它适用于任何类。当您构建更复杂的类时，这样的样板将逐渐消失在您的视野中，您将主要关注您的业务代码。

**注意**：注释可通过 **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** 软件包获得。

### 可计算观察对象（Computed Observables）

> 什么可以被计算，什么应该被计算。保持自动化！

您的应用程序的状态包含 **核心状态** 和 **派生状态** 。核心状态是您正在处理的域所固有的状态。例如，如果您有一个 `Contact` 实体，则 `firstName` 和 `lastName` 构成Contact的核心状态。但是，`fullName` 是派生状态，是通过组合 `firstName` 和 `lastName` 获得的。

这种依赖于核心状态或其他派生状态的派生状态称为 **可计算观察对象**。当其观察的对象更改时，它会自动保持同步。

> MobX 中的状态 = 核心状态 + 派生状态

```dart
import 'package:mobx/mobx.dart';

part 'contact.g.dart';

class Contact = ContactBase with _$Contact;

abstract class ContactBase with Store {
  @observable
  String firstName;

  @observable
  String lastName;

  @computed
  String get fullName => '$firstName, $lastName';

}
```

在上面的示例中，如果 `firstName` 或 `lastName` 更改，则 `fullName` 将自动保持同步。

### 动作（Actions）

动作即您将如何改变可观察对象。动作不是直接对其进行更改，而是为这个更改添加了语义，例如，触发一个 `increment()` 操作不只是执行 `value++`，还可以具有更多含义。此外，动作还分批处理所有通知，并确保仅在更改完成后通知观察对象进行更改。因此，仅在一个原子性的动作完成时观察者才收到通知。

请注意，动作也可以嵌套，在这种情况下，最外层的动作完成后通知会发出。

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

你可以用修饰符在一个类里创建动作！

```dart
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = CounterBase with _$Counter;

abstract class CounterBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
```

#### 异步的动作

MobX.dart 自动处理异步操作，不需要使用 [`runInAction`](https://mobx.netlify.com/api/action#runinaction) 包装代码。

```dart
@observable
String stuff = '';

@observable
loading = false;

@action
Future<void> loadStuff() async {
  loading = true; //This notifies observers
  stuff = await fetchStuff();
  loading = false; //This also notifies observers
}
```

### 反应（Reactions）

有了反应，MobX 可观察性，动作和反应即可形成闭环。他们是响应式系统的观察者，只要他们跟踪的可观察对象发生变化，它们就会得到通知。下表列出了几种反应。它们全部返回 `ReactionDisposer`，可以调用该函数来处理反应。

反应的一个显着特征是它们无需明确地设置关联即可自动跟踪所有可观察对象。直接从反应中读取可观察对象的值，就足以跟踪它的最新状态！

> 您用 MobX 编写的代码似乎完全没有仪式！

**`ReactionDisposer autorun(Function(Reaction) fn)`**

立即运行反应，也可以对 `fn` 内部使用的可观察值进行任何更改。

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

final dispose = autorun((_){
  print(greeting.value);
});

greeting.value = 'Hello MobX';

// Done with the autorun()
dispose();


// Prints:
// Hello World
// Hello MobX
```

**`ReactionDisposer reaction<T>(T Function(Reaction) predicate, void Function(T) effect)`**

监视 `predicate()` 函数内部使用的可观察对象，并在 predicate 返回不同值时运行`effect()`。仅跟踪 `predicate` 中的可观察对象。

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

final dispose = reaction((_) => greeting.value, (msg) => print(msg));

greeting.value = 'Hello MobX'; // Cause a change

// Done with the reaction()
dispose();


// Prints:
// Hello MobX
```

**`ReactionDisposer when(bool Function(Reaction) predicate, void Function() effect)`**

监视 `predicate()` 内部使用的可观察对象，并在返回 `true` 时运行 `effect()`。运行`effect()` 后，`when` 自动执行。因此，您可以将 `when` 视为一个一次性的反应。您也可以更早地执行 `when()`。

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

final dispose = when((_) => greeting.value == 'Hello MobX', () => print('Someone greeted MobX'));

greeting.value = 'Hello MobX'; // Causes a change, runs effect and disposes


// Prints:
// Someone greeted MobX
```

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

与 `when` 相似，但返回的类型是 `Future`，并且是在 `predicate()`返回 `true` 时执行。这是一个简单的等待 `predicate()` 变为 `true` 的方法。

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => _completed.value == true);

  print('Completed');
}
```

**Observer**

应用程序中最直观的反应之一就是 UI。**Observer**（属于 **[`flutter_mobx`](https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx)** 包的一部分）的 `builder` 函数中提供了可观察对象的观察器，只要这些可观察对象发生变化，`Observer` 就会重建并渲染。

下面是完整的计算器示例代码。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = CounterBase with _$Counter;

abstract class CounterBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}

class CounterExample extends StatefulWidget {
  const CounterExample({Key key}) : super(key: key);

  @override
  _CounterExampleState createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  final _counter = Counter();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Observer(
                  builder: (_) => Text(
                        '${_counter.value}',
                        style: const TextStyle(fontSize: 20),
                      )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _counter.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
```

## 如何贡献

恭喜您已经读到这里🎉🎉🎉。您可以通过几种方式为不断增长的 `MobX.dart` 社区做出贡献。

- 负责被标注为 ["good first issue"](https://github.com/mobxjs/mobx.dart/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) 的 issue
- 提出功能、质量提升类型的建议
- 发现并报告 bug
- 修复 bug
- 参与讨论并帮助做决策
- 编写并提升文档，文档是至关重要的！
- 提交 Pull Request
- 参与 [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)

## 贡献者 ✨

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-34-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

感谢棒棒哒小伙伴们！ ([emoji key](https://allcontributors.org/docs/en/emoji-key))：

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/pavanpodila"><img src="https://avatars0.githubusercontent.com/u/156846?v=4" width="64px;" alt=""/><br /><sub><b>Pavan Podila</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=pavanpodila" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=pavanpodila" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Apavanpodila" title="Reviewed Pull Requests">👀</a></td>
    <td align="center"><a href="https://github.com/katis"><img src="https://avatars1.githubusercontent.com/u/877226?v=4" width="64px;" alt=""/><br /><sub><b>katis</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=katis" title="Code">💻</a> <a href="#ideas-katis" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Akatis" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=katis" title="Tests">⚠️</a></td>
    <td align="center"><a href="https://github.com/shyndman"><img src="https://avatars1.githubusercontent.com/u/42326?v=4" width="64px;" alt=""/><br /><sub><b>Scott Hyndman</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=shyndman" title="Code">💻</a> <a href="#ideas-shyndman" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Ashyndman" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=shyndman" title="Tests">⚠️</a></td>
    <td align="center"><a href="https://dexterx.dev"><img src="https://avatars1.githubusercontent.com/u/25263378?v=4" width="64px;" alt=""/><br /><sub><b>Michael Bui</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=MaikuB" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=MaikuB" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3AMaikuB" title="Reviewed Pull Requests">👀</a> <a href="#example-MaikuB" title="Examples">💡</a></td>
    <td align="center"><a href="https://github.com/rrousselGit"><img src="https://avatars3.githubusercontent.com/u/20165741?v=4" width="64px;" alt=""/><br /><sub><b>Remi Rousselet</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=rrousselGit" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=rrousselGit" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3ArrousselGit" title="Reviewed Pull Requests">👀</a></td>
    <td align="center"><a href="https://github.com/adiakhaitan"><img src="https://avatars2.githubusercontent.com/u/20572621?v=4" width="64px;" alt=""/><br /><sub><b>adiaKhaitan</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=adiakhaitan" title="Documentation">📖</a></td>
    <td align="center"><a href="https://flutterando.com.br"><img src="https://avatars2.githubusercontent.com/u/4047813?v=4" width="64px;" alt=""/><br /><sub><b>Jacob Moura</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=jacobaraujo7" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=jacobaraujo7" title="Documentation">📖</a> <a href="#translation-jacobaraujo7" title="Translation">🌍</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://www.faladevs.com"><img src="https://avatars2.githubusercontent.com/u/30571368?v=4" width="64px;" alt=""/><br /><sub><b>Daniel Albuquerque</b></sub></a><br /><a href="#translation-dmAlbuquerque" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/marcoms"><img src="https://avatars0.githubusercontent.com/u/4211302?v=4" width="64px;" alt=""/><br /><sub><b>Marco Scannadinari</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=marcoms" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/lsaudon"><img src="https://avatars3.githubusercontent.com/u/25029876?v=4" width="64px;" alt=""/><br /><sub><b>lsaudon</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=lsaudon" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=lsaudon" title="Documentation">📖</a></td>
    <td align="center"><a href="http://efthymis.com"><img src="https://avatars1.githubusercontent.com/u/633903?v=4" width="64px;" alt=""/><br /><sub><b>Efthymis Sarmpanis</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=esarbanis" title="Code">💻</a></td>
    <td align="center"><a href="http://thewebstorebyg.wordpress.com/"><img src="https://avatars0.githubusercontent.com/u/2689410?v=4" width="64px;" alt=""/><br /><sub><b>Giri Jeedigunta</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=giri-jeedigunta" title="Documentation">📖</a> <a href="#example-giri-jeedigunta" title="Examples">💡</a></td>
    <td align="center"><a href="https://github.com/hramnathnayak"><img src="https://avatars2.githubusercontent.com/u/33794330?v=4" width="64px;" alt=""/><br /><sub><b>Hebri Ramnath Nayak</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=hramnathnayak" title="Documentation">📖</a></td>
    <td align="center"><a href="https://youtube.com/c/robertbrunhage"><img src="https://avatars3.githubusercontent.com/u/26344867?v=4" width="64px;" alt=""/><br /><sub><b>Robert Brunhage</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=RobertBrunhage" title="Documentation">📖</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/bradyt"><img src="https://avatars0.githubusercontent.com/u/6107051?v=4" width="64px;" alt=""/><br /><sub><b>Brady Trainor</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=bradyt" title="Documentation">📖</a></td>
    <td align="center"><a href="https://kush3107.github.io/"><img src="https://avatars3.githubusercontent.com/u/11977323?v=4" width="64px;" alt=""/><br /><sub><b>Kushagra Saxena</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=kush3107" title="Documentation">📖</a> <a href="#example-kush3107" title="Examples">💡</a></td>
    <td align="center"><a href="https://patreon.com/pedromassango"><img src="https://avatars1.githubusercontent.com/u/33294549?v=4" width="64px;" alt=""/><br /><sub><b>Pedro Massango</b></sub></a><br /><a href="#translation-pedromassango" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/peteyycz"><img src="https://avatars1.githubusercontent.com/u/7130689?v=4" width="64px;" alt=""/><br /><sub><b>Peter Czibik</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=peteyycz" title="Code">💻</a></td>
    <td align="center"><a href="https://luan.xyz"><img src="https://avatars0.githubusercontent.com/u/882703?v=4" width="64px;" alt=""/><br /><sub><b>Luan Nico</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=luanpotter" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/kobiburnley"><img src="https://avatars3.githubusercontent.com/u/7372363?v=4" width="64px;" alt=""/><br /><sub><b>Kobi</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=kobiburnley" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/chimon2000"><img src="https://avatars1.githubusercontent.com/u/6907797?v=4" width="64px;" alt=""/><br /><sub><b>Ryan</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=chimon2000" title="Documentation">📖</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://www.upwork.com/freelancers/~01192eefd8a1c267f7"><img src="https://avatars1.githubusercontent.com/u/231950?v=4" width="64px;" alt=""/><br /><sub><b>Ivan Terekhin</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=JEuler" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/yoavrofe"><img src="https://avatars2.githubusercontent.com/u/367621?v=4" width="64px;" alt=""/><br /><sub><b>Yoav Rofé</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=yoavrofe" title="Documentation">📖</a></td>
    <td align="center"><a href="https://twitter.com/matiwojt"><img src="https://avatars1.githubusercontent.com/u/20087150?v=4" width="64px;" alt=""/><br /><sub><b>Mateusz Wojtczak</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=wojtczakmat" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/t-artikov"><img src="https://avatars1.githubusercontent.com/u/1927992?v=4" width="64px;" alt=""/><br /><sub><b>Timur Artikov</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=t-artikov" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/sohonisaurabh"><img src="https://avatars1.githubusercontent.com/u/20185422?v=4" width="64px;" alt=""/><br /><sub><b>Saurabh Sohoni</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=sohonisaurabh" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/renanzdm"><img src="https://avatars0.githubusercontent.com/u/47435996?v=4" width="64px;" alt=""/><br /><sub><b>renanzdm</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=renanzdm" title="Documentation">📖</a></td>
    <td align="center"><a href="http://croogo.org"><img src="https://avatars3.githubusercontent.com/u/39490?v=4" width="64px;" alt=""/><br /><sub><b>Rachman Chavik</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=rchavik" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/Vardiak"><img src="https://avatars0.githubusercontent.com/u/19309601?v=4" width="64px;" alt=""/><br /><sub><b>Nathan Cabasso</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/issues?q=author%3AVardiak" title="Bug reports">🐛</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=Vardiak" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/geisterfurz007"><img src="https://avatars1.githubusercontent.com/u/26303198?v=4" width="64px;" alt=""/><br /><sub><b>geisterfurz007</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=geisterfurz007" title="Documentation">📖</a> <a href="#content-geisterfurz007" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/hawkbee1"><img src="https://avatars1.githubusercontent.com/u/49282360?&v=4" width="64px;" alt=""/><br /><sub><b>Romuald Barbe</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=hawkbee1" title="Code">💻</a></td>
    <td align="center"><a href="https://www.linkedin.com/in/alexander-mazuruk"><img src="https://avatars0.githubusercontent.com/u/18071010?v=4" width="64px;" alt=""/><br /><sub><b>Alexander Mazuruk</b></sub></a><br /><a href="#example-k-paxian" title="Examples">💡</a></td>
    <td align="center"><a href="http://www.albertobonacina.com"><img src="https://avatars1.githubusercontent.com/u/202140?v=4" width="64px;" alt=""/><br /><sub><b>Alberto Bonacina</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=polilluminato" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/phen0menon"><img src="https://avatars3.githubusercontent.com/u/15520523?v=4" width="64px;" alt=""/><br /><sub><b>Roland Ibragimov</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=phen0menon" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

这个项目遵循 [all-contributors](https://github.com/all-contributors/all-contributors) 规范。欢迎大家以各种形式进行贡献！

