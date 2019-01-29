import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx_hooks/src/use_observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/src/core.dart';
import 'package:mockito/mockito.dart';

class MockReaction extends Mock implements ReactionImpl {}

class TestObserver extends ObserverHook {
  const TestObserver(this.reaction);

  final MockReaction reaction;

  @override
  Reaction createReaction(void Function() onInvalidate) => reaction;
}

void useTestObserver(MockReaction reaction) {
  Hook.use(TestObserver(reaction));
}

class UseObserver extends HookWidget {
  UseObserver(this.builder) : assert(builder != null);

  static int _counter = 0;

  final int counter = _counter++;

  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    print('START BUILD $counter');
    useObserver();
    final widget = builder();
    print('END BUILD $counter');
    return widget;
  }
}

class UseObserverWithReaction extends HookWidget {
  const UseObserverWithReaction(this.reaction, this.builder);

  final MockReaction reaction;
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    useTestObserver(reaction);
    return builder();
  }
}

// ignore:one_member_abstracts
abstract class Builder {
  Widget call();
}

class MockBuilder extends Mock implements Builder {}

class StateWidget extends StatelessWidget {
  factory StateWidget({Key key, Observable<int> state}) =>
      StateWidget._(key: key, value: state.value);

  const StateWidget._({Key key, this.value}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) => Container();

  static int findValue(WidgetTester tester, Key key) =>
      tester.widget<StateWidget>(find.byKey(key)).value;
}

void main() {
  group('useObserver', () {
    testWidgets('Widget updated when observable state updates', (tester) async {
      final count = Observable(0);

      await tester.pumpWidget(UseObserver(() =>
          Text('Count ${count.value}', textDirection: TextDirection.ltr)));

      expect(tester.widget<Text>(find.byType(Text)).data, equals('Count 0'));

      count.value++;
      await tester.pump();
      expect(tester.widget<Text>(find.byType(Text)).data, equals('Count 1'));
    });

    testWidgets('ObserverHookState disposes reaction', (tester) async {
      final reaction = MockReaction();

      await tester
          .pumpWidget(UseObserverWithReaction(reaction, () => Container()));

      verifyNever(reaction.dispose());

      await tester.pumpWidget(Container());

      verify(reaction.dispose()).called(1);
    });

    testWidgets(
        'Building a widget using useObserver hook tracks the build method of the widget',
        (tester) async {
      final reaction = MockReaction();
      final builder = MockBuilder();
      when(builder.call()).thenReturn(Container());

      await tester.pumpWidget(UseObserverWithReaction(reaction, builder));

      verifyInOrder([
        reaction.startTracking(),
        builder.call(),
        reaction.endTracking(any)
      ]);
    });

    testWidgets('errors', (tester) async {
      final outerKey = GlobalKey(debugLabel: 'outerKey');
      final innerKey = GlobalKey(debugLabel: 'innerKey');

      final outerState = Observable(0);
      final innerState = Observable(0);

      var outerRenderCount = 0;
      var innerRenderCount = 0;

      // we cache the instance, or else outer build rebuild the inner widget too
      final innerWidget = UseObserver(() {
        innerRenderCount++;
        return StateWidget(key: innerKey, state: innerState);
      });

      Widget builder() {
        outerRenderCount++;
        return Column(
          children: <Widget>[
            StateWidget(key: outerKey, state: outerState),
            innerWidget,
          ],
        );
      }

      await tester.pumpWidget(UseObserver(builder));

      expect(outerRenderCount, equals(1));
      expect(innerRenderCount, equals(1));
      expect(StateWidget.findValue(tester, outerKey), equals(0));

      await tester.pump();
      expect(outerRenderCount, equals(1));
      expect(innerRenderCount, equals(1));

      innerState.value++;
      await tester.pump();
      expect(outerRenderCount, equals(1));
      expect(innerRenderCount, equals(2));
      expect(StateWidget.findValue(tester, innerKey), equals(1));
      expect(StateWidget.findValue(tester, outerKey), equals(0));

      print('LAST');
      outerState.value++;
      await tester.pump();
      expect(outerRenderCount, equals(2));
      expect(innerRenderCount, equals(2));
      expect(StateWidget.findValue(tester, outerKey), equals(1));
      expect(StateWidget.findValue(tester, innerKey), equals(1));
    });
  });
}
