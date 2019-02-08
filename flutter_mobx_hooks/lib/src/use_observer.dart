import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
// ignore: implementation_imports
import 'package:mobx/src/core.dart' show ReactionImpl;

void useObserver({ReactiveContext context}) {
  final observer =
      context == null ? const ObserverHook() : ObserverHook(context: context);
  Hook.use(observer);
}

@visibleForTesting
class ObserverHook extends Hook<void> {
  const ObserverHook({this.context});

  // TODO(rrousselGit): scoped constructor

  final ReactiveContext context;

  @override
  HookState<void, Hook> createState() => ObserverHookState();
}

@visibleForTesting
class ObserverHookState extends HookState<void, ObserverHook> {
  ReactionImpl reaction;
  Derivation prevDerivation;

  @override
  void initHook() {
    super.initHook();
    reaction = createReaction();
  }

  Reaction createReaction() {
    final ctx = hook.context ?? mainContext;
    final name = ctx.nameFor('ObserverHook-Reaction');
    return ReactionImpl(ctx, onInvalidate, name: name);
  }

  void onInvalidate() => setState(_noOp);

  static void _noOp() {}

  @override
  void build(BuildContext context) {
    prevDerivation = reaction.startTracking();
  }

  @override
  void didBuild() {
    super.didBuild();
    reaction.endTracking(prevDerivation);
    prevDerivation = null;
  }

  @override
  void dispose() {
    reaction.dispose();

    super.dispose();
  }
}
