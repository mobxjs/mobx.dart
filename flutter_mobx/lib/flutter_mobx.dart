library flutter_mobx;

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

typedef ObserverBuilder = Widget Function(BuildContext);

class Observer extends StatefulWidget {
  const Observer({@required this.builder, Key key, this.context})
      : assert(builder != null),
        super(key: key);

  final ReactiveContext context;
  final ObserverBuilder builder;

  @visibleForTesting
  DerivationTracker createDerivationTracker(Function() onInvalidate) =>
      DerivationTracker(context ?? mainContext, onInvalidate);

  @override
  State<Observer> createState() => ObserverState();
}

typedef NewDerivationTracker = DerivationTracker Function(
    ReactiveContext, Function());

@visibleForTesting
class ObserverState extends State<Observer> {
  DerivationTracker _tracker;

  @override
  void initState() {
    super.initState();

    _tracker = widget.createDerivationTracker(_invalidate);
  }

  void _invalidate() => setState(noOp);

  static void noOp() {}

  @override
  Widget build(BuildContext context) {
    _tracker.start();
    try {
      return widget.builder(context);
    } finally {
      _tracker.end();
    }
  }

  @override
  void dispose() {
    _tracker.dispose();
    super.dispose();
  }
}
