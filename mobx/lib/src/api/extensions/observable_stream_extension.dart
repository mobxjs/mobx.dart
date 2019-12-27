part of '../extensions.dart';

/// Turn the Stream into an ObservableStream.
extension ObservableStreamExtension<T> on Stream<T> {
  ObservableStream<T> asObservable(
          {T initalValue, bool cancelOnError, ReactiveContext context}) =>
      ObservableStream<T>(this,
          initialValue: initalValue,
          cancelOnError: cancelOnError,
          context: context);
}
