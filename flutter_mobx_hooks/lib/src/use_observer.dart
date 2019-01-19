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

class ObserverHook extends Hook<void> {
  const ObserverHook({this.context});

  final ReactiveContext context;

  @override
  HookState<void, Hook> createState() => ObserverHookState();

  Reaction createReaction(void Function() onInvalidate) {
    final ctx = context ?? mainContext;
    final name = ctx.nameFor('ObserverHook-Reaction');
    return ReactionImpl(context ?? mainContext, onInvalidate, name: name);
  }
}

class ObserverHookState extends HookState<void, ObserverHook> {
  ReactionImpl _reaction;
  Derivation _prevDerivation;

  @override
  void initHook() {
    super.initHook();

    _initReaction();
  }

  void _initReaction() {
    _reaction = hook.createReaction(onInvalidate);
  }

  void onInvalidate() => setState(_noOp);

  static void _noOp() {}

  @override
  void build(BuildContext context) {
    print('START TRACKING ${_reaction.name}');
    _prevDerivation = _reaction.startTracking();
  }

  @override
  void didBuild() {
    super.didBuild();

    print('END TRACKING ${_reaction.name}');
    _reaction.endTracking(_prevDerivation);
    _prevDerivation = null;
  }

  @override
  void dispose() {
    _reaction.dispose();

    super.dispose();
  }
}
