part of '../core.dart';

class Computed<T> extends Atom implements Derivation {
  /// Creates a computed value with an optional [name].
  ///
  /// The passed in function: [fn], is used to give back the computed value.
  /// Computed values can depend on other observables and computed values!
  /// This makes them both an *observable* and an *observer*.
  /// Computed values are also referred to as _derived-values_ because they inherently _derive_ their
  /// value from other observables. Don't underestimate the power of the **computed**.
  /// They are possibly the most powerful observables in your application.
  ///
  /// A computed's value is read with the `value` property.
  ///
  /// ```
  /// var x = Observable(10);
  /// var y = Observable(10);
  /// var total = Computed((){
  ///   return x.value + y.value;
  /// });
  ///
  /// x.value = 100; // recomputes total
  /// y.value = 100; // recomputes total again
  ///
  /// print('total = ${total.value}'); // prints "total = 200"
  /// ```
  ///
  /// A computed value is _cached_ and it recomputes only when the dependent observables actually
  /// change. This makes them fast and you are free to use them throughout your application. Internally
  /// MobX uses a 2-phase change propagation that ensures no unnecessary computations are performed.
  factory Computed(T Function() fn, {String name, ReactiveContext context}) =>
      Computed._(context ?? mainContext, fn, name: name);

  Computed._(ReactiveContext context, this._fn, {String name})
      : super._(context, name: name ?? context.nameFor('Computed'));

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
      throw _errorValue;
    }

    return _value;
  }

  T computeValue({bool track}) {
    _isComputing = true;
    _context._pushComputation();

    T value;
    if (track) {
      value = _context.trackDerivation(this, _fn);
    } else {
      if (_context.config.disableErrorBoundaries == true) {
        value = _fn();
      } else {
        try {
          value = _fn();
          _errorValue = null;
        } on Object catch (e) {
          _errorValue = MobXCaughtException(e);
        }
      }
    }

    _context._popComputation();
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
