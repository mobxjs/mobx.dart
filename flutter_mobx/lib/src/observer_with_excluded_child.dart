// ignore_for_file:implementation_imports
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/src/observer.dart' show debugAddStackTraceInObserverName;
import 'package:flutter_mobx/src/stateless_observer_widget.dart';

/// The same to [Observer], but with additional pre-built `child`, which does not re-render
class ObserverWithExcludedChild extends StatelessObserverWidget
     {  
  ObserverWithExcludedChild({
    Key? key,
    required this.builder,
    this.child,
    String? name,
    bool? warnWhenNoObservables,
  })  : debugConstructingStackFrame = debugFindConstructingStackFrame(),
        super(
          key: key,
          name: name,
          warnWhenNoObservables: warnWhenNoObservables,
        );

  /// A builder that builds a widget given a child.
  final TransitionBuilder builder;
  /// The child widget to pass to the [builder].
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
  Widget build(BuildContext context) => builder(context, child);

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
                (frame) => !_constructorStackFramePattern.hasMatch(frame),
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
