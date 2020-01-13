part of '../extensions.dart';

/// Turn the Stream into an ObservableStream.
extension ObservableStreamExtension<T> on Stream<T> {
  ObservableStream<T> asObservable(
          {T initialValue, bool cancelOnError, ReactiveContext context}) =>
      ObservableStream<T>(this,
          initialValue: initialValue,
          cancelOnError: cancelOnError,
          context: context);
}
