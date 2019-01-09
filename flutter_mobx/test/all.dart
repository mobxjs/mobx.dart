import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';

class MockTracker extends Mock implements DerivationTracker {}

class TestObserver extends Observer {
  const TestObserver(this.tracker, {ObserverBuilder builder})
      : super(builder: builder);

  final DerivationTracker tracker;

  @override
  DerivationTracker createDerivationTracker(Function() onInvalidate) => tracker;
}

void main() {
  testWidgets('Observer re-renders when observed state changes',
      (tester) async {
    final message = observable('Click');

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

    final i = observable(0);

    await tester.pumpWidget(Observer(builder: (context) {
      renderCount++;
      i.value;
      return const Placeholder();
    }));

    expect(renderCount, equals(1));

    await tester.pump();

    expect(renderCount, equals(1));
  });

  testWidgets('Observer build should call tracker start and end',
      (tester) async {
    final mock = MockTracker();

    await tester.pumpWidget(
        TestObserver(mock, builder: (context) => const Placeholder()));

    verify(mock.start());
    verify(mock.end());
  });

  testWidgets(
      'Observer build should call tracker start and end even when build throws',
      (tester) async {
    final mock = MockTracker();
    final error = Error();

    dynamic exception;

    FlutterError.onError = (details) {
      exception = details.exception;
    };

    await tester.pumpWidget(TestObserver(mock, builder: (context) {
      throw error;
    }));

    expect(exception, equals(error));
    verify(mock.start());
    verify(mock.end());
  });

  testWidgets('Observer unmount should dispose DerivationTracker',
      (tester) async {
    final mock = MockTracker();

    await tester.pumpWidget(
        TestObserver(mock, builder: (context) => const Placeholder()));

    await tester.pumpWidget(const Placeholder());

    verify(mock.dispose());
  });
}
