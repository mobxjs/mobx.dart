import 'package:mobx/mobx.dart';

import '../utils.dart';

extension AtomSpyReporter on Atom {
  void reportRead() {
    context.enforceReadPolicy(this);
    reportObserved();
  }

  void reportWrite<T>(
    T newValue,
    T oldValue,
    void Function() setNewValue, {
    EqualityComparer<T>? equals,
    bool? useDeepEquality,
  }) {
    final areEqual =
        equals ??
        (a, b) => equatable(a, b, useDeepEquality: useDeepEquality ?? false);

    // Avoid unnecessary observable notifications of @observable fields of Stores
    if (areEqual(newValue, oldValue)) {
      return;
    }

    context.spyReport(
      ObservableValueSpyEvent(
        this,
        newValue: newValue,
        oldValue: oldValue,
        name: name,
      ),
    );

    final actionName = context.isSpyEnabled ? '${name}_set' : name;

    // ignore: cascade_invocations
    context.conditionallyRunInAction(
      () {
        setNewValue();
        reportChanged();
      },
      this,
      name: actionName,
    );

    // ignore: cascade_invocations
    context.spyReport(EndedSpyEvent(type: 'observable', name: name));
  }
}
