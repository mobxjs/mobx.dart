part of '../extensions.dart';

/// Turn the Set into an ObservableSet.
extension ObservableSetExtension<T> on Set<T> {
  @Deprecated('Use toObs() instead')
  ObservableSet<T> asObservable({ReactiveContext? context, String? name}) =>
      ObservableSet<T>.of(this, context: context, name: name);

  ObservableSet<T> toObs({ReactiveContext? context, String? name}) =>
      ObservableSet<T>.of(this, context: context, name: name);
}
