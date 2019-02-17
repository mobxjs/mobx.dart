library flutter_mobx;

// ignore_for_file:implementation_imports
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart' show ReactionImpl;

/// Observer observes the observables used in the `builder` function and rebuilds the Widget
/// whenever any of them change. There is no need to do any other wiring besides simply referencing
/// the required observables.
///
/// Internally, [Observer] uses a `Reaction` around the `builder` function. If your `builder` function does not contain
/// any observables, [Observer] will throw an [AssertionError]. This is a debug-time hint to let you know that you are not observing any observables.
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
  State<Observer> createState() => _ObserverState();
}

class _ObserverState extends State<Observer> {
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
