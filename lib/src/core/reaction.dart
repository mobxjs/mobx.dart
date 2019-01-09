part of '../core.dart';

class Reaction implements Derivation {
  Reaction(this._context, Function() onInvalidate,
      {this.name, void Function(Object, Reaction) onError}) {
    _onInvalidate = onInvalidate;
    _onError = onError;
  }

  void Function(Object, Reaction) _onError;

  final ReactiveContext _context;
  void Function() _onInvalidate;
  bool _isScheduled = false;
  bool _isDisposed = false;
  bool _isRunning = false;

  @override
  final String name;

  @override
  Set<Atom> _newObservables;

  @override
  // ignore: prefer_final_fields
  Set<Atom> _observables = Set();

  @override
  // ignore: prefer_final_fields
  DerivationState _dependenciesState = DerivationState.notTracking;

  @override
  MobXCaughtException _errorValue;

  @override
  MobXCaughtException get errorValue => _errorValue;

  bool get isDisposed => _isDisposed;

  @override
  void _onBecomeStale() {
    schedule();
  }

  @experimental
  Derivation _startTracking() {
    _context.startBatch();
    _isRunning = true;
    return _context._startTracking(this);
  }

  @experimental
  void _endTracking(Derivation previous) {
    _context._endTracking(this, previous);
    _isRunning = false;

    if (_isDisposed) {
      _context._clearObservables(this);
    }

    _context.endBatch();
  }

  void _track(void Function() fn) {
    _context.startBatch();

    _isRunning = true;
    _context.trackDerivation(this, fn);
    _isRunning = false;

    if (_isDisposed) {
      _context._clearObservables(this);
    }

    if (_context._isCaughtException(this)) {
      _reportException(_errorValue._exception);
    }

    _context.endBatch();
  }

  void run() {
    if (_isDisposed) {
      return;
    }

    _context.startBatch();

    _isScheduled = false;

    if (_context._shouldCompute(this)) {
      try {
        _onInvalidate();
      } on Object catch (e) {
        // Note: "on Object" accounts for both Error and Exception
        _errorValue = MobXCaughtException(e);
        _reportException(e);
      }
    }

    _context.endBatch();
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    if (_isRunning) {
      return;
    }

    _context
      ..startBatch()
      .._clearObservables(this)
      ..endBatch();
  }

  void schedule() {
    if (_isScheduled) {
      return;
    }

    _isScheduled = true;
    _context
      ..addPendingReaction(this)
      ..runReactions();
  }

  @override
  void _suspend() {
    // Not applicable right now
  }

  void _reportException(Object exception) {
    if (_onError != null) {
      _onError(exception, this);
      return;
    }
  }
}

/// Tracks changes that happen between [start] and [end].
///
/// This should only be used in situations where it is not possible to
/// track changes inside a callback function.
@experimental
class DerivationTracker {
  DerivationTracker(ReactiveContext context, Function() onInvalidate,
      {String name})
      : _reaction = Reaction(context, onInvalidate, name: name);

  final Reaction _reaction;
  Derivation _previousDerivation;

  void start() {
    if (_reaction._isRunning) {
      return;
    }
    _previousDerivation = _reaction._startTracking();
  }

  void end() {
    if (!_reaction._isRunning) {
      return;
    }
    _reaction._endTracking(_previousDerivation);
    _previousDerivation = null;
  }

  void dispose() {
    end();
    _reaction.dispose();
  }
}
