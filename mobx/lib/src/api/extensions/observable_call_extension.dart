part of '../extensions.dart';

extension ObservableExtension<T> on Observable<T> {
  T call([T? newValue]) {
    if (newValue == null) return value;

    runInAction(() => value = newValue);
    return value;
  }
}
