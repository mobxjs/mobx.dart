part of '../extensions.dart';

/// Turn the List into an ObservableList.
extension ObservableListExtension<T> on List<T> {
  @Deprecated('Use toObs() instead')
  ObservableList<T> asObservable({ReactiveContext? context, String? name}) =>
      ObservableList<T>.of(this, context: context, name: name);

  ObservableList<T> toObs({ReactiveContext? context, String? name}) =>
      ObservableList<T>.of(this, context: context, name: name);
}
