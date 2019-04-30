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
  /// The [builder] argument must not be null. Use the [context] to specify a ReactiveContext other than the `mainContext`.
  /// Normally there is no need to change this. [name] can be used to give a debug-friendly identifier.
  const Observer({@required this.builder, Key key, this.context, this.name})
      : assert(builder != null),
        super(key: key);

  final String name;
  final ReactiveContext context;
  final WidgetBuilder builder;

  @visibleForTesting
  Reaction createReaction(Function() onInvalidate) {
    final ctx = context ?? mainContext;
    return ReactionImpl(ctx, onInvalidate,
        name: name ?? 'Observer@${ctx.nextId}');
  }

  @override
  State<Observer> createState() => _ObserverState();

  void log(String msg) {
    debugPrint(msg);
  }
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

    if (!_reaction.hasObservables) {
      widget.log(
          'There are no observables detected in the builder function for ${_reaction.name}');
    }

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
