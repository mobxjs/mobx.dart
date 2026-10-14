Idiomas: [English](../../README.md) | [Português](README.md) | [Chinese](translation/zh-CN/README.md) | [Japanese](translation/ja-JP/README.md) | [Korean](translation/ko-KR/README.md)

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

[MobX](https://github.com/mobxjs/mobx) para a Linguagem Dart.

> Evolua a Gerência de Estado dos seus App Dart com o Transparent Functional Reactive Programming (TFRP)

- **[Introdução](#introdução)**
- **[Conceitos Principais](#conceitos-principais)**
  - [Observables](#observables)
  - [Computed Observables](#computed-observables)
  - [Actions](#actions)
  - [Reactions](#reactions)
- **[Contribuição](#contribuição)**

## Introdução

O MobX é uma biblioteca de gerenciamento de estado que simplifica a conexão dos dados reativos do seu aplicativo com a interface do usuário. Essa integração é completamente automática e parece muito natural. Como desenvolvedor de aplicativos, você se concentra exclusivamente em quais dados reativos precisam ser consumidos na interface do usuário (e em outros lugares) sem se preocupar em manter os dois sincronizados.

Não fazemos "mágica", apenas temos objetos inteligentes que se preparam para serem consumidos (**observables**),
e as (**reactions**) os rastreia automaticamente para você. quando o _observables_
mudam, todas as _reactions_ são chamadas. O interessante é que as _reactions_ podem ser qualquer coisa, desde um simples log do console, uma chamada de rede ou até mesmo uma renderização da interface do usuário.

> MobX tem sido uma biblioteca muito eficiente para o javascript
> esse porte visa trazer essa mesma produtividade para os apps baseados em Dart

### Patrocinadores

Somos muito gratos aos nossos patrocinadores por nos tornar parte do programa _Open Source Software (OSS)_.

- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/publicis-sapient-sponsor.png" height="64">](https://publicis.sapient.com)
- [<img src="https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/wunderdog-sponsor.png" height="64">](https://wunderdog.fi)

### Começando

Acompanhe esse [Guia de introdução ao MobX (em inglês)](https://mobx.netlify.app/getting-started).

### Aprofundando

Para uma visão mais profunda do MobX, veja o [MobX Quick Start Guide](https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837). Embora o livro use a versão JavaScript do MobX, os conceitos são **100% aplicáveis** ao Dart e Flutter.

[![Capa do livro MobX Quick Start Guide](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/book.png)](https://www.packtpub.com/en-us/product/mobx-quick-start-guide-9781789344837)

## Conceitos Principais

![MobX Triad](https://github.com/mobxjs/mobx.dart/raw/master/docs/src/images/mobx-triad.png)

Temos 3 conceitos principais no MobX: **Observables**, **Actions** e **Reactions**.

### Observables

Observables representam o reactive-state de sua aplicação. Eles são simples e escalares, mesmo em uma árvore de objetos complexa. Você pode expor sua árvore de observáveis que podem ser consumidas por outros Observables ou pela UI.

Um "contador reativo" pode ser representado pelo seguinte Observable

```dart
import 'package:mobx/mobx.dart';

final counter = Observable(0);
```

Também podem ser criados Observable mais complexos usando Classes(Orientação a Objetos):

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

Agora, basta usar a anotação @Obsevable em uma propriedade da Classe, e sim! temos outros metadados para serem usados como cabeçalho neste boilerplate, porém eles são fixos e funcionam em qualquer tipo de classe. A medida que for criando classes mais complexas, esse boilerplate parecerá não existir, e você dará mais foco no escopo de sua regra.

**Nota**: Essas Anotações estão disponíveis no pacote **[mobx_codegen](https://github.com/mobxjs/mobx.dart/tree/master/mobx_codegen)**.

### Computed Observables

> O que pode ser derivado, deve ser derivado. Automaticamente.

O estado de sua aplicação consiste em _**core-state**_ e _**derived-state**_. O _core-state_ é o estado referente ao dominio ao qual você está lidando. Por exemplo, se você tiver uma entidade chamada `Contact` , as propriedades `firstName` e `lastName` formam o _core-state_ do `Contact`. No entanto, `fullName` é um _derived-state_, obtido pela combinação do `firstName` e do `lastName`.

Esse _derived state_ que depende do _core-state_ ou de outro _derived-state_ é chamado de **Computed Observable**. Ele muda automaticamente quando seus Observables são alterados.

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

No exemplo acima, **`fullName`** é sincronizado automaticamente quando há uma alteração no `firstName` e/ou `lastName`.

### Actions

Actions é a forma como mudamos os nossos observables. Em vez de modificá-los diretamente, as actions adicionam mais `significado semântico` nas mudanças. Por exemplo, em vez de simplesmente chamar `value++`, seria melhor chamar um Action `increment()` pois faz mais sentido. Além disso, as actions também agrupam todas as notificações e garantem que as alterações sejam notificadas somente após a conclusão. Assim, os observables são notificados somente após a conclusão atômica da ação.

Observe que as ações também podem ser aninhadas; nesse caso, as notificações são enviadas quando a ação mais avançada é concluída.

```dart
final counter = Observable(0);

final increment = Action((){
  counter.value++;
});
```

Use a anotação @action para criar uma Ação na sua classe!

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

MobX.dart já lida automaticamente com métodos assíncrono sem a necessidade de alguma outra ferramenta. [`runInAction`](https://mobx.netlify.com/api/action#runinaction).

```dart
@observable
String stuff = '';

@observable
loading = false;

@action
Future<void> loadStuff() async {
  loading = true; // Isso notifica os observadores
  stuff = await fetchStuff();
  loading = false; //Isso também notifica os observadores
}
```

### Reactions

Reactions completa a _Tríade do MobX_ (**observables**, **actions** and **reactions**).
Eles são os observadores do nosso sistema reativo e notificam qualquer observable rastreado que tenha mudado. O Reaction possui alguns métodos para seu uso, conforme será listado abaixo, todos eles retornam a `ReactionDisposer`, uma função que pode ser chamada para eliminar a reação.

Uma das melhores caracteristicas das reactions é que ele _rastreia automaticamente_ qualquer observável sem precisar declarar nada. O fato de ter um observável dentro do escopo de uma Reaction é o suficiente para rastreá-lo.

> O código que você escreve com o MobX parece literalmente sem cerimônia!

**`ReactionDisposer autorun(Function(Reaction) fn)`**

Executa uma Reaction na hora em que é rastreada na função anônima `fn`.

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

Monitora um observável dentro de uma função de `predicate()` e executa o `effect()`. Quando o predicado retornar um valor diferente do anterior. Apenas variáveis dentro do `predicate()` são rastreados.

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

Monitora um observável dentro de uma função de `predicate()` e executa o `effect()` quando _when_ é `true`. Após executar o `effect()`, `when` chama o dispose automaticamente. Você pode pensar no _when_ quando quiser executar a `reaction` apenas uma vez. Você também não precisará se preocupar com o dispose quando estiver usando o `when()`.

```dart
import 'package:mobx/mobx.dart';

final greeting = Observable('Hello World');

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

O **Observer** é um widget (que é parte do pacote **[`flutter_mobx`](https://github.com/mobxjs/mobx.dart/tree/master/flutter_mobx)**), e nos provê uma observação dos observers por meio de uma função de `builder`. Toda vez que o observable mudar, o `Observer` renderizará novamente na view.

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

Se você leu até aqui, então 🎉🎉🎉. Existem algumas maneiras de como você pode contribuir para a crescente comunidade do `MobX.dart`.

- Escolha qualquer problema marcado com ["good first issue"](https://github.com/mobxjs/mobx.dart/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22)
- Propor qualquer recurso ou aprimoramento
- Reportar um erro
- Corrigir um bug
- Participe de uma discussão e ajude na tomada de decisão
- Melhore a documentação **documentation**. A Documentação é de suma importância e de grande prioridade para a comunidade.
- Enviar uma solicitação pull :-)
- Entre na comunidade [![Join the chat at https://discord.gg/dNHY52k](https://img.shields.io/badge/Chat-on%20Discord-lightgrey?style=flat&logo=discord)](https://discord.gg/dNHY52k)
