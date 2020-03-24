import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
// ignore: implementation_imports
import 'package:mobx/src/core.dart' show ReactionImpl;

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
  String getName();

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

    return built;
  }

  @override
  void unmount() {
    reaction.dispose();
    super.unmount();
  }
}
