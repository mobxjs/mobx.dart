import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mobx/src/observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when, version;
import 'package:mockito/mockito.dart';

import 'helpers.dart';

void main() {
  setUp(() => mainContext.config =
      ReactiveConfig(writePolicy: ReactiveWritePolicy.never));

  tearDown(() => mainContext.config = ReactiveConfig.main);

  test('Should expose the library\'s version', () {
    expect(version, isNotNull);
  });

  testWidgets('Observer re-renders when observed state changes',
      (tester) async {
    final message = Observable('Click');

    final key = UniqueKey();

    await tester.pumpWidget(Observer(
        builder: (context) => GestureDetector(
              onTap: () => message.value = 'Clicked',
              child: Text(message.value,
                  key: key, textDirection: TextDirection.ltr),
            )));

    expect(tester.widget<Text>(find.byKey(key)).data, equals('Click'));

    await tester.tap(find.byKey(key));
    expect(message.value, equals('Clicked'));

    await tester.pump();
    expect(tester.widget<Text>(find.byKey(key)).data, equals('Clicked'));
  });

  testWidgets("Observer doesn't re-render when observed state doesn't change",
      (tester) async {
    var renderCount = 0;

    final i = Observable(0);

    await tester.pumpWidget(Observer(builder: (context) {
      renderCount++;
      i.value;
      return const Placeholder();
    }));

    expect(renderCount, equals(1));

    await tester.pump();

    expect(renderCount, equals(1));
  });

  testWidgets('Observer build should call reaction.track', (tester) async {
    final mock = MockReaction();
    when(mock.hasObservables).thenReturn(true);

    await tester.pumpWidget(
        TestObserver(mock, builder: (context) => const Placeholder()));

    verify(mock.track(voidFn));
  });

  testWidgets(
      'Observer should re-throw exceptions occuring inside the reaction',
      (tester) async {
    dynamic exception;

    final prevOnError = FlutterError.onError;

    FlutterError.onError = (details) {
      exception = details.exception;
    };

    final count = Observable(0);

    final widget = Container();
    await tester.pumpWidget(Observer(builder: (context) {
      if (count.value == 0) {
        throw Error();
      }
      return widget;
    }));

    FlutterError.onError = prevOnError;

    count.value++;

    await tester.pump();

    expect(tester.firstWidget(find.byWidget(widget)), equals(widget));

    expect(exception, isInstanceOf<Error>());
  });

  testWidgets('Observer should report Flutter errors during invalidation',
      (tester) async {
    final mobXException = await _testThrowingObserver(
      tester,
      FlutterError('setState() failed!'),
    );
    expect(mobXException.exception, isInstanceOf<FlutterError>());
    // ignore: avoid_as
    expect((mobXException.exception as FlutterError).stackTrace, isNotNull);
  });

  testWidgets('Observer should report non-Flutter errors during invalidation',
      (tester) async {
    final mobXException = await _testThrowingObserver(
      tester,
      StateError('Something else happened'),
    );
    expect(mobXException.exception, isInstanceOf<StateError>());
  });

  testWidgets('Observer should report exceptions during invalidation',
      (tester) async {
    final exception = await _testThrowingObserver(
      tester,
      Exception('Some exception'),
    );
    expect(exception, isInstanceOf<MobXCaughtException>());
  });

  testWidgets('Observer unmount should dispose Reaction', (tester) async {
    final mock = MockReaction();
    when(mock.hasObservables).thenReturn(true);

    await tester.pumpWidget(
        TestObserver(mock, builder: (context) => const Placeholder()));

    await tester.pumpWidget(const Placeholder());

    verify(mock.dispose());
  });

  testWidgets("Release mode, the reaction's default name is widget.toString()",
      (tester) async {
    debugAddStackTraceInObserverName = false;
    addTearDown(() => debugAddStackTraceInObserverName = true);

    final observer = LoggingObserver(
      builder: (_) => Container(),
    );

    await tester.pumpWidget(observer);

    final element =
        // ignore: avoid_as
        tester.element(find.byWidget(observer)) as ObserverElementMixin;

    expect(element.reaction.name, equals('$observer'));
  });

  testWidgets(
      "Debug mode inserts the caller's stack frame in the reaction's name",
      (tester) async {
    final observer = LoggingObserver(
      builder: (_) => Container(),
    );

    await tester.pumpWidget(observer);

    final element =
        // ignore: avoid_as
        tester.element(find.byWidget(observer)) as ObserverElementMixin;

    expect(element.reaction.name, startsWith('$observer\n'));
    // Note that is the stack frame representation of this testWidgets()
    // anonymous function.
    expect(element.reaction.name, contains(' main.<anonymous closure>'));
  });

  testWidgets(
      'Observer stack frame lookup gracefully if caller\'s stack frame '
      'is not found', (tester) async {
    expect(
      // Provide an empty stack trace, which will not match
      Observer.debugFindConstructingStackFrame(StackTrace.fromString('')),
      null,
    );
  });

  testWidgets('Observer should log when there are no observables in builder',
      (tester) async {
    final observer = LoggingObserver(
      builder: (_) => const Placeholder(),
    );
    await tester.pumpWidget(observer);

    expect(observer.previousLog, isNotNull);
  });

  testWidgets('Observer should NOT log when there are observables in builder',
      (tester) async {
    final x = Observable(0);
    final observer = LoggingObserver(builder: (context) {
      x.value;
      return const Placeholder();
    });

    await tester.pumpWidget(observer);

    expect(observer.previousLog, isNull);
  });

  testWidgets('StatelessObserverWidget can be subclassed', (tester) async {
    await tester.pumpWidget(const ConstObserver());

    expect(find.byType(Container), findsOneWidget);
  });
  testWidgets('StatefulObserverWidget can be subclassed', (tester) async {
    // Ignore the lack of a `const` so that coverage hits the line
    // ignore: prefer_const_constructors
    await tester.pumpWidget(ConstStatefulObserver());

    expect(find.byType(Container), findsOneWidget);
  });
}

Future<MobXCaughtException> _testThrowingObserver(
  WidgetTester tester,
  Object errorToThrow,
) async {
  late Object exception;
  final prevOnError = FlutterError.onError;
  FlutterError.onError = (details) => exception = details.exception;

  try {
    final count = Observable(0);
    await tester.pumpWidget(FlutterErrorThrowingObserver(
      errorToThrow: errorToThrow,
      builder: (context) => Text(count.value.toString()),
    ));
    count.value++;
    return exception as MobXCaughtException;
  } finally {
    FlutterError.onError = prevOnError;
  }
}

class ConstObserver extends StatelessObserverWidget {
  // const keyword compiles
  const ConstObserver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();

  @override
  void log(String msg) {}
}

class ConstStatefulObserver extends StatefulObserverWidget {
  // const keyword compiles
  const ConstStatefulObserver({Key? key}) : super(key: key);

  @override
  _ConstStatefulObserverState createState() => _ConstStatefulObserverState();
}

class _ConstStatefulObserverState extends State<ConstStatefulObserver> {
  @override
  Widget build(BuildContext context) => Container();
}
