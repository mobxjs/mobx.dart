import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

/// Executes the specified [fn], whenever the dependent observables change. It returns
/// a disposer that can be used to dispose the autorun.
///
/// Optional configuration:
/// * [name]: debug name for this reaction
/// * [delay]: debouncing delay in milliseconds
///
/// ```
/// var x = Observable(10);
/// var y = Observable(20);
/// var total = Observable(0);
///
/// var dispose = autorun((){
///   print('x = ${x}, y = ${y}, total = ${total}');
/// });
///
/// x.value = 20; // will cause autorun() to re-trigger.
///
/// dispose(); // This disposes the autorun() and will not be triggered again
///
/// x.value = 30; // Will not cause autorun() to re-trigger as it's disposed.
/// ```
ReactionDisposer autorun(Function(Reaction) fn,
        {String name,
        int delay,
        ReactiveContext context,
        void Function(Object, Reaction) onError}) =>
    createAutorun(context ?? mainContext, fn,
        name: name, delay: delay, onError: onError);

/// Executes the [predicate] function and tracks the observables used in it. Returns
/// a function to dispose the reaction.
///
/// The [predicate] is supposed to return a value of type T. When it changes, the
/// [effect] function is executed.
///
/// *Note*: Only the [predicate] function is tracked and not the [effect].
///
/// You can also pass in an optional [name], a debouncing [delay] in milliseconds. Use
/// [fireImmediately] if you want to invoke the effect immediately without waiting for
/// the [predicate] to change its value.
ReactionDisposer reaction<T>(
        T Function(Reaction) predicate, void Function(T) effect,
        {String name,
        int delay,
        bool fireImmediately,
        ReactiveContext context,
        void Function(Object, Reaction) onError}) =>
    createReaction(context ?? mainContext, predicate, effect,
        name: name,
        delay: delay,
        fireImmediately: fireImmediately,
        onError: onError);

/// A one-time reaction that auto-disposes when the [predicate] becomes true. It also
/// executes the [effect] when the predicate turns true.
///
/// You can read it as: "*when* [predicate()] turns true, the [effect()] is executed."
///
/// Returns a function to dispose pre-maturely.
ReactionDisposer when(bool Function(Reaction) predicate, void Function() effect,
        {String name,
        ReactiveContext context,
        int timeout,
        void Function(Object, Reaction) onError}) =>
    createWhenReaction(context ?? mainContext, predicate, effect,
        name: name, timeout: timeout, onError: onError);

/// A variant of [when()] which returns a Future. The Future completes when the [predicate()] turns true.
/// Note that there is no effect function here. Typically you would await on the Future and execute the
/// effect after that.
///
/// ```
/// await asyncWhen(() => x.value > 10);
/// // ... execute the effect ...
/// ```
Future<void> asyncWhen(bool Function(Reaction) predicate,
        {String name, int timeout, ReactiveContext context}) =>
    createAsyncWhenReaction(context ?? mainContext, predicate,
        name: name, timeout: timeout);
