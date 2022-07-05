part of '../async.dart';

class _NotifyAsyncAction implements AsyncAction {
  _NotifyAsyncAction(String name, {ReactiveContext? context})
      : this._(context ?? mainContext, name);

  _NotifyAsyncAction._(ReactiveContext context, String name)
      : _actions = ActionController(context: context, name: name);

  final ActionController _actions;

  Zone? _zoneField;

  Zone get _zone {
    if (_zoneField == null) {
      final spec = ZoneSpecification(run: _run, runUnary: _runUnary);
      _zoneField = Zone.current.fork(specification: spec);
    }
    return _zoneField!;
  }

  @override
  Future<R> run<R>(Future<R> Function() body) {
    throw UnimplementedError();
  }

  R _run<R>(Zone self, ZoneDelegate parent, Zone zone, R Function() f) {
    throw UnimplementedError();
  }

  R _runUnary<R, A>(
      Zone self, ZoneDelegate parent, Zone zone, R Function(A a) f, A a) {
    throw UnimplementedError();
  }
}

class _NotifyEachNested extends _NotifyAsyncAction {
  _NotifyEachNested(super.name, {ReactiveContext? context});

  @override
  Future<R> run<R>(Future<R> Function() body) async {
    try {
      return await _zone.run(body);
    } finally {
      // @katis:
      // Delay completion until next microtask completion.
      // Needed to make sure that all mobx state changes are
      // applied after `await run()` completes, not sure why.
      await Future.microtask(_noOp);
    }
  }

  @override
  R _run<R>(Zone self, ZoneDelegate parent, Zone zone, R Function() f) {
    final actionInfo = _actions.startAction();
    try {
      final result = parent.run(zone, f);
      return result;
    } finally {
      _actions.endAction(actionInfo);
    }
  }

  @override
  R _runUnary<R, A>(
      Zone self, ZoneDelegate parent, Zone zone, R Function(A a) f, A a) {
    final actionInfo = _actions.startAction();
    try {
      final result = parent.runUnary(zone, f, a);
      return result;
    } finally {
      _actions.endAction(actionInfo);
    }
  }

  static dynamic _noOp() => null;
}

class _NotifyOnlyLast extends _NotifyAsyncAction {
  _NotifyOnlyLast(super.name, {ReactiveContext? context});

  @override
  Future<R> run<R>(Future<R> Function() body) async {
    final actionInfo = _actions.startAction(name: _actions.name);
    try {
      return await _zone.run(body);
    } finally {
      // @katis:
      // Delay completion until next microtask completion.
      // Needed to make sure that all mobx state changes are
      // applied after `await run()` completes, not sure why.
      await Future.microtask(_noOp);
      _actions.endAction(actionInfo);
    }
  }

  @override
  R _run<R>(Zone self, ZoneDelegate parent, Zone zone, R Function() f) {
    final result = parent.run(zone, f);
    return result;
  }

  @override
  R _runUnary<R, A>(
      Zone self, ZoneDelegate parent, Zone zone, R Function(A a) f, A a) {
    final result = parent.runUnary(zone, f, a);
    return result;
  }

  static dynamic _noOp() => null;
}
