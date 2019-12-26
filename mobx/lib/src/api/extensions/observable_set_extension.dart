part of '../extensions.dart';

/// Turn the Set into an ObservableSet.
extension ObservableSetExtension<T> on Set<T> {
  ObservableSet<T> asObservable() {
    return ObservableSet<T>.of(this);
  }
}
