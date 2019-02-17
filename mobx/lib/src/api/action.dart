import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

T runInAction<T>(T Function() fn, {String name, ReactiveContext context}) =>
    Action(fn, name: name, context: context)();

/// Untracked ensures there is no tracking derivation while the given action runs.
/// This is useful in cases where no observers should be linked to a running (tracking) derivation.
T untracked<T>(T Function() fn, {ReactiveContext context}) =>
    (context ?? mainContext).untracked(fn);

/// During a transaction, no derivations (Reaction or Computed<T>) will be run
/// and will be deferred until the end of the transaction (batch). Transactions can
/// be nested, in which case, no derivation will be run until the top-most batch completes
T transaction<T>(T Function() fn, {ReactiveContext context}) {
  final ctx = context ?? mainContext
    ..startBatch();
  try {
    return fn();
  } finally {
    ctx.endBatch();
  }
}
