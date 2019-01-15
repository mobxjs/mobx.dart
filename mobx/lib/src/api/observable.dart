import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/core.dart';

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
