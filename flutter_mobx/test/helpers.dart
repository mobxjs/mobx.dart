import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart' show ReactionImpl;
import 'package:mocktail/mocktail.dart';

// ignore: top_level_function_literal_block, prefer_function_declarations_over_variables
final voidFn = () {};

class MockReaction extends Mock implements ReactionImpl {
  @override
  void track(Function fn) {
    fn(); // Explicitly invoke this
    super.noSuchMethod(Invocation.method(#track, [voidFn]));
  }

  @override
  bool get hasObservables =>
      super.noSuchMethod(Invocation.getter(#hasObservables));
}

// ignore: must_be_immutable
class TestObserver extends Observer {
  TestObserver(this.reaction, {Key? key, required WidgetBuilder builder})
      : super(builder: builder, key: key);

  final Reaction reaction;

  @override
  Reaction createReaction(
    Function() onInvalidate, {
    Function(Object, Reaction)? onError,
  }) =>
      reaction;
}

// ignore: must_be_immutable
class LoggingObserver extends Observer {
  // ignore: prefer_const_constructors_in_immutables
  LoggingObserver({
    required WidgetBuilder builder,
    Key? key,
  }) : super(key: key, builder: builder);

  String? previousLog;

  @override
  void log(String msg) {
    previousLog = msg;
  }
}

// ignore: must_be_immutable
class FlutterErrorThrowingObserver extends Observer {
  // ignore: prefer_const_constructors_in_immutables
  FlutterErrorThrowingObserver({
    required WidgetBuilder builder,
    required this.errorToThrow,
    Key? key,
  }) : super(key: key, builder: builder);

  final Object errorToThrow;

  @override
  FlutterErrorThrowingObserverElement createElement() =>
      FlutterErrorThrowingObserverElement(this);
}

class FlutterErrorThrowingObserverElement extends StatelessObserverElement {
  FlutterErrorThrowingObserverElement(StatelessObserverWidget widget)
      : super(widget);

  @override
  FlutterErrorThrowingObserver get widget =>
      // ignore: avoid_as, this is the official way to use Element.widget
      super.widget as FlutterErrorThrowingObserver;

  @override
  void invalidate() {
    // ignore: only_throw_errors
    throw widget.errorToThrow;
  }
}
