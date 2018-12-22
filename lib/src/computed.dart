import 'package:mobx/src/global_state.dart';
import 'package:mobx/src/observable.dart';
import 'package:mobx/src/reaction.dart';

class ComputedValue<T> extends Atom implements Derivation {
  @override
  Set<Atom> observables = Set();

  @override
  Set<Atom> newObservables;

  T _value;

  @override
  T Function() _fn;

  ComputedValue(
    String name,
    this._fn,
  ) : super(name);

  T get value {
    global.startBatch();
    computeValue(true);
    global.endBatch();

    reportObserved();
    return _value;
  }

  computeValue(bool track) {
    if (track) {
      global.trackDerivation(this);
    } else {
      onBecomeStale();
    }
  }

  @override
  void onBecomeStale() {
    _value = _fn();
  }
}
