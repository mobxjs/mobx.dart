import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx_hooks/src/use_autorun.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/mockito.dart';

class AutorunMock extends Mock {
  ReactionDisposer call(
    Function(Reaction) fn, {
    String name,
    int delay,
    ReactiveContext context,
    void Function(Object, Reaction) onError,
  });
}

class Dispose extends Mock implements ReactionDisposer {}

ReactionDisposer mockAutorun(
  Function(Reaction) fn, {
  String name,
  int delay,
  ReactiveContext context,
  void Function(Object, Reaction) onError,
}) =>
    AutorunHook.run(
      fn,
      name: argThat(equals(name), named: 'name'),
      delay: argThat(equals(delay), named: 'delay'),
      context: argThat(equals(context), named: 'context'),
      onError: argThat(equals(onError), named: 'onError'),
    );

void main() {
  // necessary alias to AutorunHook.run, or else verifyNoMoreInterations
  // infer the mock as a function instead of Mock, which crashes.
  AutorunMock mock;

  Widget build(
    Function(Reaction) fn, {
    String name,
    int delay,
    ReactiveContext context,
    void Function(Object, Reaction) onError,
  }) =>
      HookBuilder(builder: (_) {
        useAutorun(fn,
            onError: onError, name: name, context: context, delay: delay);
        return Container();
      });

  setUp(() {
    mock = AutorunMock();
    AutorunHook.run = mock;
  });
  tearDown(() {
    AutorunHook.run = autorun;
    mock = null;
  });

  testWidgets('calls autorun only on first build', (tester) async {
    when(mockAutorun(any,
            context: mainContext, delay: null, name: null, onError: null))
        .thenReturn(Dispose());

    await tester.pumpWidget(build(null));

    verify(mockAutorun(any,
            context: mainContext, delay: null, name: null, onError: null))
        .called(1);
    verifyNoMoreInteractions(mock);

    await tester.pumpWidget(build(null));

    verifyNoMoreInteractions(mock);
  });
  testWidgets('disposes reaction when unmounted', (tester) async {
    final dispose = Dispose();
    when(mockAutorun(any,
            context: mainContext, delay: null, name: null, onError: null))
        .thenReturn(dispose);

    await tester.pumpWidget(build(null));
    verifyZeroInteractions(dispose);

    await tester.pumpWidget(Container());
    verify(dispose.call()).called(1);
  });

  testWidgets('pass down arguments to autorun', (tester) async {
    final dispose = Dispose();
    final context = ReactiveContext();
    void onError(Object _, Reaction __) {}
    void handler(Reaction _) {}

    when(mockAutorun(handler,
            context: context, delay: 42, name: 'foo', onError: onError))
        .thenReturn(dispose);

    await tester.pumpWidget(build(handler,
        onError: onError, name: 'foo', delay: 42, context: context));

    verify(mockAutorun(handler,
        context: context, delay: 42, name: 'foo', onError: onError));
  });

  testWidgets('disposes reaction when context changes', (tester) async {
    final dispose = Dispose();

    when(mockAutorun(any,
            context: mainContext, delay: null, name: null, onError: null))
        .thenReturn(dispose);
    final context2 = ReactiveContext();
    final dispose2 = Dispose();
    when(mockAutorun(any,
            context: context2, delay: null, name: null, onError: null))
        .thenReturn(dispose2);

    await tester.pumpWidget(build(null));
    verifyZeroInteractions(dispose);

    await tester.pumpWidget(build(null, context: context2));
    verify(dispose.call()).called(1);
    verifyZeroInteractions(dispose2);
    verifyNoMoreInteractions(dispose);

    await tester.pumpWidget(Container());
    verify(dispose2.call()).called(1);
  });
}
