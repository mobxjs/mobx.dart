import 'package:mobx/mobx.dart';

extension AtomSpyReporter on Atom {
  void reportRead() {
    context.enforceReadPolicy(this);
    reportObserved();
  }

  void reportWrite<T>(T newValue, T oldValue, void Function() setNewValue) {
    context.spyReport(ObservableValueSpyEvent(this,
        newValue: newValue, oldValue: oldValue, name: name));

    // ignore: cascade_invocations
    context.conditionallyRunInAction(() {
      setNewValue();
      reportChanged();

      context.spyReport(EndedSpyEvent(name: 'observable ${name}'));
    }, this, name: '${name}_set');
  }
}
