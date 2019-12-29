# mobx.dart

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
<img height="128" src="https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/flutter-favorite.png">
</a>
<br><br>

[![pub package](https://img.shields.io/pub/v/mobx.svg?label=mobx&color=blue)](https://pub.dartlang.org/packages/mobx)
[![pub package](https://img.shields.io/pub/v/flutter_mobx.svg?label=flutter_mobx&color=blue)](https://pub.dartlang.org/packages/flutter_mobx)
[![pub package](https://img.shields.io/pub/v/mobx_codegen.svg?label=mobx_codegen&color=blue)](https://pub.dartlang.org/packages/mobx_codegen)

[![CircleCI](https://circleci.com/gh/mobxjs/mobx.dart.svg?style=svg)](https://circleci.com/gh/mobxjs/mobx.dart)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)
[![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)

![](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx.png)

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

- **[Introdução](#introdução)**
- **[Conceitos Principais](#conceitos-principais)**
  - [Observables](#observables)
  - [Computed Observables](#computed-observables)
  - [Actions](#actions)
  - [Reactions](#reactions)
- **[Contributing](#contributing)**

## Introdução

O MobX é uma biblioteca de gerenciamento de estado que simplifica a conexão dos dados reativos do seu aplicativo com a interface do usuário. Essa fiação é completamente automática e parece muito natural. Como desenvolvedor de aplicativos, você se concentra exclusivamente em quais dados reativos precisam ser consumidos na interface do usuário (e em outros lugares) sem se preocupar em manter os dois sincronizados.

Não trabalhamos com "magia", apenas temos objetos inteligentes que se preparam para serem consumidos (**observables**),
e as (**reactions**) os rastreia automaticamente para você. quando o _observables_
muda, todas as _reactions_ são chamadas. O interessante é que as _reactions_ podem ser qualquer coisa, desde um simples log do console, uma chamada de rede ou até mesmo rendenrizar a interface do usuário.

> MobX tem sido uma uma biblioteca muito eficiente para o javascript
> esse port visa trazer essa mesma produtividade para os app baseados em Dart

### Patriocinadores

Somos muito gratos aos nossos patrocinadores por nos fazer parte do programa _Open Source Software (OSS)_.

- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/publicis-sapient-sponsor.png" height="64">](https://publicis.sapient.com)
- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/wunderdog-sponsor.png" height="64">](https://wunderdog.fi)

### Começando

Acompanhe esse [Guia de introdução ao MobX (em inglês)](https://mobx-dart.netlify.com/getting-started).

### Aprofundando

Para uma visão mais profunda do MobX, veja o [MobX Quick Start Guide](https://www.packtpub.com/web-development/mobx-quick-start-guide). Embora o livro use a versão JavaScript do MobX, os conceitos são **100% aplicáveis** ao Dart e Flutter.

[![](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/book.png)](https://www.packtpub.com/web-development/mobx-quick-start-guide)

## Conceitos Principais

![MobX Triad](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx-triad.png)

At the heart of MobX are three important concepts: **Observables**, **Actions** and **Reactions**.

### Observables

Observables represent the reactive-state of your application. They can be simple scalars to complex object trees. By
defining the state of the application as a tree of observables, you can expose a _reactive-state-tree_ that the UI
(or other observers in the app) consume.

A simple reactive-counter is represented by the following observable:

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

More complex observables, such as classes, can be created as well.

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

On first sight, this does look like some boilerplate code which can quickly go out of hand!
This is why we added **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** to the mix that allows you to replace the above code with the following:

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

Note the use of annotations to mark the observable properties of the class. Yes, there is some header boilerplate here
but its fixed for any class. As you build more complex classes this boilerplate
will fade away and you will mostly focus on the code within the braces.

**Note**: Annotations are available via the **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** package.

### Computed Observables

> What can be derived, should be derived. Automatically.

The state of your application consists of _**core-state**_ and _**derived-state**_. The _core-state_ is state inherent to the domain you are dealing with. For example, if you have a `Contact` entity, the `firstName` and `lastName` form the _core-state_ of `Contact`. However, `fullName` is _derived-state_, obtained by combining `firstName` and `lastName`.

Such _derived state_, that depends on _core-state_ or _other derived-state_ is called a **Computed Observable**. It is automatically kept in sync when its underlying observables change.

> State in MobX = Core-State + Derived-State

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

In the example above **`fullName`** is automatically kept in sync if either `firstName` and/or `lastName` changes.

### Actions

Actions are how you mutate the observables. Rather than mutating them directly, actions
add a semantic meaning to the mutations. For example, instead of just doing `value++`,
firing an `increment()` action carries more meaning. Besides, actions also batch up
all the notifications and ensure the changes are notified only after they complete.
Thus the observers are notified only upon the atomic completion of the action.

Note that actions can also be nested, in which case the notifications go out
when the top-most action has completed.

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

When creating actions inside a class, you can take advantage of annotations!

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

MobX.dart handles asynchronous actions automatically and does not require wrapping the code with [`runInAction`](https://mobx.pub/api/action#runinaction).

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

### Reactions

Reactions complete the _MobX triad_ of **observables**, **actions** and **reactions**. They are
the observers of the reactive-system and get notified whenever an observable they
track is changed. Reactions come in few flavors as listed below. All of them
return a `ReactionDisposer`, a function that can be called to dispose the reaction.

One _striking feature_ of reactions is that they _automatically track_ all the observables without any explicit wiring. The act of _reading an observable_ within a reaction is enough to track it!

> The code you write with MobX appears to be literally ceremony-free!

**`ReactionDisposer autorun(Function(Reaction) fn)`**

Runs the reaction immediately and also on any change in the observables used inside
`fn`.

```dart
import 'package:mobx/mobx.dart';

String greeting = Observable('Hello World');

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

Monitors the observables used inside the `predicate()` function and runs the `effect()` when
the predicate returns a different value. Only the observables inside `predicate()` are tracked.

```dart
import 'package:mobx/mobx.dart';

String greeting = Observable('Hello World');

final dispose = reaction((_) => greeting.value, (msg) => print(msg));

greeting.value = 'Hello MobX'; // Cause a change

// Done with the reaction()
dispose();


// Prints:
// Hello MobX
```

**`ReactionDisposer when(bool Function(Reaction) predicate, void Function() effect)`**

Monitors the observables used inside `predicate()` and runs the `effect()` _when_ it returns `true`. After the `effect()` is run, `when` automatically disposes itself. So you can think of _when_ as a _one-time_ `reaction`. You can also dispose `when()` pre-maturely.

```dart
import 'package:mobx/mobx.dart';

String greeting = Observable('Hello World');

final dispose = when((_) => greeting.value == 'Hello MobX', () => print('Someone greeted MobX'));

greeting.value = 'Hello MobX'; // Causes a change, runs effect and disposes


// Prints:
// Someone greeted MobX
```

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

Similar to `when` but returns a `Future`, which is fulfilled when the `predicate()` returns _true_. This is a convenient way of waiting for the `predicate()` to turn `true`.

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => _completed.value == true);

  print('Completed');
}
```

**Observer**

One of the most visual reactions in the app is the UI. The **Observer** widget (which is part of the **[`flutter_mobx`](https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx)** package), provides a granular observer of the observables used in its `builder` function. Whenever these observables change, `Observer` rebuilds and renders.

Below is the _Counter_ example in its entirety.

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

## Contributing

If you have read up till here, then 🎉🎉🎉. There are couple of ways in which you can contribute to
the growing community of `MobX.dart`.

- Pick up any issue marked with ["good first issue"](https://github.com/mobxjs/mobx.dart/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)
- Propose any feature, enhancement
- Report a bug
- Fix a bug
- Participate in a discussion and help in decision making
- Write and improve some **documentation**. Documentation is super critical and its importance
  cannot be overstated!
- Send in a Pull Request :-)
- Chime in and [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)
