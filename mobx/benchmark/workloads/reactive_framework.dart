abstract interface class ISignal<T> {
  T read();
}

abstract interface class Signal<T> implements ISignal<T> {
  void write(T value);
}

abstract interface class Computed<T> implements ISignal<T> {}

abstract class ReactiveFramework {
  const ReactiveFramework(this.name);

  final String name;

  Signal<T> signal<T>(T value);
  Computed<T> computed<T>(T Function() fn);
  void effect(void Function() fn);
  void withBatch<T>(T Function() fn);
  T withBuild<T>(T Function() fn);
}
