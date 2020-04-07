part of '../extensions.dart';

/// Turn the Future into an ObservableFuture.
extension ObservableFutureExtension<T> on Future<T> {
  ObservableFuture<T> asObservable({ReactiveContext context, String name}) =>
      ObservableFuture<T>(this, context: context, name: name);
  /// Transform the future value into other type after complete future
  /// Useful to transform list to ObservableList in requests
  Future<E> map<E>(Future<E> Function(Future<T>) transform) => transform(this);
}
