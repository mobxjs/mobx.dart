import 'package:mobx/mobx.dart';

extension CodegenReporter on Atom {
  void reportRead() {
    context.enforceReadPolicy(this);
    reportObserved();
  }

  void reportWrite<T>(T newValue, T oldValue, void Function() setNewValue) {
    context.spyReport(ObservableValueSpyEvent(this,
        newValue: newValue, oldValue: oldValue, name: name, isStart: true));

    // ignore: cascade_invocations
    context.conditionallyRunInAction(() {
      setNewValue();
      reportChanged();

      context.spyReport(EndedSpyEvent());
    }, this, name: '${name}_set');
  }
}
