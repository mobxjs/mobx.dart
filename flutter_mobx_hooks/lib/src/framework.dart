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
    _reaction = ReactionImpl(hook.context ?? mainContext, onInvalidate);
  }

  void onInvalidate() => setState(_noOp);

  static void _noOp() {}

  @override
  void build(BuildContext context) {
    _prevDerivation = _reaction.startTracking();
  }

  @override
  void didBuild() {
    super.didBuild();

    _reaction.endTracking(_prevDerivation);
    _prevDerivation = null;
  }

  @override
  void dispose() {
    _reaction.dispose();

    super.dispose();
  }
}
