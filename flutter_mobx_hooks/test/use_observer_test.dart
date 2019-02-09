import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx_hooks/src/use_observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mobx/src/core.dart';
import 'package:mockito/mockito.dart';

class MockReaction extends Mock implements ReactionImpl {}

class TestObserver extends ObserverHook {
  const TestObserver(this.reaction);

  final MockReaction reaction;

  @override
  TestObserverState createState() => TestObserverState();
}

class TestObserverState extends ObserverHookState {
  @override
  TestObserver get hook => super.hook;

  @override
  Reaction createReaction() => hook.reaction;
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
    useObserver();
    final widget = builder();
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

Iterable<ObserverHookState> _findObserverHook() => find
    .byElementType(HookElement)
    .evaluate()
    // ignore: avoid_as
    .map((e) => (e as HookElement).debugHooks)
    .fold<List<ObserverHookState>>(
        [],
        (result, value) =>
            result..addAll(value.whereType<ObserverHookState>()));

void main() {
  group('useObserver', () {
    testWidgets('useObserver recreates reaction when context changes',
        (tester) async {
      await tester.pumpWidget(HookBuilder(builder: (_) {
        useObserver();
        return Container();
      }));

      final hookState = _findObserverHook().first;

      final Reaction reaction = hookState.reaction;

      await tester.pumpWidget(HookBuilder(builder: (_) {
        useObserver(context: ReactiveContext());
        return Container();
      }));

      expect(hookState.reaction, isNot(reaction));
      expect(reaction.isDisposed, true);
    });
    testWidgets("useObserver don't recreate reaction when context goes from null to mainContext",
        (tester) async {
      await tester.pumpWidget(HookBuilder(builder: (_) {
        useObserver();
        return Container();
      }));

      final hookState = _findObserverHook().first;

      final Reaction reaction = hookState.reaction;

      await tester.pumpWidget(HookBuilder(builder: (_) {
        useObserver(context: mobx.mainContext);
        return Container();
      }));

      expect(hookState.reaction, reaction);
      expect(reaction.isDisposed, false);
    });

    testWidgets('Widget updated when observable state updates', (tester) async {
      final count = Observable(0);

      await tester.pumpWidget(UseObserver(() =>
          Text('Count ${count.value}', textDirection: TextDirection.ltr)));

      expect(find.text('Count 0'), findsOneWidget);
      Action(() => count.value++)();
      await tester.pump();
      expect(find.text('Count 1'), findsOneWidget);
    });

    testWidgets('ObserverHookState disposes reaction', (tester) async {
      await tester.pumpWidget(HookBuilder(
        builder: (_) {
          useObserver();
          return Container();
        },
      ));

      final hook = _findObserverHook().first;
      expect(hook.reaction.isDisposed, false);

      await tester.pumpWidget(Container());

      expect(hook.reaction.isDisposed, true);
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

      Action(() => innerState.value++)();

      await tester.pump();
      expect(outerRenderCount, equals(1));
      expect(innerRenderCount, equals(2));
      expect(StateWidget.findValue(tester, innerKey), equals(1));
      expect(StateWidget.findValue(tester, outerKey), equals(0));

      Action(() => outerState.value++)();
      await tester.pump();
      expect(outerRenderCount, equals(2));
      expect(innerRenderCount, equals(2));
      expect(StateWidget.findValue(tester, outerKey), equals(1));
      expect(StateWidget.findValue(tester, innerKey), equals(1));
    });
  });
}
