/// Declares configuration of a Store class.
/// Currently the only configuration used is boolean to indicate generation of toString method (true), or not (false)

class StoreConfig {
  const StoreConfig({this.hasToString = true});
  final bool hasToString;
}

/// Internal class only used for code-generation with `mobx_codegen`.
///
/// During code-generation, this type is detected to identify an `Observable`
class MakeObservable {
  const MakeObservable._({this.readOnly = false});

  final bool readOnly;
}

/// Declares a class field as an observable. See the `Observable` class for full
/// documentation
const MakeObservable observable = MakeObservable._();

/// Declares a class field as an observable. See the `Observable` class for full
/// documentation.
///
/// But, it's only modifiable within the Store
const MakeObservable readonly = MakeObservable._(readOnly: true);

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
