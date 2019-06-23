import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mobx/src/core.dart';
import 'package:mockito/mockito.dart';

class MockReaction extends Mock implements ReactionImpl {}

class TestObserver extends Observer {
  const TestObserver(this.reaction, {WidgetBuilder builder})
      : super(builder: builder);

  final Reaction reaction;

  @override
  Reaction createReaction(Function() onInvalidate) => reaction;
}

// ignore: must_be_immutable
class LoggingObserver extends Observer {
  // ignore: prefer_const_constructors_in_immutables
  LoggingObserver({
    @required WidgetBuilder builder,
    Key key,
  }) : super(key: key, builder: builder);

  String previousLog;

  @override
  void log(String msg) {
    previousLog = msg;
    return super.log(msg);
  }
}

void stubTrack(MockReaction mock) {
  when(mock.track(any)).thenAnswer((invocation) {
    invocation.positionalArguments[0]();
  });
}

void main() {
  setUp(() => mainContext.config =
      ReactiveConfig(writePolicy: ReactiveWritePolicy.never));

  tearDown(() => mainContext.config = ReactiveConfig.main);

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
    stubTrack(mock);
    when(mock.hasObservables).thenReturn(true);

    await tester.pumpWidget(
        TestObserver(mock, builder: (context) => const Placeholder()));

    verify(mock.track(any));
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

    expect(exception, isInstanceOf<MobXCaughtException>());
  });

  testWidgets('Observer unmount should dispose Reaction', (tester) async {
    final mock = MockReaction();
    stubTrack(mock);
    when(mock.hasObservables).thenReturn(true);

    await tester.pumpWidget(
        TestObserver(mock, builder: (context) => const Placeholder()));

    await tester.pumpWidget(const Placeholder());

    verify(mock.dispose());
  });

  test('Observer builder must not be null', () {
    // ignore:missing_required_param,prefer_const_constructors
    expect(() => Observer(), throwsA(isInstanceOf<AssertionError>()));
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
}
