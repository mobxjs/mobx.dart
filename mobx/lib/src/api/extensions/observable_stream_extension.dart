part of '../extensions.dart';

/// Turn the Stream into an ObservableStream.
extension ObservableStreamExtension<T> on Stream<T> {
  @Deprecated('Use toObs() instead')  
  ObservableStream<T> asObservable(
          {T? initialValue,
          bool cancelOnError = false,
          ReactiveContext? context,
          String? name}) =>
      ObservableStream<T>(this,
          initialValue: initialValue,
          cancelOnError: cancelOnError,
          context: context,
          name: name);

  ObservableStream<T> toObs(
          {T? initialValue,
          bool cancelOnError = false,
          ReactiveContext? context,
          String? name}) =>
      ObservableStream<T>(this,
          initialValue: initialValue,
          cancelOnError: cancelOnError,
          context: context,
          name: name);
}
