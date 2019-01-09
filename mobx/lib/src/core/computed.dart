part of '../core.dart';

class ComputedValue<T> extends Atom implements Derivation {
  ComputedValue(ReactiveContext context, this._fn, {String name})
      : super(context, name: name ?? context.nameFor('Computed'));

  @override
  MobXCaughtException _errorValue;

  @override
  MobXCaughtException get errorValue => _errorValue;

  @override
  // ignore: prefer_final_fields
  Set<Atom> _observables = Set();

  @override
  Set<Atom> _newObservables;

  T Function() _fn;

  @override
  // ignore: prefer_final_fields
  DerivationState _dependenciesState = DerivationState.notTracking;

  T _value;

  bool _isComputing = false;

  T get value {
    if (_isComputing) {
      throw MobXException('Cycle detected in computation $name: $_fn');
    }

    if (!_context._isInBatch() && _observers.isEmpty) {
      if (_context._shouldCompute(this)) {
        _context.startBatch();
        _value = computeValue(track: false);
        _context.endBatch();
      }
    } else {
      reportObserved();
      if (_context._shouldCompute(this)) {
        if (_trackAndCompute()) {
          _context._propagateChangeConfirmed(this);
        }
      }
    }

    if (_context._isCaughtException(this)) {
      // ignore: only_throw_errors
      throw _errorValue._exception;
    }

    return _value;
  }

  T computeValue({bool track}) {
    _isComputing = true;

    T value;
    if (track) {
      value = _context.trackDerivation(this, _fn);
    } else {
      try {
        value = _fn();
        _errorValue = null;
      } on Object catch (e) {
        _errorValue = MobXCaughtException(e);
      }
    }

    _isComputing = false;

    return value;
  }

  @override
  void _suspend() {
    _context._clearObservables(this);
    _value = null;
  }

  @override
  void _onBecomeStale() {
    _context._propagatePossiblyChanged(this);
  }

  bool _trackAndCompute() {
    final oldValue = _value;
    final wasSuspended = _dependenciesState == DerivationState.notTracking;

    final newValue = computeValue(track: true);

    final changed = wasSuspended ||
        _context._isCaughtException(this) ||
        !_isEqual(oldValue, newValue);

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
