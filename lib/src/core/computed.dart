import 'package:mobx/mobx.dart';
import 'package:mobx/src/core/atom.dart';
import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/core/derivation.dart';

class ComputedValue<T> extends Atom implements Derivation {
  ComputedValue(this._context, this._fn, {String name})
      : super(_context, name: name ?? _context.name('Computed'));

  final ReactiveContext _context;

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

    if (!_context.isInBatch() && observers.isEmpty) {
      if (_context.shouldCompute(this)) {
        _context.startBatch();
        _value = computeValue(track: false);
        _context.endBatch();
      }
    } else {
      reportObserved();
      if (_context.shouldCompute(this)) {
        if (_trackAndCompute()) {
          _context.propagateChangeConfirmed(this);
        }
      }
    }

    return _value;
  }

  T computeValue({bool track}) {
    _isComputing = true;

    T value;
    if (track) {
      value = _context.trackDerivation(this, _fn);
    } else {
      value = _fn();
    }

    _isComputing = false;

    return value;
  }

  @override
  void suspend() {
    _context.clearObservables(this);
    _value = null;
  }

  @override
  void onBecomeStale() {
    _context.propagatePossiblyChanged(this);
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
        _context.untracked(() {
          handler(ChangeNotification(
              type: OperationType.update,
              object: this,
              oldValue: prevValue,
              newValue: newValue));
        });
      }

      firstTime = false;
      prevValue = newValue;
    }, context: _context);
  }
}
