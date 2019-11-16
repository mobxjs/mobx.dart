// ignore_for_file:implementation_imports
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart' show ReactionImpl;

/// Observer observes the observables used in the `builder` function and rebuilds the Widget
/// whenever any of them change. There is no need to do any other wiring besides simply referencing
/// the required observables.
///
/// Internally, [Observer] uses a `Reaction` around the `builder` function. If your `builder` function does not contain
/// any observables, [Observer] will print a warning on the console. This is a debug-time hint to let you know that you are not observing any observables.
// ignore: must_be_immutable
class Observer extends StatefulWidget {
  /// Returns a widget that rebuilds every time an observable referenced in the
  /// [builder] function is altered.
  ///
  /// The [builder] argument must not be null. Use the [context] to specify a ReactiveContext other than the `mainContext`.
  /// Normally there is no need to change this. [name] can be used to give a debug-friendly identifier.
  Observer({@required this.builder, Key key, this.context, name})
      : assert(builder != null),
        super(key: key) {
    this.name = name ?? _defaultObserverName(context ?? mainContext);
  }

  /// An identifiable name used for debugging
  String name;

  /// The context within which its reaction should be run.
  /// It is the [mainContext] in most cases
  final ReactiveContext context;

  /// The function that generates the [Widget] as part of the [Observer].
  /// This method is wrapped in a reaction for tracking and automatically discovering the
  /// used Observables. When the Observables change, this [builder] method is invoked again.
  final WidgetBuilder builder;

  /// A convenience method used for testing.
  @visibleForTesting
  Reaction createReaction(
    Function() onInvalidate, {
    Function(Object, Reaction) onError,
  }) {
    final ctx = context ?? mainContext;

    return ReactionImpl(ctx, onInvalidate, name: name, onError: onError);
  }

  @override
  State<Observer> createState() => ObserverState();

  /// Convenience method to output console messages as debugging output.
  /// Logging usually happens when some internal error needs to be surfaced to the user.
  void log(String msg) {
    debugPrint(msg);
  }
}

/// Internal class used to track and execute the parent [Observer.builder] method
@visibleForTesting
class ObserverState extends State<Observer> {
  ReactionImpl _reaction;

  @override
  void initState() {
    super.initState();

    _reaction = widget.createReaction(invalidate, onError: (e, _) {
      FlutterError.reportError(FlutterErrorDetails(
        library: 'flutter_mobx',
        exception: e,
        stack: e is FlutterError ? e.stackTrace : null,
      ));
    });
  }

  void invalidate() => setState(noOp);

  static void noOp() {}

  @override
  Widget build(BuildContext context) {
    Widget built;

    _reaction.track(() {
      built = widget.builder(context);
    });

    if (!_reaction.hasObservables) {
      widget.log(
          'There are no observables detected in the builder function for ${_reaction.name}');
    }

    if (_reaction.errorValue != null) {
      throw _reaction.errorValue;
    }

    return built;
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }
}

String _defaultObserverName(ReactiveContext context) {
  String name;

  assert(() {
    name = 'Observer\n${StackTrace.current.toString().split('\n')[3]}';
    return true;
  }());

  // this will be applicable for release builds where there are no asserts
  return name ?? context.nameFor('Observer');
}
