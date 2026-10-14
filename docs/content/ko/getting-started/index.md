---
title: 시작하기 🚀
---

# 시작하기

이 튜토리얼에서는 Flutter 기본 **"카운터"** 앱을 MobX로 다시 만들어 봅니다.



<img
  src="/content-assets/getting-started/end-result.png"
  alt="MobX 기반 카운터 앱의 최종 결과"
  width="300"
/>

## 준비하기

1. 튜토리얼을 시작하기 전에
   [Flutter가 설치](https://flutter.dev/docs/get-started/install)되어 있는지,
   그리고
   [새 Flutter 프로젝트를 만드는 방법](https://flutter.dev/docs/get-started/test-drive)을
   알고 있는지 확인합니다.
2. 컴퓨터에 새 Flutter 프로젝트를 만듭니다.

## 의존성 설치

`pubspec.yaml` 파일에 다음 **dependencies**를 추가합니다.

```yaml
dependencies:
  mobx: ^{{ mobx }}
  flutter_mobx: ^{{ flutter_mobx }}
```

이어서 다음 **dev_dependencies**를 추가합니다.

```yaml
dev_dependencies:
  build_runner: ^{{ build_runner }}
  mobx_codegen: ^{{ mobx_codegen }}
```

프로젝트 폴더에서 다음 명령으로 패키지를 모두 내려받습니다.

```sh
flutter pub get
```

이제 개발에 필요한 패키지가 모두 준비되었습니다.

## Store 추가하기

이제 MobX **Store**를 만들어 보겠습니다. MobX에서 Store는 서로 관련된
Observable 상태를 하나의 클래스로 묶는 방법입니다. Store를 사용하면
어노테이션을 활용할 수 있어 코드가 간결해집니다. **`\lib`** 폴더에
`counter.dart` 파일을 새로 만들고 다음 코드를 추가합니다.

```dart
import 'package:mobx/mobx.dart';

// Include generated file
part 'counter.g.dart';

// This is the class used by rest of your codebase
class Counter = _Counter with _$Counter;

// The store-class
abstract class _Counter with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
```

이 코드에서 눈여겨볼 부분은 다음과 같습니다.

- `Store` 믹스인을 사용하는 추상 클래스 `_Counter`가 있습니다. Store와 관련된
  코드는 모두 이 추상 클래스 안에 작성합니다. `build_runner`가 생성한 코드를
  합치기 위해 `Counter` 클래스를 별도로 선언합니다.
- 생성된 코드는 `counter.g.dart` 파트 파일에 들어가며, *`part` 지시자*로
  포함합니다. 이 지시자가 없으면 `build_runner`가 아무 결과물도 만들지
  않습니다. 생성된 파일에는 `_$Counter` 믹스인이 들어 있습니다.

:::caution

파일 이름의 대소문자를 정확히 맞춰야 합니다. 그렇지 않으면 `build_runner`가
아무 결과물도 생성하지 **않습니다**. 여기서는 파일 이름이 `counter.dart`이므로
파트 파일 이름은 `counter.g.dart`여야 합니다(소문자임에 유의하세요).

:::

- `@observable` 어노테이션은 `value`를 Observable(관찰 가능한 상태)로
  표시합니다.
- `@action`은 `increment()` 메서드를 Action(상태를 변경하는 동작)으로
  표시하는 데 사용합니다.

프로젝트 폴더에서 다음 명령을 실행하면, 이미 파트 파일로 포함해 둔
`counter.g.dart`에 코드가 생성됩니다.

```sh
flutter pub run build_runner build
```

다음은 명령줄에서 실행했을 때 나온 출력입니다. 환경에 따라 조금 다를 수
있습니다.

```text
➜  [mobx_getting_started]> flutter packages pub run build_runner build
[INFO] Generating build script...
[INFO] Generating build script completed, took 319ms

[INFO] Initializing inputs
[INFO] Reading cached asset graph...
[INFO] Reading cached asset graph completed, took 76ms

[INFO] Checking for updates since last build...
[INFO] Checking for updates since last build completed, took 705ms

[INFO] Running build...
[INFO] 1.1s elapsed, 0/3 actions completed.
[INFO] 6.7s elapsed, 2/3 actions completed.
[INFO] 7.7s elapsed, 3/3 actions completed.
[INFO] Running build completed, took 7.7s

[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 33ms

[INFO] Succeeded after 7.8s with 2 outputs (6 actions)

```

:::info

#### watch 모드 사용하기

Store를 수정할 때마다 `*.g.dart` 파일을 자동으로 생성하고 싶다면 다음 명령을
사용합니다.

```sh
flutter pub run build_runner watch
```

#### 깨끗하게 다시 시작하기

기존 파일 때문에 이 명령이 오류를 일으킬 수 있습니다. 이전 버전의
`build_runner`가 생성한 파일이 남아 있는 경우가 대표적입니다. 이럴 때는 다음
플래그를 추가해 `*.g.dart` 파일을 먼저 삭제한 뒤 다시 생성합니다.

```sh
flutter pub run build_runner watch --delete-conflicting-outputs
```

:::

## Store를 연결하고 위젯에 Observer 추가하기

이제 MobX Store를 위젯에 연결할 차례입니다. `main.dart` 파일의 내용을 다음
코드로 바꿉니다.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'counter.dart'; // Import the Counter

final counter = Counter(); // Instantiate the store

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobX Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Wrapping in the Observer will automatically re-render on changes to counter.value
            Observer(
              builder: (_) => Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

위 코드에는 `StatefulWidget`이 하나도 없다는 점에 주목하세요. 상태는 `Counter`
Store에 저장되고, `Observer` 위젯은 `counter.value`를 읽어 카운트를
렌더링합니다. `counter.value`를 읽는 것만으로 `Observer`가 추적을 시작하며,
값이 바뀔 때마다 다시 렌더링합니다.

## 완성입니다!

최종 결과는 처음 보던 카운터 앱과 똑같습니다. `FloatingActionButton`을 탭하면
카운터가 증가하고 화면도 자동으로 갱신됩니다.

<img src="/content-assets/getting-started/mobx-counter.gif" width="300" />

### 계속 둘러보세요!

다른 예제도 살펴보면서 MobX에 익숙해져 보세요. MobX의 핵심은 `Observables`,
`Actions`, `Reactions` 세 가지입니다 😇. 이 중 `Observables`와 `Actions`는
이미 살펴보았습니다. `Reactions`는 다른 예제에서 다룹니다.
