part of '../extensions.dart';

/// Turn the Future into an ObservableFuture.
extension ObservableFutureExtension<T> on Future<T> {
  @Deprecated('Use toObs() instead')
  ObservableFuture<T> asObservable({ReactiveContext? context, String? name}) =>
      ObservableFuture<T>(this, context: context, name: name);

  ObservableFuture<T> toObs({ReactiveContext? context, String? name}) =>
      ObservableFuture<T>(this, context: context, name: name);
}
