library flutter_mobx;

// ignore_for_file:implementation_imports
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart' show ReactionImpl;

class Observer extends StatefulWidget {
  /// Returns a widget that rebuilds every time an observable referenced in the
  /// [builder] function is altered.
  ///
  /// The [builder] argument must not be null.
  const Observer({@required this.builder, Key key, this.context})
      : assert(builder != null),
        super(key: key);

  final ReactiveContext context;
  final WidgetBuilder builder;

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

    assert(_reaction.hasObservables,
        'There are no observables detected in the builder function for ${_reaction.name}');

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
