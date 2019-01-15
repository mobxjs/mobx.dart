library flutter_mobx;

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

// ignore:implementation_imports
import 'package:mobx/src/core.dart' show ReactionImpl;

typedef BuildObserved = Widget Function(BuildContext);

class Observer extends StatefulWidget {
  const Observer({@required this.builder, Key key, this.context})
      : assert(builder != null),
        super(key: key);

  final ReactiveContext context;
  final BuildObserved builder;

  @visibleForTesting
  Reaction createReaction(Function() onInvalidate) =>
      ReactionImpl(context ?? mainContext, onInvalidate);

  @override
  State<Observer> createState() => ObserverState();
}

class ObserverState extends State<Observer> {
  ReactionImpl _reaction;

  @override
  void initState() {
    super.initState();

    _reaction = widget.createReaction(_invalidate);
  }

  void _invalidate() => setState(noOp);

  static void noOp() {}

  @override
  Widget build(BuildContext context) {
    Widget built;
    dynamic error;

    _reaction.track(() {
      try {
        built = widget.builder(context);
      } on Object catch (ex) {
        error = ex;
      }
    });

    if (error != null) {
      throw error;
    }
    return built;
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }
}
