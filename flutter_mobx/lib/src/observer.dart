// ignore_for_file:implementation_imports
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart' show ReactionImpl;

/// A [StatelessObserverWidget] that delegate its [build] method to [builder].
///
/// See also:
///
/// - [Builder], which is the same thing but for [StatelessWidget] instead.
class Observer extends StatelessObserverWidget
    // Implements Builder to import the documentation of `builder`
    implements
        Builder {
  // ignore: prefer_const_constructors_in_immutables
  Observer({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  @override
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

/// A [StatelessWidget] that rebuilds when an [Observable] used inside [build]
/// updates.
///
/// See also:
///
/// - [Observer], which subclass this interface and delegate its [build]
///   to a callback.
/// - [StatefulObserverWidget], similar to this class, but that has a [State].
abstract class StatelessObserverWidget extends StatelessWidget
    with ObserverWidgetMixin {
  /// Initializes [key], [context] and [name] for subclasses.
  const StatelessObserverWidget({Key key, ReactiveContext context, String name})
      : _name = name,
        _context = context,
        super(key: key);

  final String _name;
  final ReactiveContext _context;

  @override
  String getName() => _name ?? super.getName();

  @override
  ReactiveContext getContext() => _context ?? super.getContext();

  @override
  StatelessObserverElement createElement() => StatelessObserverElement(this);
}

/// An [Element] that uses a [StatelessObserverWidget] as its configuration.
class StatelessObserverElement extends StatelessElement
    with ObserverElementMixin {
  /// Creates an element that uses the given widget as its configuration.
  StatelessObserverElement(StatelessObserverWidget widget) : super(widget);

  @override
  StatelessObserverWidget get widget => super.widget as StatelessObserverWidget;
}

/// A [StatefulWidget] that rebuilds when an [Observable] used inside
/// [State.build] updates.
///
/// See also:
///
/// - [Observer], which subclass this interface and delegate its `build` to a
///   callback.
/// - [StatelessObserverWidget], similar to this class, but with no [State].
abstract class StatefulObserverWidget extends StatefulWidget
    with ObserverWidgetMixin {
  /// Initializes [key], [context] and [name] for subclasses.
  const StatefulObserverWidget({Key key, ReactiveContext context, String name})
      : _name = name,
        _context = context,
        super(key: key);

  final String _name;
  final ReactiveContext _context;

  @override
  String getName() => _name ?? super.getName();

  @override
  ReactiveContext getContext() => _context ?? super.getContext();

  @override
  StatefulObserverElement createElement() => StatefulObserverElement(this);
}

/// An [Element] that uses a [StatefulObserverWidget] as its configuration.
class StatefulObserverElement extends StatefulElement
    with ObserverElementMixin {
  /// Creates an element that uses the given widget as its configuration.
  StatefulObserverElement(StatefulObserverWidget widget) : super(widget);

  @override
  StatefulObserverWidget get widget => super.widget as StatefulObserverWidget;
}

/// Observer observes the observables used in the `build` method and rebuilds
/// the Widget whenever any of them change. There is no need to do any other
/// wiring besides simply referencing the required observables.
///
/// Internally, [ObserverWidgetMixin] uses a [Reaction] around the `build`
/// method.
///
/// If your `build` method does not contain any observables,
/// [ObserverWidgetMixin] will print a warning on the console. This is a
/// debug-time hint to let you know that you are not observing any observables.
mixin ObserverWidgetMixin on Widget {
  /// An identifiable name that can be overriden for debugging.
  ///
  /// Defaults to `widget.toString()`, and if in debug mode, a part of the
  /// stacktrace is also added.
  String getName() {
    String name;

    assert(() {
      if (debugAddStackTraceInObserverName) {
        name = '$this\n${StackTrace.current.toString().split('\n')[3]}';
      }
      return true;
    }());

    // this will be applicable for release builds where there are no asserts
    return name ?? '$this';
  }

  /// The context within which its reaction should be run. It is the
  /// [mainContext] in most cases.
  ReactiveContext getContext() => mainContext;

  /// A convenience method used for testing.
  @visibleForTesting
  Reaction createReaction(
    Function() onInvalidate, {
    Function(Object, Reaction) onError,
  }) =>
      ReactionImpl(
        getContext(),
        onInvalidate,
        name: getName(),
        onError: onError,
      );

  /// Convenience method to output console messages as debugging output. Logging
  /// usually happens when some internal error needs to be surfaced to the user.
  void log(String msg) {
    debugPrint(msg);
  }

  // We don't override `createElement` to specify that it should return a
  // `ObserverElementMixin` as it'd make the mixin impossible to use.
}

/// A mixin that overrides [build] to listen to the observables used by
/// [ObserverWidgetMixin].
mixin ObserverElementMixin on ComponentElement {
  ReactionImpl get reaction => _reaction;
  ReactionImpl _reaction;

  // Not using the original `widget` getter as it would otherwise make the mixin
  // impossible to use
  ObserverWidgetMixin get _widget => widget as ObserverWidgetMixin;

  @override
  void mount(Element parent, dynamic newSlot) {
    _reaction = _widget.createReaction(invalidate, onError: (e, _) {
      FlutterError.reportError(FlutterErrorDetails(
        library: 'flutter_mobx',
        exception: e,
        stack: e is Error ? e.stackTrace : null,
      ));
    }) as ReactionImpl;
    super.mount(parent, newSlot);
  }

  void invalidate() => markNeedsBuild();

  @override
  Widget build() {
    Widget built;

    reaction.track(() {
      built = super.build();
    });

    if (!reaction.hasObservables) {
      _widget.log(
        'No observables detected in the build method of ${reaction.name}',
      );
    }

    if (reaction.errorValue != null) {
      throw reaction.errorValue;
    }

    return built;
  }

  @override
  void unmount() {
    reaction.dispose();
    super.unmount();
  }
}

/// `true` if the StackTrace be included in the name of the Observer. This is
/// useful during debugging to identify the location where the exception is
/// thrown.
bool debugAddStackTraceInObserverName = true;
