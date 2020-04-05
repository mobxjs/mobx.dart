import 'dart:async';
import 'dart:collection';

import 'package:mobx/mobx.dart';
import 'package:mobx/src/utils.dart';

part 'core/action.dart';
part 'core/atom.dart';
part 'core/computed.dart';
part 'core/context.dart';
part 'core/context_extensions.dart';
part 'core/derivation.dart';
part 'core/notification_handlers.dart';
part 'core/observable.dart';
part 'core/observable_value.dart';
part 'core/reaction.dart';
part 'core/reaction_helper.dart';
part 'interceptable.dart';
part 'listenable.dart';
part 'core/spy.dart';

/// An Exception class to capture MobX specific exceptions
class MobXException extends Error implements Exception {
  MobXException(this.message);

  String message;

  @override
  String toString() => message;
}

/// This exception would be fired when an reaction has a cycle and does
/// not stabilize in [ReactiveConfig.maxIterations] iterations
class MobXCyclicReactionException extends MobXException {
  MobXCyclicReactionException(String message) : super(message);
}

/// This captures the stack trace when user-land code throws an exception
class MobXCaughtException extends MobXException {
  MobXCaughtException(exception, {StackTrace stackTrace})
      : _exception = exception,
        _stackTrace = stackTrace,
        super('MobXCaughtException: $exception');

  final Object _exception;
  final Object _stackTrace;

  Object get exception => _exception;

  @override
  StackTrace get stackTrace => _stackTrace;
}

typedef Dispose = void Function();
typedef EqualityComparator<T> = bool Function(T, T);
