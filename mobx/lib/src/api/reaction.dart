import 'dart:async';

import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

/// Executes the specified [fn], whenever the dependent observables change. It returns
/// a disposer that can be used to dispose the autorun.
///
/// Optional configuration:
/// * [name]: debug name for this reaction
/// * [delay]: Number of milliseconds that can be used to throttle the effect function. If zero (default), no throttling happens.
/// * [context]: the [ReactiveContext] to use. By default the [mainContext] is used.
/// * [scheduler]: Set a custom scheduler to determine how re-running the autorun function should be scheduled. It takes a function that should be invoked at some point in the future.
/// * [onError]: By default, any exception thrown inside an reaction will be logged, but not further thrown. This is to make sure that an exception in one reaction does not prevent the scheduled execution of other, possibly unrelated reactions. This also allows reactions to recover from exceptions. Throwing an exception does not break the tracking done by MobX, so subsequent runs of the reaction might complete normally again if the cause for the exception is removed. This option allows overriding that behavior. It is possible to set a global error handler or to disable catching errors completely using [ReactiveConfig].
///
/// ```
/// var x = Observable(10);
/// var y = Observable(20);
/// var total = Observable(0);
///
/// var dispose = autorun((_){
///   print('x = ${x}, y = ${y}, total = ${total}');
/// });
///
/// x.value = 20; // will cause autorun() to re-trigger.
///
/// dispose(); // This disposes the autorun() and will not be triggered again
///
/// x.value = 30; // Will not cause autorun() to re-trigger as it's disposed.
/// ```
ReactionDisposer autorun(
  Function(Reaction) fn, {
  String? name,
  int? delay,
  ReactiveContext? context,
  Timer Function(void Function())? scheduler,
  void Function(Object, Reaction)? onError,
}) => createAutorun(
  context ?? mainContext,
  fn,
  name: name,
  delay: delay,
  scheduler: scheduler,
  onError: onError,
);

/// Executes the [fn] function and tracks the observables used in it. Returns
/// a function to dispose the reaction.
///
/// Optional configuration:
/// * [name]: debug name for this reaction
/// * [delay]: Number of milliseconds that can be used to throttle the effect function. If zero (default), no throttling happens.
/// * [context]: the [ReactiveContext] to use. By default the [mainContext] is used.
/// * [scheduler]: Set a custom scheduler to determine how re-running the autorun function should be scheduled. It takes a function that should be invoked at some point in the future.
/// * [onError]: By default, any exception thrown inside an reaction will be logged, but not further thrown. This is to make sure that an exception in one reaction does not prevent the scheduled execution of other, possibly unrelated reactions. This also allows reactions to recover from exceptions. Throwing an exception does not break the tracking done by MobX, so subsequent runs of the reaction might complete normally again if the cause for the exception is removed. This option allows overriding that behavior. It is possible to set a global error handler or to disable catching errors completely using [ReactiveConfig].
///
/// The [fn] is supposed to return a value of type T. When it changes, the
/// [effect] function is executed.
///
/// *Note*: Only the [fn] function is tracked and not the [effect].
///
/// You can also pass in an optional [name], a throttling [delay] in milliseconds. Use
/// [fireImmediately] if you want to invoke the effect immediately without waiting for
/// the [fn] to change its value. It is possible to define a custom [equals] function
/// to override the default comparison for the value returned by [fn], to have fined
/// grained control over when the reactions should run. By default, the [mainContext]
/// is used, but you can also pass in a custom [context].
/// You can also pass in an optional [onError] handler for errors thrown during the [fn] execution.
/// You can also pass in an optional [scheduler] to schedule the [effect] execution.
ReactionDisposer reaction<T>(
  T Function(Reaction) fn,
  void Function(T) effect, {
  String? name,
  int? delay,
  bool? fireImmediately,
  EqualityComparer<T>? equals,
  ReactiveContext? context,
  Timer Function(void Function())? scheduler,
  void Function(Object, Reaction)? onError,
}) => createReaction<T>(
  context ?? mainContext,
  fn,
  effect,
  name: name,
  delay: delay,
  equals: equals,
  fireImmediately: fireImmediately,
  onError: onError,
  scheduler: scheduler,
);

/// A one-time reaction that auto-disposes when the [predicate] becomes true. It also
/// executes the [effect] when the predicate turns true.
///
/// You can read it as: "*when* [predicate()] turns true, the [effect()] is executed."
///
/// Returns a function to dispose pre-maturely.
ReactionDisposer when(
  bool Function(Reaction) predicate,
  void Function() effect, {
  String? name,
  ReactiveContext? context,
  int? timeout,
  void Function(Object, Reaction)? onError,
}) => createWhenReaction(
  context ?? mainContext,
  predicate,
  effect,
  name: name,
  timeout: timeout,
  onError: onError,
);

/// A variant of [when()] which returns a Future. The Future completes when the [predicate()] turns true.
/// Note that there is no effect function here. Typically you would await on the Future and execute the
/// effect after that.
///
/// ```
/// await asyncWhen((_) => x.value > 10);
/// // ... execute the effect ...
/// ```
Future<void> asyncWhen(
  bool Function(Reaction) predicate, {
  String? name,
  int? timeout,
  ReactiveContext? context,
}) => createAsyncWhenReaction(
  context ?? mainContext,
  predicate,
  name: name,
  timeout: timeout,
);
