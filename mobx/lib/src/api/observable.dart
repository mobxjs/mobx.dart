import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

/// Creates a computed value with an optional [name].
///
/// The passed in function: [fn], is used to give back the computed value.
/// Computed values can depend on other observables and computed values!
/// This makes them both an *observable* and an *observer*.
/// Computed values are also referred to as _derived-values_ because they inherently _derive_ their
/// value from other observables. Don't underestimate the power of the **computed**.
/// They are possibly the most powerful observables in your application.
///
/// A computed's value is read with the `value` property.
///
/// ```
/// var x = Observable(10);
/// var y = Observable(10);
/// var total = computed((){
///   return x.value + y.value;
/// });
///
/// x.value = 100; // recomputes total
/// y.value = 100; // recomputes total again
///
/// print('total = ${total.value}'); // prints "total = 200"
/// ```
///
/// A computed value is _cached_ and it recomputes only when the dependent observables actually
/// change. This makes them fast and you are free to use them throughout your application. Internally
/// MobX uses a 2-phase change propagation that ensures no unnecessary computations are performed.
ComputedValue<T> computed<T>(T Function() fn,
        {String name, ReactiveContext context}) =>
    ComputedValue(context ?? mainContext, fn, name: name);

/// Creates a simple Atom for tracking its usage in a reactive context. This is useful when
/// you don't need the value but instead a way of knowing when it becomes active and inactive
/// in a reaction.
///
/// Use the [onObserved] and [onUnobserved] handlers to know when the atom is active and inactive
/// respectively. Use a debug [name] to identify easily.
Atom createAtom(
        {String name,
        Function onObserved,
        Function onUnobserved,
        ReactiveContext context}) =>
    Atom(context ?? mainContext,
        name: name, onObserve: onObserved, onUnobserve: onUnobserved);
