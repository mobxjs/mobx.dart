import 'package:mobx/mobx.dart' as mobx;
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx_hooks/src/use_when.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class WhenMock extends Mock {
  mobx.ReactionDisposer call(
    bool Function(mobx.Reaction) predicate,
    void Function() effect, {
    String name,
    mobx.ReactiveContext context,
    int timeout,
    void Function(Object, mobx.Reaction) onError,
  });
}

class ReactionDisposerMock extends Mock implements mobx.ReactionDisposer {}

mobx.ReactionDisposer ranWhen(
  bool Function(mobx.Reaction) predicate,
  void Function() effect, {
  String name,
  mobx.ReactiveContext context,
  int timeout,
  void Function(Object, mobx.Reaction) onError,
}) =>
    WhenHook.when(
      predicate,
      effect,
      name: argThat(equals(name), named: 'name'),
      timeout: argThat(equals(timeout), named: 'timeout'),
      context: argThat(equals(context), named: 'context'),
      onError: argThat(equals(onError), named: 'onError'),
    );

void main() {
  test('WhenHook.when defaults to mobx when', () {
    expect(WhenHook.when, mobx.when);
  });

  group('useWhen', () {
    When _when;
    setUp(() {
      _when = WhenHook.when;

      WhenHook.when = WhenMock();
    });
    tearDown(() {
      WhenHook.when = _when;
      _when = null;
    });

    testWidgets('calls WhenHook.when on hook creation and no more',
        (tester) async {
      when(ranWhen(any, any, context: mobx.mainContext))
          .thenReturn(ReactionDisposerMock());
      await tester.pumpWidget(HookBuilder(builder: (_) {
        useWhen((_) {}, () {});
        return Container();
      }));

      verify(ranWhen(any, any, context: mobx.mainContext));
    });
    testWidgets('Pass down arguments', (tester) async {
      bool predicate(mobx.Reaction _) => true;
      void effect() {}
      void onError(Object obj, mobx.Reaction _) {}

      final context = mobx.ReactiveContext();

      when(ranWhen(any, any,
              name: 'name', context: context, timeout: 42, onError: onError))
          .thenReturn(ReactionDisposerMock());

      await tester.pumpWidget(HookBuilder(builder: (_) {
        useWhen(predicate, effect,
            name: 'name', context: context, timeout: 42, onError: onError);
        return Container();
      }));

      verify(ranWhen(predicate, any,
          context: context, name: 'name', timeout: 42, onError: onError));
    });

    test('throws if predicate or effect are missing', () {
      expect(() => useWhen(null, () {}), throwsAssertionError);
      expect(() => useWhen((_) {}, null), throwsAssertionError);
    });

    testWidgets('Disposes reaction when hook is unmounted', (tester) async {
      final disposer = ReactionDisposerMock();
      when(ranWhen(any, any, context: mobx.mainContext)).thenReturn(disposer);

      await tester.pumpWidget(HookBuilder(builder: (_) {
        useWhen((_) {}, () {});
        return Container();
      }));

      verifyZeroInteractions(disposer);
      await tester.pumpWidget(Container());

      verify(disposer.call()).called(1);
    });
  });
}
