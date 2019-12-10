import 'dart:async';
import 'dart:collection';

import 'package:mobx/mobx.dart';
import 'package:mobx/src/utils.dart';

part 'core/action.dart';
part 'core/atom.dart';
part 'core/computed.dart';
part 'core/context.dart';
part 'core/derivation.dart';
part 'core/notification_handlers.dart';
part 'core/observable.dart';
part 'core/observable_value.dart';
part 'core/reaction.dart';
part 'core/reaction_helper.dart';
part 'interceptable.dart';
part 'listenable.dart';

/// An Exception class to capture MobX specific exceptions
class MobXException implements Exception {
  MobXException(this.message);

  String message;

  @override
  String toString() => message;
}

/// This exception would be fired when an reaction has a cycle and does
/// not stabilize in [ReactiveConfig.maxIterations] iterations
class MobXCyclicReactionException implements Exception {
  MobXCyclicReactionException(this.message);

  String message;
}

/// This captures the stack trace when user-land code throws an exception
class MobXCaughtException implements Exception {
  MobXCaughtException(exception) : _exception = exception;

  final Object _exception;
  Object get exception => _exception;

  @override
  String toString() => 'MobXCaughtException: $exception';
}

typedef Dispose = void Function();
typedef EqualityComparator<T> = bool Function(T, T);
