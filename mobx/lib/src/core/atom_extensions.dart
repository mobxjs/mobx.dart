import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

extension AtomSpyReporter on Atom {
  void reportRead() {
    context.enforceReadPolicy(this);
    reportObserved();
  }

  void reportWrite<T>(T newValue, T oldValue, void Function() setNewValue,
      {EqualityComparer<T>? equals}) {
    final areEqual = equals == null
        ? _equals(oldValue, newValue)
        : equals(oldValue, newValue);

    // Avoid unnecessary observable notifications of @observable fields of Stores
    if (areEqual) {
      return;
    }

    context.spyReport(ObservableValueSpyEvent(this,
        newValue: newValue, oldValue: oldValue, name: name));

    final actionName = context.isSpyEnabled ? '${name}_set' : name;

    // ignore: cascade_invocations
    context.conditionallyRunInAction(() {
      setNewValue();
      reportChanged();
    }, this, name: actionName);

    // ignore: cascade_invocations
    context.spyReport(EndedSpyEvent(type: 'observable', name: name));
  }
}

/// Determines whether [a] and [b] are equal.
bool _equals<T>(T a, T b) {
  if (identical(a, b)) return true;
  if (a is Iterable || a is Map) {
    if (!_equality.equals(a, b)) return false;
  } else if (a.runtimeType != b.runtimeType) {
    return false;
  } else if (a != b) {
    return false;
  }

  return true;
}

const DeepCollectionEquality _equality = DeepCollectionEquality();
