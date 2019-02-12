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

void stubTrack(MockReaction mock) {
  when(mock.track(any)).thenAnswer((invocation) {
    invocation.positionalArguments[0]();
  });
}

void main() {
  setUp(() => mainContext.config =
      ReactiveConfig(enforceActions: EnforceActions.never));

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

  testWidgets('Observer should keep working even if builder throws once',
      (tester) async {
    final error = Error();

    dynamic exception;

    final prevOnError = FlutterError.onError;

    FlutterError.onError = (details) {
      exception = details.exception;
    };

    final count = Observable(0);

    final widget = Container();
    await tester.pumpWidget(Observer(builder: (context) {
      if (count.value == 0) {
        throw error;
      }
      return widget;
    }));

    FlutterError.onError = prevOnError;

    count.value++;

    await tester.pump();

    expect(tester.firstWidget(find.byWidget(widget)), equals(widget));

    expect(exception, equals(error));
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

  testWidgets('Observer should assert when there are no observables in builder',
      (tester) async {
    await tester
        .pumpWidget(Observer(builder: (context) => const Placeholder()));

    expect(tester.takeException(), isInstanceOf<AssertionError>());
  });

  testWidgets(
      'Observer should NOT assert when there are observables in builder',
      (tester) async {
    final x = Observable(0);

    await tester.pumpWidget(Observer(builder: (context) {
      x.value;
      return const Placeholder();
    }));

    expect(tester.takeException(), isNull);
  });
}
