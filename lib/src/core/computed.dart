import 'package:mobx/src/core/global_state.dart';
import 'package:mobx/src/core/observable.dart';
import 'package:mobx/src/core/reaction.dart';

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
      _value = global.trackDerivation(this, this._fn);
    } else {
      onBecomeStale();
    }
  }

  @override
  void onBecomeStale() {
    _value = _fn();
  }
}
