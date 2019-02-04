import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

typedef ErrorHandler = void Function(Object, Reaction);
typedef ReactionHandler = void Function(Reaction);

void useAutorun(
  ReactionHandler fn, {
  String name,
  int delay,
  ReactiveContext context,
  ErrorHandler onError,
}) {
  Hook.use(AutorunHook(
    fn,
    name: name,
    delay: delay,
    context: context,
    onError: onError,
  ));
}

class AutorunHook extends Hook<void> {
  const AutorunHook(
    this.fn, {
    this.onError,
    this.delay,
    this.name,
    this.context,
  });

  static ReactionDisposer Function(
    Function(Reaction) fn, {
    String name,
    int delay,
    ReactiveContext context,
    void Function(Object, Reaction) onError,
  }) run = autorun;

  final ReactionHandler fn;
  final ErrorHandler onError;
  final int delay;
  final String name;
  final ReactiveContext context;

  @override
  _AutorunHookState createState() => _AutorunHookState();
}

class _AutorunHookState extends HookState<void, AutorunHook> {
  ReactionDisposer disposer;

  ReactiveContext get _reactiveContext => hook.context ?? mainContext;

  @override
  void initHook() {
    _run();
  }

  @override
  void didUpdateHook(AutorunHook oldHook) {
    if (hook.context != oldHook.context) {
      disposer();
      _run();
    }
    // TODO(rrousselGit): hot reload name/delay/onError
  }

  void _run() {
    disposer = AutorunHook.run(
      hook.fn,
      onError: hook.onError,
      context: _reactiveContext,
      delay: hook.delay,
      name: hook.name,
    );
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    disposer();
  }
}
