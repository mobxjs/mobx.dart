// ignore_for_file:implementation_imports
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/src/stateless_observer_widget.dart';

/// `true` if a stack frame indicating where an [Observer] was created should be
/// included in its name. This is useful during debugging to identify the source
/// of warnings or errors.
///
/// Note that stack frames are only included in debug builds.
bool debugAddStackTraceInObserverName = true;

/// A [StatelessObserverWidget] that delegate its [build] method to [builder].
///
/// See also:
///
/// - [Builder], which is the same thing but for [StatelessWidget] instead.
class Observer extends StatelessObserverWidget {
  // ignore: prefer_const_constructors_in_immutables
  Observer({
    Key? key,
    required this.builder,
    String? name,
    bool? warnWhenNoObservables,
  })  : debugConstructingStackFrame = debugFindConstructingStackFrame(),
        builderWithChild = null,
        child = null,
        assert(builder != null),
        super(
          key: key,
          name: name,
          warnWhenNoObservables: warnWhenNoObservables,
        );

  /// Observer which excludes the child branch from being rebuilt
  // ignore: prefer_const_constructors_in_immutables
  Observer.withBuiltChild({
    Key? key,
    required this.builderWithChild,
    required this.child,
    String? name,
    bool? warnWhenNoObservables,
  })  : debugConstructingStackFrame = debugFindConstructingStackFrame(),
        builder = null,
        assert(builderWithChild != null && child != null),
        super(
          key: key,
          name: name,
          warnWhenNoObservables: warnWhenNoObservables,
        );

  /// regular builder, suitable for most cases
  final WidgetBuilder? builder;

  /// builder function with child parameter
  final TransitionBuilder? builderWithChild;

  /// The child widget to pass to the [builderWithChild].
  final Widget? child;

  /// The stack frame pointing to the source that constructed this instance.
  final String? debugConstructingStackFrame;

  @override
  String getName() =>
    super.getName() + 
    (debugConstructingStackFrame != null
      ? '\n$debugConstructingStackFrame'
      : '');

  @override
  Widget build(BuildContext context) => builderWithChild?.call(context, child) ?? builder!.call(context);

  /// Matches constructor stack frames, in both VM and web environments.
  static final _constructorStackFramePattern = RegExp(r'\bnew\b');

  static final _stackFrameCleanUpPattern = RegExp(r'^#\d+\s+(.*)$');

  /// Finds the first non-constructor frame in the stack trace.
  ///
  /// [stackTrace] defaults to [StackTrace.current].
  @visibleForTesting
  static String? debugFindConstructingStackFrame([StackTrace? stackTrace]) {
    String? stackFrame;

    assert(() {
      if (debugAddStackTraceInObserverName) {
        final stackTraceString = (stackTrace ?? StackTrace.current).toString();
        final rawStackFrame = LineSplitter.split(stackTraceString)
            // We are skipping frames representing:
            // 1. The anonymous function in the assert
            // 2. The debugFindConstructingStackFrame method
            // 3. The constructor invoking debugFindConstructingStackFrame
            //
            // The 4th frame is either user source (which is what we want), or
            // an Observer subclass' constructor (which we skip past with the
            // regex)
            .skip(3)
            // Search for the first non-constructor frame
            .firstWhere(
              (frame) => 
                !_constructorStackFramePattern.hasMatch(frame),
                orElse: () => '');

        final stackFrameCore =
          _stackFrameCleanUpPattern.firstMatch(rawStackFrame)?.group(1);
        final cleanedStackFrame = stackFrameCore == null
          ? null
          : 'Observer constructed from: $stackFrameCore';

        stackFrame = cleanedStackFrame;
      }

      return true;
    }());

    return stackFrame;
  }
}
