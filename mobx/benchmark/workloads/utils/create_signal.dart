import '../reactive_framework.dart';

final class _Signal<T> implements Signal<T> {
  const _Signal(this.getter, this.setter);

  final T Function() getter;
  final void Function(T _) setter;

  @override
  T read() => getter();

  @override
  void write(T value) => setter(value);
}

Signal<T> createSignal<T>(T Function() getter, void Function(T) setter) {
  return _Signal(getter, setter);
}
