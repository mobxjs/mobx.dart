import 'package:mobx/mobx.dart';
import 'package:mobx/src/core/action.dart';
import 'package:mobx/src/core/atom_derivation.dart';

class ComputedValue<T> extends Atom implements Derivation {
  ComputedValue(T Function() fn, {String name}) : super(name) {
    this.name = name ?? 'Computed@${ctx.nextId}';
    _fn = fn;
  }

  @override
  Set<Atom> observables = Set();

  @override
  Set<Atom> newObservables;

  T Function() _fn;

  @override
  DerivationState dependenciesState = DerivationState.notTracking;

  T _value;

  bool _isComputing = false;

  T get value {
    if (_isComputing) {
      throw MobXException('Cycle detected in computation $name: $_fn');
    }

    if (!ctx.isInBatch() && observers.isEmpty) {
      if (ctx.shouldCompute(this)) {
        ctx.startBatch();
        _value = computeValue(track: false);
        ctx.endBatch();
      }
    } else {
      reportObserved();
      if (ctx.shouldCompute(this)) {
        if (_trackAndCompute()) {
          ctx.propagateChangeConfirmed(this);
        }
      }
    }

    return _value;
  }

  T computeValue({bool track}) {
    _isComputing = true;

    T value;
    if (track) {
      value = ctx.trackDerivation(this, _fn);
    } else {
      value = _fn();
    }

    _isComputing = false;

    return value;
  }

  @override
  void suspend() {
    ctx.clearObservables(this);
    _value = null;
  }

  @override
  void onBecomeStale() {
    ctx.propagatePossiblyChanged(this);
  }

  bool _trackAndCompute() {
    final oldValue = _value;
    final wasSuspended = dependenciesState == DerivationState.notTracking;

    final newValue = computeValue(track: true);

    final changed = wasSuspended || !_isEqual(oldValue, newValue);

    if (changed) {
      _value = newValue;
    }

    return changed;
  }

  bool _isEqual(T x, T y) => x == y;

  Function observe(void Function(ChangeNotification<T>) handler,
      {bool fireImmediately}) {
    var firstTime = true;
    T prevValue;

    return autorun((_) {
      final newValue = value;
      if (firstTime == true || fireImmediately == true) {
        untracked(() {
          handler(ChangeNotification(
              type: 'update',
              object: this,
              oldValue: prevValue,
              newValue: newValue));
        });
      }

      firstTime = false;
      prevValue = newValue;
    });
  }
}
