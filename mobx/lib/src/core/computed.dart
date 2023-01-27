part of '../core.dart';

class Computed<T> extends Atom implements Derivation, ObservableValue<T> {
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
  /// It is possible to override equality comparison (when deciding whether to notify observers)
  /// by providing an [equals] comparator.
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
  factory Computed(T Function() fn,
          {String? name,
          ReactiveContext? context,
          EqualityComparer<T>? equals}) =>
      Computed._(context ?? mainContext, fn, name: name, equals: equals);

  Computed._(ReactiveContext context, this._fn, {String? name, this.equals})
      : super._(context, name: name ?? context.nameFor('Computed'));

  final EqualityComparer<T>? equals;

  @override
  MobXCaughtException? _errorValue;

  @override
  MobXCaughtException? get errorValue => _errorValue;

  @override
  // ignore: prefer_final_fields
  Set<Atom> _observables = {};

  @override
  Set<Atom>? _newObservables;

  T Function() _fn;

  @override
  // ignore: prefer_final_fields
  DerivationState _dependenciesState = DerivationState.notTracking;

  T? _value;

  bool _isComputing = false;

  @override
  T get value {
    if (_isComputing) {
      throw MobXCyclicReactionException(
          'Cycle detected in computation $name: $_fn');
    }

    if (!_context.isWithinBatch && _observers.isEmpty) {
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

    if (_context._hasCaughtException(this)) {
      throw _errorValue!;
    }

    return _value as T;
  }

  T? computeValue({required bool track}) {
    _isComputing = true;
    _context.pushComputation();

    T? value;
    if (track) {
      value = _context.trackDerivation(this, _fn);
    } else {
      if (_context.config.disableErrorBoundaries == true) {
        value = _fn();
      } else {
        try {
          value = _fn();
          _errorValue = null;
        } on Object catch (e, s) {
          _errorValue = MobXCaughtException(e, stackTrace: s);
        }
      }
    }

    _context.popComputation();
    _isComputing = false;

    return value;
  }

  @override
  void _suspend() {
    _context.clearObservables(this);
    _value = null;
  }

  @override
  void _onBecomeStale() {
    _context._propagatePossiblyChanged(this);
  }

  bool _trackAndCompute() {
    if (_context.isSpyEnabled) {
      _context.spyReport(ComputedValueSpyEvent(this, name: name));
    }

    final oldValue = _value;
    final wasSuspended = _dependenciesState == DerivationState.notTracking;
    final hadCaughtException = _context._hasCaughtException(this);

    final newValue = computeValue(track: true);

    final changedException =
        hadCaughtException != _context._hasCaughtException(this);
    final changed =
        wasSuspended || changedException || !_isEqual(oldValue, newValue);

    if (changed) {
      _value = newValue;
    }

    return changed;
  }

  bool _isEqual(T? x, T? y) => equals == null ? x == y : equals!(x, y);

  void Function() observe(
      void Function(ChangeNotification<T>) handler,
      {@Deprecated('fireImmediately has no effect anymore. It is on by default.')
          bool? fireImmediately}) {
    T? prevValue;

    void notifyChange() {
      _context.untracked(() {
        handler(ChangeNotification(
            type: OperationType.update,
            object: this,
            oldValue: prevValue,
            newValue: value));
      });
    }

    return autorun((_) {
      final newValue = value;

      notifyChange();

      prevValue = newValue;
    }, context: _context)
        .call;
  }

  @override
  String toString() =>
      'Computed<$T>(name: $name, identity: ${identityHashCode(this)})';
}
