part of '../core.dart';

abstract class Reaction implements Derivation {
  bool get isDisposed;
  void dispose();

  void _run();
}

class ReactionImpl implements Reaction {
  ReactionImpl(this._context, Function() onInvalidate,
      {this.name, void Function(Object, Reaction) onError})
      : assert(_context != null),
        assert(onInvalidate != null) {
    _onInvalidate = onInvalidate;
    _onError = onError;
  }

  void Function(Object, ReactionImpl) _onError;

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

  @override
  bool get isDisposed => _isDisposed;

  @override
  void _onBecomeStale() {
    schedule();
  }

  @experimental
  Derivation startTracking() {
    _context.startBatch();
    _isRunning = true;
    return _context._startTracking(this);
  }

  @experimental
  void endTracking(Derivation previous) {
    _context._endTracking(this, previous);
    _isRunning = false;

    if (_isDisposed) {
      _context._clearObservables(this);
    }

    _context.endBatch();
  }

  void track(void Function() fn) {
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

  @override
  void _run() {
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

  @override
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

    if (_context.config.disableErrorBoundaries == true) {
      // ignore: only_throw_errors
      throw exception;
    }

    _context._notifyReactionErrorHandlers(exception, this);
  }
}
