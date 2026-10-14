언어: [English](README.md) | [Português](translation/pt-BR/README.md) | [Chinese](translation/zh-CN/README.md) | [Japanese](translation/ja-JP/README.md) | [Korean](translation/ko-KR/README.md)

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
[![Mutable.ai Auto Wiki](https://img.shields.io/badge/Auto_Wiki-Mutable.ai-blue)](https://wiki.mutable.ai/mobxjs/mobx.dart)

[![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)

![](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx.png)

Dart 언어를 위한 [MobX](https://github.com/mobxjs/mobx).

> 투명한 함수형 반응형 프로그래밍(TFRP, Transparent Functional Reactive Programming)을 사용하여 Dart 앱의 상태 관리를 강화합니다.

> 
> ## 저희는 관리자를 찾고 있습니다. Discord 또는 GitHub 이슈에 문의하세요!

- **[Introduction](#introduction)**
- **[Core Concepts](#core-concepts)**
  - [Observables](#observables)
    - [@observable](#observables)
    - [@readonly](#readonly)
    - [@computed](#computed-observables)
  - [Actions](#actions)
  - [Reactions](#reactions)
- **[기여하기](#기여하기)**

## 소개

MobX는 애플리케이션의 반응형 데이터를 UI와 간편하게 연결할 수 있는 상태 관리 라이브러리입니다. 
이 연결은 완전히 자동으로 이루어지며 매우 자연스럽게 느껴집니다. 
애플리케이션 개발자는 두 데이터를 동기화할 걱정 없이 UI(및 다른 곳)에서 어떤 리액티브 데이터를 사용해야 하는지에만 집중할 수 있습니다.

이것은 정말 마법은 아니지만, 무엇이(**observables**) 어디에서(**reactions**) 소비되고 있는지를 파악하고 자동으로 추적하는 스마트한 기능을 갖추고 
있습니다. _observables_ 이 변경되면 모든 _reactions_ 이 다시 실행됩니다. 흥미로운 점은 이러한 반응이 단순한 콘솔 로그, 네트워크 호출, UI 재렌더링
등 무엇이든 될 수 있다는 것 입니다.

> MobX는 자바스크립트 앱에 매우 효과적인 라이브러리였으며, 이번 Dart 언어 포팅은 동일한 수준의 생산성을 제공하는 것을 목표로 합니다.

### 후원자

우리는 후원자들에게 매우 감사하게 생각합니다. 덕분에 우리는 오픈소스 소프트웨어(OSS) 프로그램의 일부가 될 수 있었습니다. [[후원하기](https://opencollective.com/mobx#sponsor)]

- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/main/docs/src/images/vyuh-sponsor.png" height="64">](https://vyuh.tech)
- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/main/docs/src/images/algolia-sponsor.png" height="64">](https://algolia.com)
- [<img src="https://www.netlify.com/img/global/badges/netlify-color-bg.svg" height="64">](https://www.netlify.com)

### 과거 후원자

- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/main/docs/src/images/publicis-sapient-sponsor.png" height="64">](https://publicis.sapient.com)
- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/main/docs/src/images/wunderdog-sponsor.png" height="64">](https://wunderdog.fi)

### 시작하기
 
[MobX.dart 웹사이트의 시작하기 가이드](https://mobx.netlify.app/getting-started)를 따르세요.

### 더 깊이 알아보기

MobX에 대한 자세한 내용은 [MobX 빠른 시작 가이드](https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837)를 참조하세요.
이 책에서는 자바스크립트 버전의 MobX를 사용하지만, 개념은 Dart와 Flutter에 **100% 적용**할 수 있습니다.

[![MobX 빠른 시작 가이드 표지](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/book.png)](https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837)

## 핵심 개념

![MobX Triad](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx-triad.png)

MobX의 핵심에는 세 가지 중요한 개념이 있습니다: **Observables**, **Actions**, **Reactions**.

### Observables

observables은 애플리케이션의 반응 상태를 나타냅니다. 단순한 스칼라부터 복잡한 객체 트리까지 다양합니다. 애플리케이션의 상태를 observables 트리로 정의하면 
UI(또는 앱의 다른 observer)가 소비하는 _reactive-state-tree_ 를 노출할 수 있습니다.

간단한 리액티브 카운터는 다음과 같은 observables로 표현됩니다:

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

클래스와 같은 더 복잡한 observables도 만들 수 있습니다.

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

언뜻 보기에 이 코드는 상용구 코드처럼 보이지만 금방 지겨워질 수 있습니다!
그래서 위의 코드를 다음과 같이 대체할 수 있는 **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** 를 추가했습니다:

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

어노테이션을 사용하여 클래스의 observables 속성을 표시하는 것에 주목하세요. 예, 여기에는 헤더 상용구가 있지만 모든 클래스에 대해 고정되어 있습니다. 
더 복잡한 클래스를 만들면 이 상용구는 사라지고 대부분 중괄호 안의 코드에 집중하게 될 것입니다.

**참고**: 어노테이션은 **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** 패키지를 통해 사용할 수 있습니다.

### readonly

코드를 줄이려면 `@observable`을 `@readonly`로 바꿀 수 있습니다.

모든 비공개 변수에 대해 스토어 클라이언트에서 값을 변경할 수 없도록 공개 getter를 생성합니다.
자세한 내용은 [여기](https://mobx.netlify.app/api/observable#readonly)를 참조하세요.

### Computed Observables

> 도출할 수 있는 것은 반드시 도출해야 합니다. 자동으로.

애플리케이션의 상태는 _**핵심 상태(core-state)**_ 와 _**파생 상태(derived-state)**_ 로 구성됩니다. _핵심 상태(core-state)_ 는 현재 다루고 있는 도메인에 고유한 상태입니다. 예를 들어, `Contact` 엔티티가 있는 경우 `firstName`과 `lastName`은 `Contact`의 _core-state_ 를 구성합니다. 그러나 `fullName` 은 `firstName` 과 `lastName` 을 결합하여 얻은 _파생 상태(derived-state)_ 입니다.

_core-state_ 또는 _other derived-state_ 에 의존하는 이러한 _derived state_ 를 **Computed Observable** 이라고 합니다. observables이 변경되면 자동으로 동기화 상태를 유지합니다.

> MobX의 상태 = 핵심 상태 + 파생 상태

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

위의 예에서 ``firstName`` 및/또는 ``lastName``이 변경되면 ``fullName``이 자동으로 동기화됩니다.

### Actions

action은 observables을 변경하는 방법입니다. 액션은 직접 변경하는 대신 변화에 의미론적 의미를 추가합니다. 
예를 들어, 단순히 `value+` 를 실행하는 대신 `increment()` action을 실행하면 더 많은 의미를 전달할 수 있습니다. 
또한, action은 모든 알림을 일괄 처리하여 변경이 완료된 후에만 알림을 받도록 합니다. 
따라서 observer들은 action이 원자적으로 완료될 때만 알림을 받습니다.

action은 중첩될 수도 있으며, 이 경우 최상위 action이 완료되면 알림이 발송됩니다.

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

클래스 내에서 action을 만들 때 어노테이션을 활용할 수 있습니다!

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

#### Asynchronous Actions

MobX.dart는 비동기 동작을 자동으로 처리하며 [`runInAction`](https://mobx.netlify.com/api/action#runinaction)로 코드를 래핑할 필요가 없습니다.

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

### Reactions

reaction은 **observables**, **actions**, **reactions**의 _MobX triad_ 를 완성합니다. 
이들은 반응형 시스템의 observer이며, 추적하는 observable이 변경될 때마다 알림을 받습니다.
변경될 때마다 알림을 받습니다. reaction은 아래와 같이 몇 가지 종류가 있습니다. 이들 모두는 reaction을 삭제(dispose)기 위해 호출할 수 있는 함수인 `ReactionDisposer`를 반환합니다.

reaction의 _눈에 띄는_ 특징 중 하나는 명시적인 연결 없이 모든 observable을 _자동으로 추적_ 한다는 것입니다. reaction 내에서 observable을 _읽는_ 행위만으로도 충분히 추적할 수 있습니다!

> MobX로 작성하는 코드는 말 그대로 의식이 없는 것처럼 보입니다!

**`ReactionDisposer autorun(Function(Reaction) fn)`**

Runs the reaction immediately and also on any change in the observables used inside
`fn`.

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

`predicate()` 함수 내에서 사용되는 observables를 모니터링하고, `predicate()` 가 다른 값을 반환하면 `effect()`를 실행합니다.
`predicate()` 내부의 observables만 추적됩니다.

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

`when`은 `predicate()` 내부에 사용된 observables를 관찰하고 `true`를 반환할 때 `effect()`를 실행합니다. `effect()`가 실행된 후에는 `when`가 자동으로 폐기됩니다. 따라서 _when_ 은 _일회성_ `reaction`으로 생각할 수 있습니다. 또한 `when()`을 미리 폐기할 수도 있습니다.

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

final dispose = when((_) => greeting.value == 'Hello MobX', () => print('Someone greeted MobX'));

greeting.value = 'Hello MobX'; // Causes a change, runs effect and disposes


// Prints:
// Someone greeted MobX
```

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

`when`과 비슷하지만 `Future`를 반환합니다. 이는 `predicate()`가 `true` 를 반환할 때 완료됩니다. 이는 `predicate()`가 `true`가 될 때까지 기다릴 수 있는 편리한 방법입니다.

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => _completed.value == true);

  print('Completed');
}
```

**Observer**

앱에서 가장 시각적으로 반응하는 부분 중 하나는 UI입니다. **Observer** 위젯(**[`flutter_mobx`]https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx)** 패키지의 일부인)은 `builder` 함수에서 사용되는 observables에 대한 세분화된 observer를 제공합니다. 이러한 observables가 변경될 때마다 `Observer`는 다시 빌드하고 렌더링합니다.

아래는 _Counter_ 예제 전체입니다.

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

## 기여하기

여기까지 읽으셨다면 🎉🎉🎉. `MobX.dart`의 성장하는 커뮤니티에 기여할 수 있는 몇 가지 방법이 있습니다.

- ["good first issue"](https://github.com/mobxjs/mobx.dart/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)로 표시된 issue를 선택합니다
- 기능, 개선 사항 제안하기
- 버그 신고하기
- 버그 수정하기
- 토론에 참여하여 의사 결정에 도움 주기
- **문서**를 작성하고 개선하세요. 문서화는 매우 중요하며 그 중요성은 아무리 강조해도 지나치지 않습니다!
- 풀 리퀘스트 보내기 :-)
- [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)에서 채팅에 참여하세요

## 기여자 ✨

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-65-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

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

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

이 프로젝트는 [all-contributors](https://github.com/all-contributors/all-contributors) 규정을 따릅니다. 모든 종류의 기여를 환영합니다!
