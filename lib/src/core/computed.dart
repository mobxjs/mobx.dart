import 'package:mobx/src/core/base_types.dart';
import 'package:mobx/src/utils.dart';

class ComputedValue<T> extends Atom implements Derivation {
  @override
  Set<Atom> observables = Set();

  @override
  Set<Atom> newObservables;

  @override
  T Function() _fn;

  @override
  DerivationState dependenciesState = DerivationState.NOT_TRACKING;

  @override
  bool get isAComputedValue => true;

  T _value;

  bool _isComputing = false;

  ComputedValue(
    String name,
    this._fn,
  ) : super(name);

  T get value {
    if (_isComputing) {
      fail('Cycle detected in computation ${name}: ${_fn}');
    }

    if (!global.isInBatch() && observers.isEmpty) {
      if (global.shouldCompute(this)) {
        global.startBatch();
        _value = computeValue(false);
        global.endBatch();
      }
    } else {
      reportObserved();
      if (global.shouldCompute(this)) {
        if (_trackAndCompute()) {
          global.propagateChangeConfirmed(this);
        }
      }
    }

    return _value;
  }

  T computeValue(bool track) {
    _isComputing = true;
    global.computationDepth++;

    T value;
    if (track) {
      value = global.trackDerivation(this, this._fn);
    } else {
      value = _fn();
    }

    global.computationDepth--;
    _isComputing = false;

    return value;
  }

  @override
  suspend() {
    global.clearObservables(this);
    _value = null;
  }

  @override
  void onBecomeStale() {
    global.propagatePossiblyChanged(this);
  }

  bool _trackAndCompute() {
    var oldValue = _value;
    var wasSuspended = dependenciesState == DerivationState.NOT_TRACKING;

    var newValue = computeValue(true);

    var changed = wasSuspended || !_isEqual(oldValue, newValue);

    if (changed) {
      _value = newValue;
    }

    return changed;
  }

  bool _isEqual(T x, T y) {
    return x == y;
  }
}
