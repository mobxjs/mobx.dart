import '../reactive_framework.dart';

final class _Computed<T> implements Computed<T> {
  const _Computed(this.getter);

  final T Function() getter;

  @override
  T read() => getter();
}

Computed<T> createComputed<T>(T Function() fn) {
  return _Computed(fn);
}
