part of '../async.dart';

/// AsyncAction uses a [Zone] to keep track of async operations like [Future], timers and other
/// kinds of micro-tasks.
///
/// You would rarely need to use this class directly. Instead, use the `@action` annotation along with
/// the `mobx_codegen` package.
class AsyncAction {
  AsyncAction(String name, {ReactiveContext? context})
    : this._(context ?? mainContext, name);

  AsyncAction._(ReactiveContext context, String name)
    : _actions = ActionController(context: context, name: name);

  final ActionController _actions;

  Future<R> run<R>(Future<R> Function() body) async {
    try {
      // Each invocation inherits its caller's values, error handlers and zone hooks.
      final zone = Zone.current.fork(
        specification: ZoneSpecification(
          run: _run,
          runUnary: _runUnary,
          runBinary: _runBinary,
        ),
      );
      return await zone.run(body);
    } finally {
      // @katis:
      // Delay completion until next microtask completion.
      // Needed to make sure that all mobx state changes are
      // applied after `await run()` completes, not sure why.
      await Future.microtask(_noOp);
    }
  }

  static dynamic _noOp() => null;

  R _run<R>(Zone self, ZoneDelegate parent, Zone zone, R Function() f) {
    final actionInfo = _actions.startAction(name: '${_actions.name}(Zone.run)');
    try {
      final result = parent.run(zone, f);
      return result;
    } finally {
      _actions.endAction(actionInfo);
    }
  }

  // Will be invoked for a catch clause that has a single argument: exception or
  // when a result is produced
  R _runUnary<R, A>(
    Zone self,
    ZoneDelegate parent,
    Zone zone,
    R Function(A a) f,
    A a,
  ) {
    final actionInfo = _actions.startAction(
      name: '${_actions.name}(Zone.runUnary)',
    );
    try {
      final result = parent.runUnary(zone, f, a);
      return result;
    } finally {
      _actions.endAction(actionInfo);
    }
  }

  R _runBinary<R, A, B>(
    Zone self,
    ZoneDelegate parent,
    Zone zone,
    R Function(A a, B b) f,
    A a,
    B b,
  ) {
    final actionInfo = _actions.startAction(
      name: '${_actions.name}(Zone.runBinary)',
    );
    try {
      return parent.runBinary(zone, f, a, b);
    } finally {
      _actions.endAction(actionInfo);
    }
  }
}
