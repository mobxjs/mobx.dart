part of '../async.dart';

/// AsyncAction uses a [Zone] to keep track of async operations like [Future], timers and other
/// kinds of micro-tasks.
///
/// You would rarely need to use this class directly. Instead, use the `@action` annotation along with
/// the `mobx_codegen` package.
abstract class AsyncAction {
  factory AsyncAction(String name, {ReactiveContext? context}) {
    context ??= mainContext;

    if (context.config.asyncActionBehavior ==
        AsyncActionBehavior.notifyEachNested) {
      return _NotifyEachNested(name, context: context);
    } else {
      return _NotifyOnlyLast(name, context: context);
    }
  }

  Future<R> run<R>(Future<R> Function() body) => throw UnimplementedError();

  // Will be invoked for a catch clause that has two arguments: exception and stacktrace
//  R _runBinary<R, A, B>(Zone self, ZoneDelegate parent, Zone zone,
//      R Function(A a, B b) f, A a, B b) {
//    final actionInfo = _actions.startAction();
//    try {
//      final result = parent.runBinary(zone, f, a, b);
//      return result;
//    } finally {
//      _actions.endAction(actionInfo);
//    }
//  }
}
