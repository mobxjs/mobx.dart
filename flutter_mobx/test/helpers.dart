// @todo pavanpodila: remove once Mockito is null-safe
// @dart = 2.10

import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart';
import 'package:mockito/mockito.dart' as M;

class MockReaction extends M.Mock implements ReactionImpl {}

// ignore: must_be_immutable
class TestObserver extends Observer {
  TestObserver(this.reaction, {@required WidgetBuilder builder})
      : super(builder: builder);

  final Reaction reaction;

  @override
  Reaction createReaction(
    Function() onInvalidate, {
    Function(Object, Reaction) onError,
  }) =>
      reaction;
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
  }
}

// ignore: must_be_immutable
class FlutterErrorThrowingObserver extends Observer {
  // ignore: prefer_const_constructors_in_immutables
  FlutterErrorThrowingObserver({
    @required WidgetBuilder builder,
    @required this.errorToThrow,
    Key key,
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

void stubTrack(MockReaction mock) {
  M.when(mock.track(M.any)).thenAnswer((invocation) {
    invocation.positionalArguments[0]();
  });
}
