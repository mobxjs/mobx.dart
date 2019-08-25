class MakeStore {
  const MakeStore._();
}

/// Declares a class as a store.
const MakeStore store = MakeStore._();

class MakeObservable {
  const MakeObservable._();
}

/// Declares a class field as an observable. See the `Observable` class for full
/// documentation
const MakeObservable observable = MakeObservable._();

class MakePanoptic {
  const MakePanoptic._();
}

/// Declares a class field as an _actual_ observable.
///
/// Fields decorated with this annotation will report the details of the change,
/// not just that a change has occurred. See the `Observable` class for full
/// documentation
const MakePanoptic panoptic = MakePanoptic._();

class ComputedMethod {
  const ComputedMethod._();
}

/// Declares a method as a computed value. See the `Computed` class for full
/// documentation.
const ComputedMethod computed = ComputedMethod._();

class MakeAction {
  const MakeAction._();
}

/// Declares a method as an action. See the `Action` class for full
/// documentation.
const MakeAction action = MakeAction._();
