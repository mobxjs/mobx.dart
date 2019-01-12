import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

/// Creates an action that encapsulates all the mutations happening on the
/// observables.
///
/// Wrapping mutations inside an action ensures the depending observers
/// are only notified when the action completes. This is useful to silent the notifications
/// when several observables are being changed together. You will want to run your
/// reactions only when all the mutations complete. This also helps in keeping
/// the state of your application consistent.
///
/// You can give a debug-friendly [name] to identify the action.
///
/// ```
/// var x = observable(10);
/// var y = observable(20);
/// var total = observable(0);
///
/// autorun((){
///   print('x = ${x}, y = ${y}, total = ${total}');
/// });
///
/// var totalUp = action((){
///   x.value++;
///   y.value++;
///
///   total.value = x.value + y.value;
/// }, name: 'adder');
/// ```
/// Even though we are changing 3 observables (`x`, `y` and `total`), the [autorun()]
/// is only executed once. This is the benefit of action. It batches up all the change
/// notifications and propagates them only after the completion of the action. Actions
/// can also be nested inside, in which case the change notification will propagate when
/// the top-level action completes.
Action action(Function fn, {String name, ReactiveContext context}) =>
    Action(context ?? mainContext, fn, name: name);

Action runInAction(Function fn, {String name, ReactiveContext context}) =>
    Action(context ?? mainContext, fn, name: name)();

/// Untracked ensures there is no tracking derivation while the given action runs.
/// This is useful in cases where no observers should be linked to a running (tracking) derivation.
T untracked<T>(T Function() action, {ReactiveContext context}) =>
    (context ?? mainContext).untracked(action);

/// During a transaction, no derivations (Reaction or ComputedValue<T>) will be run
/// and will be deferred until the end of the transaction (batch). Transactions can
/// be nested, in which case, no derivation will be run until the top-most batch completes
T transaction<T>(T Function() action, {ReactiveContext context}) {
  final ctx = context ?? mainContext
    ..startBatch();
  try {
    return action();
  } finally {
    ctx.endBatch();
  }
}
