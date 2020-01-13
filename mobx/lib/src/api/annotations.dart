/// Internal class only used for code-generation with `mobx_codegen`.
///
/// During code-generation, this type is detected to identify Store class with generated toString() method
class MakeToString {
//  unnamed constructor to allow parameters in Store annotation and prevent useless code refactoring for mobx users
  const MakeToString._();
}

/// Declares the annotation identifier to generate toString() on observables and computeds.
const MakeToString toString = MakeToString._();

/// Internal class only used for code-generation with `mobx_codegen`.
///
/// During code-generation, this type is detected to identify an `Observable`
class MakeObservable {
  const MakeObservable._();
}

/// Declares a class field as an observable. See the `Observable` class for full
/// documentation
const MakeObservable observable = MakeObservable._();

/// Internal class only used for code-generation with `mobx_codegen`.
///
/// During code-generation, this type is detected to identify a `Computed`
class ComputedMethod {
  const ComputedMethod._();
}

/// Declares a method as a computed value. See the `Computed` class for full
/// documentation.
const ComputedMethod computed = ComputedMethod._();

/// Internal class only used for code-generation with `mobx_codegen`.
///
/// During code-generation, this type is detected to identify an `Action`
class MakeAction {
  const MakeAction._();
}

/// Declares a method as an action. See the `Action` class for full
/// documentation.
const MakeAction action = MakeAction._();
