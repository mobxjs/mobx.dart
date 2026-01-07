part of '../core.dart';

extension ConditionalAction on ReactiveContext {
  /// Only run within an action if outside a batch
  /// [fn] is the function to execute. Optionally provide a debug-[name].
  void conditionallyRunInAction(
    void Function() fn,
    Atom atom, {
    String? name,
    ActionController? actionController,
  }) {
    if (isWithinBatch) {
      enforceWritePolicy(atom);
      fn();
    } else {
      final controller =
          actionController ??
          ActionController(
            context: this,
            name: name ?? nameFor('conditionallyRunInAction'),
          );
      final runInfo = controller.startAction();

      try {
        enforceWritePolicy(atom);
        fn();
      } finally {
        controller.endAction(runInfo);
      }
    }
  }
}
