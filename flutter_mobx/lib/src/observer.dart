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
    super.key,
    required this.builder,
    super.name,
    super.warnWhenNoObservables,
  }) : debugConstructingStackFrame = debugFindConstructingStackFrame();

  /// Observer which excludes the child branch from being rebuilt
  ///
  /// - [builder] is a builder function with a child widget as a parameter;
  ///
  /// - [child] is the widget to pass to the [builder] function.
  // ignore: prefer_const_constructors_in_immutables
  Observer.withBuiltChild({
    super.key,
    required Widget Function(BuildContext, Widget) builder,
    required Widget child,
    super.name,
    super.warnWhenNoObservables,
  })  : debugConstructingStackFrame = debugFindConstructingStackFrame(),
        builder = ((context) => builder(context, child));

  final WidgetBuilder builder;

  /// The stack frame pointing to the source that constructed this instance.
  final String? debugConstructingStackFrame;

  @override
  String getName() =>
      super.getName() +
      (debugConstructingStackFrame != null
          ? '\n$debugConstructingStackFrame'
          : '');

  @override
  Widget build(BuildContext context) => builder.call(context);

  /// Matches constructor stack frames, in both VM and web environments.
  static final _constructorStackFramePattern = RegExp(r'\bnew\b');

  static final _stackFrameCleanUpPattern =
      RegExp(r'^(?:#\d+\s+|\s*at (?:M\.)?)(.*)$');

  /// Finds the first non-constructor frame in the stack trace.
  ///
  /// [stackTrace] defaults to [StackTrace.current].
  @visibleForTesting
  static String? debugFindConstructingStackFrame([StackTrace? stackTrace]) {
    String? stackFrame;

    assert(() {
      if (debugAddStackTraceInObserverName) {
        final stackTraceString = (stackTrace ?? StackTrace.current).toString();
        final frames = LineSplitter.split(stackTraceString).toList();
        final rawStackFrame = frames
            .asMap()
            .entries
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
            .where((entry) {
              if (_constructorStackFramePattern.hasMatch(entry.value)) {
                return false;
              }
              // Wasm emits a constructor entry immediately after its
              // initializer frame. Both belong to construction, not the caller.
              return !(entry.value.contains(':wasm-function[') &&
                  frames[entry.key - 1].contains('(initializer)'));
            })
            .map((entry) => entry.value)
            .firstWhere((_) => true, orElse: () => '');

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
