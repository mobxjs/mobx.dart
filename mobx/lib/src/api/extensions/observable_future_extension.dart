part of '../extensions.dart';

/// Turn the Future into an ObservableFuture.
extension ObservableFutureExtension<T> on Future<T> {
  ObservableFuture<T> asObservable({ReactiveContext context}) {
    return ObservableFuture<T>(this, context: context);
  }
}
