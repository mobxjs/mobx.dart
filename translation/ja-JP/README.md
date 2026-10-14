言語: [英語](../../README.md) | [ポルトガル語](../pt-BR/README.md) | [中国語](../zh-CN/README.md) | [日本語](README.md) | [韓国語](translation/ko-KR/README.md)

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

[MobX](https://github.com/mobxjs/mobx) の Dart 言語バージョン。

> 透明な関数型リアクティブプログラミング（TFRP）を使用して、Dart アプリの状態管理を強化します。

- **[紹介](#紹介)**
- **[コアコンセプト](#コアコンセプト)**
  - [オブザーバブル（Observables）](#オブザーバブル（Observables）)
  - [計算オブザーバブル（Computed Observables）](#計算オブザーバブル（Computed&nbsp;Observables）)
  - [アクション（Actions）](#アクション（Actions）)
  - [リアクション（Reactions）](#リアクション（Reactions）)
- **[貢献](#貢献)**

## 紹介

MobX は、アプリケーションのリアクティブデータを UI に簡単に接続できる状態管理ライブラリです。
この接続は完全に自動であり、非常に自然に感じられます。アプリケーション開発者として、UI（および他の場所）で消費する必要があるリアクティブデータに純粋に集中し、両者を同期させることを心配する必要はありません。

これは本当に魔法ではありませんが、消費されているもの（オブザーバブル）とどこで（リアクション）に関するいくつかのスマートな機能があり、自動的に追跡します。オブザーバブルが変更されると、すべてのリアクションが再実行されます。興味深いのは、これらのリアクションは、単純なコンソールログ、ネットワーク呼び出しから UI の再レンダリングまで、何でもかまわないということです。

> MobX は JavaScript アプリにとって非常に効果的なライブラリであり、Dart 言語へのこの移植は同じレベルの生産性をもたらすことを目的としています。

### スポンサー

私たちのスポンサーに非常に感謝しています。彼らのおかげで、私たちはオープンソースソフトウェア（OSS）プログラムの一部になることができました。 [[スポンサーになる](https://opencollective.com/mobx#sponsor)]

- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/publicis-sapient-sponsor.png" height="64">](https://publicis.sapient.com)
- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/wunderdog-sponsor.png" height="64">](https://wunderdog.fi)
- [<img src="https://www.netlify.com/img/global/badges/netlify-color-bg.svg" height="64">](https://www.netlify.com)

### 始める

[MobX.dart 公式サイトの入門ガイド](https://mobx.netlify.app/getting-started).

### 深く掘り下げる

MobX をより深く理解するには、[MobX クイックスタートガイド](https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837) をご覧ください。この本は JavaScript バージョンの MobX を使用していますが、コアの概念は Dart および Flutter バージョンにも完全に適用できます。

[![MobX クイックスタートガイドの表紙](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/book.png)](https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837)

## コアコンセプト

![MobX Triad](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx-triad.png)

MobX の中心には、オブザーバブル（Observables）、アクション（Actions）、リアクション（Reactions）という 3 つの重要な概念があります。

### オブザーバブル（Observables）

オブザーバブルは、アプリケーションのリアクティブ状態を表します。これらは、単純なスカラーから複雑なオブジェクトツリーまでさまざまです。アプリケーションの状態をオブザーバブルのツリーとして定義することにより、UI（またはアプリ内の他のオブザーバー）が使用するリアクティブ状態ツリーを公開できます。

単純なリアクティブカウンターは、次のオブザーバブルで表されます。

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

クラスなどのより複雑なオブザーバブルも作成できます。

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

一見すると、これはすぐに手に負えなくなるテンプレートコードのように見えます！
これが、上記のコードを次のコードに置き換えることができる **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** を追加した理由です。

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

クラスのオブザーバブルプロパティをマークするために注釈を使用することに注意してください。はい、ここにはヘッダーのテンプレートコードがありますが、これはどのクラスにも固定されています。より複雑なクラスを構築するにつれて、このテンプレートコードは消え、主に中括弧内のコードに集中するようになります。

**注意**：注釈は **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** パッケージを介して利用できます。

### 計算オブザーバブル（Computed Observables）

> 何が計算できるか、何が計算されるべきか。自動的に。

アプリケーションの状態は、コア状態と派生状態で構成されます。コア状態は、あなたが扱っているドメインに固有の状態です。たとえば、`Contact` エンティティがある場合、`firstName` と `lastName` は `Contact` のコア状態を形成します。ただし、`fullName` は派生状態であり、`firstName` と `lastName` を組み合わせることによって取得されます。

このようなコア状態または他の派生状態に依存する派生状態は、計算オブザーバブルと呼ばれます。基になるオブザーバブルが変更されると、自動的に同期されます。

> MobX の状態 = コア状態 + 派生状態

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

上記の例では、`firstName` または `lastName` が変更されると、`fullName` は自動的に同期されます。

### アクション（Actions）

アクションは、オブザーバブルをどのように変更するかを示します。オブザーバブルを直接変更するのではなく、アクションは変更に意味を追加します。たとえば、単に `value++` を実行するのではなく、`increment()` アクションを発行する方が意味があります。さらに、アクションはすべての通知をバッチ処理し、完了後に変更が通知されるようにします。
したがって、オブザーバーはアクションの原子操作が完了したときにのみ通知されます。

アクションはネストすることもでき、最上位のアクションが完了すると通知が送信されます。

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

クラス内でアクションを作成するときは、注釈を利用できます！

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

#### 非同期アクション

MobX.dart は非同期アクションを自動的に処理し、[`runInAction`](https://mobx.netlify.com/api/action#runinaction) でコードをラップする必要はありません。

```dart
@observable
String stuff = '';

@observable
bool loading = false;

@action
Future<void> loadStuff() async {
  loading = true; //This notifies observers
  stuff = await fetchStuff();
  loading = false; //This also notifies observers
}
```

### リアクション（Reactions）

リアクションは、オブザーバブル、アクション、リアクションの MobX トライアドを完成させます。これらはリアクティブシステムのオブザーバーであり、追跡しているオブザーバブルが変更されると通知されます。リアクションには、以下にリストされているいくつかのフレーバーがあります。すべて `ReactionDisposer` を返します。これは、リアクションを破棄するために呼び出すことができる関数です。

リアクションの際立った特徴の 1 つは、明示的な配線なしで、すべてのオブザーバブルを自動的に追跡することです。リアクション内でオブザーバブルを読み取る行為だけで、それを追跡するのに十分です！

> MobX を使用して記述したコードは、文字通り儀式がないように見えます！

**`ReactionDisposer autorun(Function(Reaction) fn)`**

リアクションをすぐに実行し、`fn` 内で使用されるオブザーバブルの変更時にも実行します。

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

`predicate()` 関数内で使用されるオブザーバブルを監視し、predicate が異なる値を返すと `effect()` を実行します。`predicate` 内のオブザーバブルのみが追跡されます。

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

`predicate()` 内で使用されるオブザーバブルを監視し、`true` を返すと `effect()` を実行します。`effect()` が実行されると、`when` は自動的に破棄されます。したがって、`when` をワンタイムリアクションと見なすことができます。`when()` を早期に破棄することもできます。

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

final dispose = when((_) => greeting.value == 'Hello MobX', () => print('Someone greeted MobX'));

greeting.value = 'Hello MobX'; // Causes a change, runs effect and disposes


// Prints:
// Someone greeted MobX
```

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

`when` と似ていますが、`Future` を返します。これは、`predicate()` が `true` を返すと完了します。これは、`predicate()` が `true` になるのを待つ便利な方法です。

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => _completed.value == true);

  print('Completed');
}
```

**Observer**

アプリで最も視覚的なリアクションの 1 つは UI です。**Observer** ウィジェット（**[`flutter_mobx`](https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx)** パッケージの一部）は、`builder` 関数で使用されるオブザーバブルの細かいオブザーバーを提供します。これらのオブザーバブルが変更されると、`Observer` は再構築されてレンダリングされます。

以下は、カウンターの例の全体です。

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

## 貢献

ここまで読んでいただきありがとうございます🎉🎉🎉。成長し続ける `MobX.dart` コミュニティに貢献する方法はいくつかあります。

- ["good first issue"](https://github.com/mobxjs/mobx.dart/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) とマークされた問題を選択します
- 機能、品質向上の提案を行う
- バグを報告する
- バグを修正する
- 議論に参加し、意思決定を支援する
- ドキュメントを作成および改善します。ドキュメントは非常に重要であり、その重要性は言うまでもありません！
- プルリクエストを送信する
- 参加して [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)

## 貢献者 ✨

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-34-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

これらの素晴らしい人々に感謝します！ ([絵文字キー](https://allcontributors.org/docs/en/emoji-key))：

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/pavanpodila"><img src="https://avatars0.githubusercontent.com/u/156846?v=4?s=64" width="64px;" alt="Pavan Podila"/><br /><sub><b>Pavan Podila</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=pavanpodila" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=pavanpodila" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Apavanpodila" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/katis"><img src="https://avatars1.githubusercontent.com/u/877226?v=4?s=64" width="64px;" alt="katis"/><br /><sub><b>katis</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=katis" title="Code">💻</a> <a href="#ideas-katis" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Akatis" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=katis" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/shyndman"><img src="https://avatars1.githubusercontent.com/u/42326?v=4?s=64" width="64px;" alt="Scott Hyndman"/><br /><sub><b>Scott Hyndman</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=shyndman" title="Code">💻</a> <a href="#ideas-shyndman" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Ashyndman" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=shyndman" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://dexterx.dev"><img src="https://avatars1.githubusercontent.com/u/25263378?v=4?s=64" width="64px;" alt="Michael Bui"/><br /><sub><b>Michael Bui</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=MaikuB" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=MaikuB" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3AMaikuB" title="Reviewed Pull Requests">👀</a> <a href="#example-MaikuB" title="Examples">💡</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/rrousselGit"><img src="https://avatars3.githubusercontent.com/u/20165741?v=4?s=64" width="64px;" alt="Remi Rousselet"/><br /><sub><b>Remi Rousselet</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=rrousselGit" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=rrousselGit" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3ArrousselGit" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/adiakhaitan"><img src="https://avatars2.githubusercontent.com/u/20572621?v=4?s=64" width="64px;" alt="adiaKhaitan"/><br /><sub><b>adiaKhaitan</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=adiakhaitan" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://flutterando.com.br"><img src="https://avatars2.githubusercontent.com/u/4047813?v=4?s=64" width="64px;" alt="Jacob Moura"/><br /><sub><b>Jacob Moura</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=jacobaraujo7" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=jacobaraujo7" title="Documentation">📖</a> <a href="#translation-jacobaraujo7" title="Translation">🌍</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.faladevs.com"><img src="https://avatars2.githubusercontent.com/u/30571368?v=4?s=64" width="64px;" alt="Daniel Albuquerque"/><br /><sub><b>Daniel Albuquerque</b></sub></a><br /><a href="#translation-dmAlbuquerque" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/marcoms"><img src="https://avatars0.githubusercontent.com/u/4211302?v=4?s=64" width="64px;" alt="Marco Scannadinari"/><br /><sub><b>Marco Scannadinari</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=marcoms" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lsaudon"><img src="https://avatars3.githubusercontent.com/u/25029876?v=4?s=64" width="64px;" alt="lsaudon"/><br /><sub><b>lsaudon</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=lsaudon" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=lsaudon" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://efthymis.com"><img src="https://avatars1.githubusercontent.com/u/633903?v=4?s=64" width="64px;" alt="Efthymis Sarmpanis"/><br /><sub><b>Efthymis Sarmpanis</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=esarbanis" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://thewebstorebyg.wordpress.com/"><img src="https://avatars0.githubusercontent.com/u/2689410?v=4?s=64" width="64px;" alt="Giri Jeedigunta"/><br /><sub><b>Giri Jeedigunta</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=giri-jeedigunta" title="Documentation">📖</a> <a href="#example-giri-jeedigunta" title="Examples">💡</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hramnathnayak"><img src="https://avatars2.githubusercontent.com/u/33794330?v=4?s=64" width="64px;" alt="Hebri Ramnath Nayak"/><br /><sub><b>Hebri Ramnath Nayak</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=hramnathnayak" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://youtube.com/c/robertbrunhage"><img src="https://avatars3.githubusercontent.com/u/26344867?v=4?s=64" width="64px;" alt="Robert Brunhage"/><br /><sub><b>Robert Brunhage</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=RobertBrunhage" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/bradyt"><img src="https://avatars0.githubusercontent.com/u/6107051?v=4?s=64" width="64px;" alt="Brady Trainor"/><br /><sub><b>Brady Trainor</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=bradyt" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://kush3107.github.io/"><img src="https://avatars3.githubusercontent.com/u/11977323?v=4?s=64" width="64px;" alt="Kushagra Saxena"/><br /><sub><b>Kushagra Saxena</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=kush3107" title="Documentation">📖</a> <a href="#example-kush3107" title="Examples">💡</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://patreon.com/pedromassango"><img src="https://avatars1.githubusercontent.com/u/33294549?v=4?s=64" width="64px;" alt="Pedro Massango"/><br /><sub><b>Pedro Massango</b></sub></a><br /><a href="#translation-pedromassango" title="Translation">🌍</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/peteyycz"><img src="https://avatars1.githubusercontent.com/u/7130689?v=4?s=64" width="64px;" alt="Peter Czibik"/><br /><sub><b>Peter Czibik</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=peteyycz" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://luan.xyz"><img src="https://avatars0.githubusercontent.com/u/882703?v=4?s=64" width="64px;" alt="Luan Nico"/><br /><sub><b>Luan Nico</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=luanpotter" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kobiburnley"><img src="https://avatars3.githubusercontent.com/u/7372363?v=4?s=64" width="64px;" alt="Kobi"/><br /><sub><b>Kobi</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=kobiburnley" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/chimon2000"><img src="https://avatars1.githubusercontent.com/u/6907797?v=4?s=64" width="64px;" alt="Ryan"/><br /><sub><b>Ryan</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=chimon2000" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.upwork.com/freelancers/~01192eefd8a1c267f7"><img src="https://avatars1.githubusercontent.com/u/231950?v=4?s=64" width="64px;" alt="Ivan Terekhin"/><br /><sub><b>Ivan Terekhin</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=JEuler" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/yoavrofe"><img src="https://avatars2.githubusercontent.com/u/367621?v=4?s=64" width="64px;" alt="Yoav Rofé"/><br /><sub><b>Yoav Rofé</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=yoavrofe" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://twitter.com/matiwojt"><img src="https://avatars1.githubusercontent.com/u/20087150?v=4?s=64" width="64px;" alt="Mateusz Wojtczak"/><br /><sub><b>Mateusz Wojtczak</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=wojtczakmat" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/t-artikov"><img src="https://avatars1.githubusercontent.com/u/1927992?v=4?s=64" width="64px;" alt="Timur Artikov"/><br /><sub><b>Timur Artikov</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=t-artikov" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sohonisaurabh"><img src="https://avatars1.githubusercontent.com/u/20185422?v=4?s=64" width="64px;" alt="Saurabh Sohoni"/><br /><sub><b>Saurabh Sohoni</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=sohonisaurabh" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/renanzdm"><img src="https://avatars0.githubusercontent.com/u/47435996?v=4?s=64" width="64px;" alt="renanzdm"/><br /><sub><b>renanzdm</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=renanzdm" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://croogo.org"><img src="https://avatars3.githubusercontent.com/u/39490?v=4?s=64" width="64px;" alt="Rachman Chavik"/><br /><sub><b>Rachman Chavik</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=rchavik" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Vardiak"><img src="https://avatars0.githubusercontent.com/u/19309601?v=4?s=64" width="64px;" alt="Nathan Cabasso"/><br /><sub><b>Nathan Cabasso</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/issues?q=author%3AVardiak" title="Bug reports">🐛</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=Vardiak" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/geisterfurz007"><img src="https://avatars1.githubusercontent.com/u/26303198?v=4?s=64" width="64px;" alt="geisterfurz007"/><br /><sub><b>geisterfurz007</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=geisterfurz007" title="Documentation">📖</a> <a href="#content-geisterfurz007" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hawkbee1"><img src="https://avatars1.githubusercontent.com/u/49282360?&v=4?s=64" width="64px;" alt="Romuald Barbe"/><br /><sub><b>Romuald Barbe</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=hawkbee1" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/alexander-mazuruk"><img src="https://avatars0.githubusercontent.com/u/18071010?v=4?s=64" width="64px;" alt="Alexander Mazuruk"/><br /><sub><b>Alexander Mazuruk</b></sub></a><br /><a href="#example-k-paxian" title="Examples">💡</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.albertobonacina.com"><img src="https://avatars1.githubusercontent.com/u/202140?v=4?s=64" width="64px;" alt="Alberto Bonacina"/><br /><sub><b>Alberto Bonacina</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=polilluminato" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/phen0menon"><img src="https://avatars3.githubusercontent.com/u/15520523?v=4?s=64" width="64px;" alt="Roland Ibragimov"/><br /><sub><b>Roland Ibragimov</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=phen0menon" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://gitconnected.com/bsdfzzzy"><img src="https://avatars1.githubusercontent.com/u/11622770?v=4?s=64" width="64px;" alt="zyzhao"/><br /><sub><b>zyzhao</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=bsdfzzzy" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/xinhaiwang"><img src="https://avatars0.githubusercontent.com/u/20069410?v=4?s=64" width="64px;" alt="Xinhai Wang"/><br /><sub><b>Xinhai Wang</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=xinhaiwang" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hmayer00"><img src="https://avatars0.githubusercontent.com/u/821904?v=4?s=64" width="64px;" alt="Henry Mayer"/><br /><sub><b>Henry Mayer</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=hmayer00" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=hmayer00" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/darkstarx"><img src="https://avatars3.githubusercontent.com/u/3534966?v=4?s=64" width="64px;" alt="Sergey"/><br /><sub><b>Sergey</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=darkstarx" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=darkstarx" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MisterJimson"><img src="https://avatars1.githubusercontent.com/u/7351329?v=4?s=64" width="64px;" alt="Jason Rai"/><br /><sub><b>Jason Rai</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=MisterJimson" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://joshuadeguzman.net"><img src="https://avatars1.githubusercontent.com/u/20706361?v=4?s=64" width="64px;" alt="Joshua de Guzman"/><br /><sub><b>Joshua de Guzman</b></sub></a><br /><a href="#example-joshuadeguzman" title="Examples">💡</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hertleinj"><img src="https://avatars1.githubusercontent.com/u/33684625?v=4?s=64" width="64px;" alt="Jan Hertlein"/><br /><sub><b>Jan Hertlein</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=hertleinj" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://avioli.github.io/blog/"><img src="https://avatars0.githubusercontent.com/u/524259?v=4?s=64" width="64px;" alt="Evo Stamatov"/><br /><sub><b>Evo Stamatov</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=avioli" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/davi-eduardo-25797a102/"><img src="https://avatars0.githubusercontent.com/u/14044895?v=4?s=64" width="64px;" alt="Davi Eduardo"/><br /><sub><b>Davi Eduardo</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=davieduardo94" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.inovatso.com.br"><img src="https://avatars0.githubusercontent.com/u/5619696?v=4?s=64" width="64px;" alt="Leonardo Custodio"/><br /><sub><b>Leonardo Custodio</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=leonardocustodio" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=leonardocustodio" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://aboutprince.in/"><img src="https://avatars3.githubusercontent.com/u/26018750?v=4?s=64" width="64px;" alt="Prince Srivastava"/><br /><sub><b>Prince Srivastava</b></sub></a><br /><a href="#example-pr-1" title="Examples">💡</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=pr-1" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://muhajir.dev"><img src="https://avatars2.githubusercontent.com/u/12745166?v=4?s=64" width="64px;" alt="Muhammad Muhajir"/><br /><sub><b>Muhammad Muhajir</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=muhajirdev" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/geweald"><img src="https://avatars1.githubusercontent.com/u/16155640?v=4?s=64" width="64px;" alt="D"/><br /><sub><b>D</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=geweald" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/davidmartos96"><img src="https://avatars1.githubusercontent.com/u/22084723?v=4?s=64" width="64px;" alt="David Martos"/><br /><sub><b>David Martos</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=davidmartos96" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/inimaga"><img src="https://avatars3.githubusercontent.com/u/24917864?v=4?s=64" width="64px;" alt="Issa Nimaga"/><br /><sub><b>Issa Nimaga</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=inimaga" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Ascenio"><img src="https://avatars.githubusercontent.com/u/7662016?v=4?s=64" width="64px;" alt="Ascênio"/><br /><sub><b>Ascênio</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=Ascenio" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=Ascenio" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://sonerik.dev"><img src="https://avatars.githubusercontent.com/u/5076429?v=4?s=64" width="64px;" alt="Alex Isaienko"/><br /><sub><b>Alex Isaienko</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=s0nerik" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://moritzweber.xyz"><img src="https://avatars.githubusercontent.com/u/17176771?v=4?s=64" width="64px;" alt="Moritz Weber"/><br /><sub><b>Moritz Weber</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=moritz-weber" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://profile.codersrank.io/user/sno2/"><img src="https://avatars.githubusercontent.com/u/43641633?v=4?s=64" width="64px;" alt="Carter Snook"/><br /><sub><b>Carter Snook</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=sno2" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/brianrobles204"><img src="https://avatars.githubusercontent.com/u/872114?v=4?s=64" width="64px;" alt="Brian Robles"/><br /><sub><b>Brian Robles</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=brianrobles204" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=brianrobles204" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/harrypunk"><img src="https://avatars.githubusercontent.com/u/4889163?v=4?s=64" width="64px;" alt="harrypunk"/><br /><sub><b>harrypunk</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=harrypunk" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://bandism.net/"><img src="https://avatars.githubusercontent.com/u/22633385?v=4?s=64" width="64px;" alt="Ikko Ashimine"/><br /><sub><b>Ikko Ashimine</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=eltociear" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://amond.dev"><img src="https://avatars.githubusercontent.com/u/1964421?v=4?s=64" width="64px;" alt="amond"/><br /><sub><b>amond</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=amondnet" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=amondnet" title="Tests">⚠️</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Aamondnet" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=amondnet" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fzyzcjy"><img src="https://avatars.githubusercontent.com/u/5236035?v=4?s=64" width="64px;" alt="fzyzcjy"/><br /><sub><b>fzyzcjy</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=fzyzcjy" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/commits?author=fzyzcjy" title="Documentation">📖</a> <a href="https://github.com/mobxjs/mobx.dart/pulls?q=is%3Apr+reviewed-by%3Afzyzcjy" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://pixolity.se"><img src="https://avatars.githubusercontent.com/u/759524?v=4?s=64" width="64px;" alt="Vandad Nahavandipoor"/><br /><sub><b>Vandad Nahavandipoor</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=vandadnp" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://molchanovsky.com"><img src="https://avatars.githubusercontent.com/u/12999702?v=4?s=64" width="64px;" alt="Sergey Molchanovsky"/><br /><sub><b>Sergey Molchanovsky</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=subzero911" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ko16a46"><img src="https://avatars.githubusercontent.com/u/100613422?v=4?s=64" width="64px;" alt="ko16a46"/><br /><sub><b>ko16a46</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=ko16a46" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/yatharth25"><img src="https://avatars.githubusercontent.com/u/54071856?v=4?s=64" width="64px;" alt="Yatharth Chauhan"/><br /><sub><b>Yatharth Chauhan</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=yatharth25" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ParthBaraiya"><img src="https://avatars.githubusercontent.com/u/36261739?v=4?s=64" width="64px;" alt="Parth Baraiya"/><br /><sub><b>Parth Baraiya</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=ParthBaraiya" title="Code">💻</a> <a href="https://github.com/mobxjs/mobx.dart/issues?q=author%3AParthBaraiya" title="Bug reports">🐛</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/altynbek132"><img src="https://avatars.githubusercontent.com/u/48729942?v=4?s=64" width="64px;" alt="Altynbek Aidarbekov"/><br /><sub><b>Altynbek Aidarbekov</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=altynbek132" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/CpedniyNikon"><img src="https://avatars.githubusercontent.com/u/50595311?v=4?s=64" width="64px;" alt="CpedniyNikon"/><br /><sub><b>CpedniyNikon</b></sub></a><br /><a href="https://github.com/mobxjs/mobx.dart/commits?author=CpedniyNikon" title="Documentation">📖</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

このプロジェクトは [all-contributors](https://github.com/all-contributors/all-contributors) 仕様に従っています。あらゆる種類の貢献を歓迎します！
