import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart' as mobx;

typedef When = mobx.ReactionDisposer Function(
  bool Function(mobx.Reaction) predicate,
  void Function() effect, {
  String name,
  mobx.ReactiveContext context,
  int timeout,
  void Function(Object, mobx.Reaction) onError,
});

typedef Predicate = bool Function(mobx.Reaction);
typedef Effect = void Function();
typedef ErrorListener = void Function(Object, mobx.Reaction);

void useWhen(
  Predicate predicate,
  Effect effect, {
  String name,
  mobx.ReactiveContext context,
  int timeout,
  ErrorListener onError,
}) {
  Hook.use(WhenHook(
    predicate,
    effect,
    name: name,
    context: context,
    timeout: timeout,
    onError: onError,
  ));
}

@visibleForTesting
class WhenHook extends Hook<void> {
  const WhenHook(
    this.predicate,
    this.effect, {
    this.name,
    this.context,
    this.timeout,
    this.onError,
  })  : assert(predicate != null),
        assert(effect != null);

  static When when = mobx.when;

  final Predicate predicate;
  final Effect effect;
  final String name;
  final mobx.ReactiveContext context;
  final int timeout;
  final ErrorListener onError;

  @override
  _WhenHookState createState() => _WhenHookState();
}

class _WhenHookState extends HookState<void, WhenHook> {
  mobx.ReactionDisposer disposer;

  @override
  void initHook() {
    disposer = WhenHook.when(
      hook.predicate,
      null,
      name: hook.name,
      context: hook.context ?? mobx.mainContext,
      timeout: hook.timeout,
      onError: hook.onError,
    );
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    disposer();
  }
}
