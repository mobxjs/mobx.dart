import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

/// Create an observable value with an [initialValue] and an optional [name]
///
/// Observable values are tracked inside MobX. When a reaction uses them
/// they are implicitly added as a dependency of the reaction. When its value changes
/// the linked reaction is re-triggered.
///
/// An observable's value is read with the `value` property.
///
/// ```
/// var x = observable(10);
/// var message = observable('hello');
///
/// print('x = ${x.value}'); // read an observable's value
/// ```
ObservableValue<T> observable<T>(T initialValue,
        {String name, ReactiveContext context}) =>
    ObservableValue(context ?? currentContext, initialValue, name: name);

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
/// var x = observable(10);
/// var y = observable(10);
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
    ComputedValue(context ?? currentContext, fn, name: name);

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
    Atom(context ?? currentContext,
        name: name, onObserve: onObserved, onUnobserve: onUnobserved);
