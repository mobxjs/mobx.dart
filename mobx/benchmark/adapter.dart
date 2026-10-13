import 'package:mobx/mobx.dart' as mobx;

import 'workloads/reactive_framework.dart';
import 'workloads/utils/create_computed.dart';
import 'workloads/utils/create_signal.dart';

/// Uses this package's implementation, without pub resolution of another MobX.
class MobxFramework extends ReactiveFramework {
  MobxFramework() : super('mobx');

  final _disposers = <mobx.ReactionDisposer>[];

  @override
  Computed<T> computed<T>(T Function() fn) {
    final value = mobx.Computed(fn);
    return createComputed(() => value.value);
  }

  @override
  Signal<T> signal<T>(T value) {
    final observable = mobx.Observable(value);
    return createSignal(
      () => observable.value,
      (value) => observable.value = value,
    );
  }

  @override
  void effect(void Function() fn) => _disposers.add(mobx.autorun((_) => fn()));

  @override
  void withBatch<T>(T Function() fn) => mobx.runInAction(fn);

  @override
  T withBuild<T>(T Function() fn) => fn();

  void dispose() {
    for (final dispose in _disposers.reversed) {
      dispose();
    }
    _disposers.clear();
  }
}
