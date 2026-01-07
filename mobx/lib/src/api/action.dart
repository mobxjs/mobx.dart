import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

/// Executes the mutation function [fn] within an `Action`. This ensures that all change notifications
/// are fired only at the end of the `Action` block. Note that actions can be nested, in which case
/// the notifications go out when the outermost `Action` completes.
///
/// Giving a [name] makes it easier to identify this action during debugging. You can also run this in a
/// custom [context]. By default the `mainContext` will be used.
T runInAction<T>(T Function() fn, {String? name, ReactiveContext? context}) =>
    Action(fn, name: name, context: context)() as T;

/// Untracked ensures there is no tracking derivation while the given action runs.
/// This is useful in cases where no observers should be linked to a running (tracking) derivation.
T untracked<T>(T Function() fn, {ReactiveContext? context}) =>
    (context ?? mainContext).untracked(fn);

/// During a transaction, no derivations ([Reaction] or [Computed]) will be run
/// and will be deferred until the end of the transaction (batch). Transactions can
/// be nested, in which case, no derivation will be run until the top-most batch completes
T transaction<T>(T Function() fn, {ReactiveContext? context}) {
  final ctx =
      context ?? mainContext
        ..startBatch();
  try {
    return fn();
  } finally {
    ctx.endBatch();
  }
}
