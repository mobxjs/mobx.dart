---
title: 핵심 개념
---

# 핵심 개념


<img
  src="/images/mobx-triad.png"
  alt="Observable, Action, Reaction으로 이루어진 MobX의 삼각 구조"
/>

MobX의 중심에는 세 가지 중요한 개념인 **Observable**, **Action**, **Reaction**이
있습니다.

## Observables

Observable은 애플리케이션의 반응형 상태(reactive state)를 나타냅니다. 단순한
스칼라 값부터 복잡한 객체 트리까지 무엇이든 Observable이 될 수 있습니다.
애플리케이션의 상태를 Observable 트리로 정의하면, UI(또는 앱의 다른
옵저버)가 사용하는 *반응형 상태 트리*를 노출할 수 있습니다.

> `reactive data`(반응형 데이터)란 데이터가 바뀌면 관심 있는 모든 옵저버에게
> 알림이 전달된다는 뜻입니다. 고전적인 **Observer** 디자인 패턴을 적용한
> 것입니다.

간단한 반응형 카운터는 다음과 같은 Observable로 표현합니다.

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

클래스처럼 더 복잡한 Observable도 만들 수 있습니다.

```dart
class Counter {
  Counter() {
    increment = Action(_increment);
  }

  final _value = Observable(0);
  int get value => _value.value;

  set value(int newValue) => _value.value = newValue;
  late Action increment;

  void _increment() {
    _value.value++;
  }
}
```

언뜻 보면 금세 감당하기 어려워질 수 있는 보일러플레이트 코드처럼 보입니다.
그래서 <PubBadge name="mobx_codegen" />를 도입했습니다. 이 패키지를 사용하면
위 코드를 다음과 같이 바꿔 쓸 수 있습니다.

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

어노테이션으로 클래스의 Observable 프로퍼티를 표시한다는 점을 눈여겨보세요.
물론 상단에 보일러플레이트가 조금 있지만, 어떤 클래스든 형태가 똑같습니다.
더 복잡한 클래스를 만들수록 이 보일러플레이트는 눈에 띄지 않게 되고, 중괄호
안의 코드에 주로 집중하게 됩니다.

**참고**: 어노테이션은 <PubBadge name="mobx_codegen"/> 패키지에서 제공합니다.

위 코드는 [**카운터 예제**](/examples/counter)의 일부입니다.

> JavaScript 버전 MobX를 써 본 분이라면, Dart 버전 MobX에는 깊은 관찰(deep
> observability)이 적용되지 않는다는 점을 알아 두어야 합니다. Dart는 정적 타입
> 언어이고, Flutter 애플리케이션에서는 리플렉션(`dart:mirrors`)을 지원하지
> 않기 때문입니다. 따라서 복잡한 객체를 `@observable`로 표시해도 MobX는 그
> 객체의 필드 변경을 자동으로 추적하지 못합니다. 필드 단위로 변경을 추적해야
> 한다면 각 필드에 `@observable` 어노테이션을 따로 붙이는 편이 좋습니다.

## Computed Observables

> 파생할 수 있는 것은 파생해야 합니다. 그것도 자동으로.

애플리케이션의 상태는 ***핵심 상태***(core-state)와 ***파생 상태***(derived-state)로
이루어집니다. *핵심 상태*는 다루는 도메인 자체에 내재한 상태입니다. 예를 들어
`Contact` 엔티티가 있다면 `firstName`과 `lastName`이 `Contact`의 *핵심 상태*입니다.
반면 `fullName`은 `firstName`과 `lastName`을 조합해 얻는 *파생 상태*입니다.

*핵심 상태* 또는 *다른 파생 상태*에 의존하는 이런 *파생 상태*를 **Computed
Observable**(계산된 Observable)이라고 합니다. 기반이 되는 Observable이 바뀌면
자동으로 동기화됩니다.

> MobX의 상태 = **핵심 상태** + **파생 상태**

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

위 예제에서 `firstName`과 `lastName` 중 하나 또는 둘 다 바뀌면 **`fullName`** 값도
자동으로 동기화됩니다.

## Actions

Action은 Observable을 변경하는 방법입니다. Observable을 직접 변경하는 대신
Action을 거치면 변경에 의미를 부여할 수 있습니다. 예를 들어 단순히 `value++`를
실행하기보다 `increment()` Action을 호출하는 편이 더 많은 의미를 담습니다. 또한
Action은 알림을 모두 모아 두었다가 변경이 끝난 뒤에 전달합니다. 따라서 옵저버는
Action이 원자적으로 완료된 시점에만 알림을 받습니다.

Action은 중첩할 수도 있으며, 이때는 가장 바깥쪽 Action이 끝나야 알림이
전달됩니다.

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

클래스 안에서 Action을 만들 때는 어노테이션을 활용할 수 있습니다!

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

## Reactions

Reaction은 **Observable**, **Action**, **Reaction**으로 이루어진 *MobX 삼각
구조*를 완성합니다. Reaction은 반응형 시스템의 옵저버로, 추적 중인 Observable이
바뀔 때마다 알림을 받습니다. Reaction에는 아래와 같이 몇 가지 종류가 있으며,
모두 Reaction을 해제(dispose)할 때 호출하는 함수인 `ReactionDisposer`를
반환합니다.

Reaction의 *두드러진 특징*은 Observable을 별도로 연결하지 않아도 모두 *자동으로
추적*한다는 점입니다. Reaction 안에서 *Observable을 읽는 것*만으로 추적이
시작됩니다!

> MobX로 작성한 코드에는 말 그대로 보일러플레이트가 전혀 없어 보입니다!

**`ReactionDisposer autorun(Function(Reaction) fn)`**

Reaction을 즉시 실행하고, `fn` 안에서 사용한 Observable이 바뀔 때마다 다시
실행합니다.

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

**`ReactionDisposer reaction<T>(T Function(Reaction) fn, void Function(T) effect)`**

`fn()` 함수 안에서 사용한 Observable을 감시하다가, 추적 함수가 다른 값을
반환하면 `effect()`를 실행합니다. 추적 대상은 `fn()` 안의 Observable뿐입니다.

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

`predicate()` 안에서 사용한 Observable을 감시하다가, `predicate()`가 `true`를
반환하는 _순간_ `effect()`를 실행합니다. `effect()`를 실행한 뒤에는 `when`이
스스로 해제됩니다. 그래서 *when*은 *한 번만* 실행되는 `reaction`이라고 생각하면
됩니다. 필요하다면 `when()`을 도중에 해제할 수도 있습니다.

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

final dispose = when((_) => greeting.value == 'Hello MobX', () => print('Someone greeted MobX'));

greeting.value = 'Hello MobX'; // Causes a change, runs effect and disposes


// Prints:
// Someone greeted MobX
```

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

`when`과 비슷하지만 `Future`를 반환하며, 이 `Future`는 `predicate()`가 *true*를
반환하면 완료됩니다. `predicate()`가 `true`가 될 때까지 기다리고 싶을 때
편리합니다.

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => completed.value == true);

  print('Completed');
}
```

## Observer

앱에서 가장 눈에 보이는 Reaction은 UI입니다. **Observer** 위젯(<PubBadge
name="flutter_mobx" />에 포함되어 있습니다)은 `builder` 함수 안에서 사용한
Observable을 세밀하게 관찰합니다. 이 Observable이 바뀔 때마다 `Observer`가 다시
빌드하고 렌더링합니다.

아래는 _카운터_ 예제의 전체 코드입니다.

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
  const CounterExample();

  @override
  CounterExampleState createState() => CounterExampleState();
}

class CounterExampleState extends State<CounterExample> {
  final Counter counter = Counter();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('MobX Counter'),
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
                        '${counter.value}',
                        style: const TextStyle(fontSize: 40),
                      )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: counter.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
```

<img src="/images/mobx-isometric.png" width="50%" />

## 더 알아보기

[Michel Weststrate](https://twitter.com/mweststrate)가 MobX의 철학을 다룬 글이
몇 편 있습니다. 꼭 읽어 보시기를 권합니다.

- [The Fundamental Principles behind MobX](https://hackernoon.com/the-fundamental-principles-behind-mobx-7a725f71f3e8)
- [Becoming fully reactive - an in-depth explanation of MobX](https://hackernoon.com/becoming-fully-reactive-an-in-depth-explanation-of-mobservable-55995262a254)
