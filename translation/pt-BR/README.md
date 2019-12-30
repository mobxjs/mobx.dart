Language: [English](../../README.md) | [Português](README.md)

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

[MobX](https://github.com/mobxjs/mobx) para a Linguagem Dart.

> Evolua a sua Gerência de Estado em seus App Dart com o Transparent Functional Reactive Programming (TFRP)

- **[Introdução](#introdução)**
- **[Conceitos Principais](#conceitos-principais)**
  - [Observables](#observables)
  - [Computed Observables](#computed-observables)
  - [Actions](#actions)
  - [Reactions](#reactions)
- **[Contribuição](#contribuição)**

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

Temos 3 principais conceitos no MobX: **Observables**, **Actions** e **Reactions**.

### Observables

Observables representa o reactive-state de sua aplicação. Eles são simples e escalares mesmo em uma árvore de objetos complexa. Você pode expor sua árvore de obersáveis que podem ser consumidos por outros Observables ou pela UI.

Um "contador reativo" pode ser representado pelo seguinte Observable

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

Também podem ser criados observable mais complexos usando Classes(Orientação a objetos):

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
A primeira vista pode parecer algo verboso, por isso criamos **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)** que permite substituir o código acima pelo seguinte:

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

Agora, basta usar a annotation @Obsevable em uma propriedade da Classe, e sim! temos outros metadados para serem usados como cabeçalho neste boilerplate, porém eles são fixos e funcionam em qualquer tipo de classe. A medida que for criando classes mais complexa, esse boilerplate parecerar não existir, e você dará mais foco no escopo de sua regra.

**Nota**: Essas Annotations estão disponíveis no packote **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)**.

### Computed Observables

> O que pode ser derivado, deve ser derivado. Automaticamente.

O estado de sua aplicação consiste em _**core-state**_ e _**derived-state**_. O _core-state_ é o estado referente ao dominio ao qual você está lidando. Por exemplo, se você tiver uma entidade chamada `Contact` , as propriedades `firstName` e `lastName` formam o _core-state_ do `Contact`. No entanto, `fullName` é um _derived-state_, obtido pela combinação do `firstName` e do `lastName`.

Esse _derived state_ que depende do _core-state_ ou de outro _derived-state_ é chamado de  **Computed Observable**. Ele automaticamente muda quando seus Observables são alterados.

> Estado no MobX = Core-State + Derived-State

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

No exemplo acima, **`fullName`** é automaticamente sincronizado quando há uma alteração no `firstName` e/ou `lastName`.

### Actions

Actions deve ser a forma como mudamos os nossos observables. Em vez de modifica-los diretamente, as actions
adiciona mais `significado semântico` nas mudanças. Por exemplo, em vez de simplesmente chamar `value++` apenas, seria melhor chamar um Action `increment()` pois carrega mais significado. Além disso, actions Além disso, as ações também agrupam todas as notificações e garantem que as alterações sejam notificadas somente após a conclusão. Assim, os observadores são notificados somente após a conclusão atômica da ação.

Observe que as ações também podem ser aninhadas; nesse caso, as notificações são enviadas quando a ação mais avançada é concluída.

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

Use a annotations @action para criar uma Ação na sua classe!

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

MobX.dart já lida automaticamente com métodos asincrono sem a necessidade de alguma outra ferramenta. [`runInAction`](https://mobx.pub/api/action#runinaction).

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

Reactions completa a _Tríade do MobX_ (**observables**, **actions** and **reactions**). 
Eles são os observadores do nosso sistema reativo e notificam qualquer observable rastreado que tenha mudado. Reaction tem alguns métodos para seu uso,conforme será listado abaixo, Todos eles retornam a `ReactionDisposer`, uma função que pode ser chamada para eliminar a reação.

Uma das melhores caracteristicas das reactions é que ele _rastreia automaticamente_ qualquer observável sem precisar declará nada. Apenas ter um observável dentro do escopo de uma Reaction e o suficiente para rastrea-lo.

> O código que você escreve com o MobX parece literalmente sem cerimônia!

**`ReactionDisposer autorun(Function(Reaction) fn)`**

Executa uma Reaction na hora em que é rastreada na função anônima `fn`.

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

Monitora um observável dentro de uma função de `predicate()` e executa o `effect()`. Quando o prédicado retornar um valor diferente do anterior. Apenas variáveis dentro do `predicate()` são rastreados.

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

Monitora um observável dentro de uma função de `predicate()` e executa o `effect()` quando _when_ é `true`. Após executar o `effect()`, `when` chama o dispose automaticamente. Você pode pensar no _when_ quando quiser executar a `reaction` apenas uma vez. Você também não precisará se preocupar com o dipose quando estiver usando o `when()`.

```dart
import 'package:mobx/mobx.dart';

String greeting = Observable('Hello World');

final dispose = when((_) => greeting.value == 'Hello MobX', () => print('Someone greeted MobX'));

greeting.value = 'Hello MobX'; // Causes a change, runs effect and disposes


// Prints:
// Someone greeted MobX
```

**`Future<void> asyncWhen(bool Function(Reaction) predicate)`**

Similar ao `when` porém retorna um `Future`, que é completado quando o `predicate()` retorna _true_. Essa é uma maneira conveniente de esperar um `predicate()` se tornar `true`.

```dart
final completed = Observable(false);

void waitForCompletion() async {
  await asyncWhen(() => _completed.value == true);

  print('Completed');
}
```

**Observer**

O **Observer** é um widget (que é parte do pacote **[`flutter_mobx`](https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx)**), nos prover uma observação dos observers por meio de uma função de `builder`. Toda vez que o  observables mudar, o `Observer` renderizará novamente na view.

Abaixo temos um exemplo do _Counter_ em sua totalidade.

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

## Contribuição

Se você leu até aqui, então 🎉🎉🎉. Existem algumas maneiras pelas quais você pode contribuir para a crescente comunidade do `MobX.dart`.

- Escolha qualquer problema marcado com ["good first issue"](https://github.com/mobxjs/mobx.dart/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)
- Propor qualquer recurso ou aprimoramento
- Reportar um erro
- Corrigir um bug
- Participe de uma discussão e ajude na tomada de decisão
- Melhore a documentação **documentation**. A Documentação é de suma importância e de grande prioridade para a comunidade.
- Enviar uma solicitação pull :-)
- Entre na comunidade [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)
