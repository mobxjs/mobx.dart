part of '../core.dart';

abstract class Reaction implements Derivation {
  bool get isDisposed;

  void dispose();

  void _run();

  StackTrace? get debugCreationStack;
}

class ReactionImpl with DebugCreationStack implements Reaction {
  ReactionImpl(
    this._context,
    Function() onInvalidate, {
    required this.name,
    void Function(Object, Reaction)? onError,
  }) {
    _onInvalidate = onInvalidate;
    _onError = onError;
  }

  void Function(Object, ReactionImpl)? _onError;

  final ReactiveContext _context;
  late void Function() _onInvalidate;
  Timer? _timer;

  void _setTimer(Timer timer) {
    if (_isDisposed) {
      timer.cancel();
    } else {
      _timer = timer;
    }
  }

  bool _isScheduled = false;
  bool _isDisposed = false;
  bool _isRunning = false;

  @override
  final String name;

  @override
  Set<Atom>? _newObservables;

  @override
  int _trackingId = 0;

  @override
  int _trackingIndex = 0;

  @override
  // ignore: prefer_final_fields
  List<Atom> _observables = const [];

  bool get hasObservables => _observables.isNotEmpty;

  @override
  // ignore: prefer_final_fields
  DerivationState _dependenciesState = DerivationState.notTracking;

  @override
  MobXCaughtException? _errorValue;

  @override
  MobXCaughtException? get errorValue => _errorValue;

  @override
  bool get isDisposed => _isDisposed;

  @override
  void _onBecomeStale() {
    schedule();
  }

  Derivation? startTracking() {
    _context.startBatch();
    _isRunning = true;
    return _context._startTracking(this);
  }

  void endTracking(Derivation? previous) {
    _context._endTracking(this, previous);
    _isRunning = false;

    if (_isDisposed) {
      _context.clearObservables(this);
    }

    _context.endBatch();
  }

  void track(void Function() fn) {
    _context.startBatch();

    final notify = _context.isSpyEnabled;
    DateTime? startTime;
    if (notify) {
      startTime = DateTime.now();
      _context.spyReport(ReactionSpyEvent(name: name));
    }

    _isRunning = true;
    try {
      _context.trackDerivation(this, fn);
      if (_context._hasCaughtException(this)) {
        _reportException(_errorValue!, _errorValue!.stackTrace);
      }
      if (notify) {
        _context.spyReport(
          EndedSpyEvent(
            type: 'reaction',
            name: name,
            duration: DateTime.now().difference(startTime!),
          ),
        );
      }
    } finally {
      _isRunning = false;
      if (_isDisposed) _context.clearObservables(this);
      _context.endBatch();
    }
  }

  @override
  void _run() {
    if (_isDisposed) {
      return;
    }

    _context.startBatch();

    _isScheduled = false;

    try {
      if (_context._shouldCompute(this)) {
        _onInvalidate();
      }
    } on Object catch (e, s) {
      _errorValue = MobXCaughtException(e, stackTrace: s);
      _reportException(_errorValue!, s);
    } finally {
      _context.endBatch();
    }
  }

  @override
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _timer?.cancel();
    _timer = null;

    if (_isRunning) {
      return;
    }

    _context.spyReport(ReactionDisposedSpyEvent(name: name));

    // ignore: cascade_invocations
    _context
      ..startBatch()
      ..clearObservables(this)
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
  // ignore: unused_element
  void _suspend() {
    // Not applicable right now
  }

  void _reportException(Object exception, StackTrace? stackTrace) {
    if (_onError != null) {
      _onError!(exception, this);
      return;
    }

    if (_context.config.disableErrorBoundaries == true) {
      if (stackTrace != null) {
        Error.throwWithStackTrace(exception, stackTrace);
      } else {
        throw exception;
      }
    }

    if (_context.isSpyEnabled) {
      _context.spyReport(ReactionErrorSpyEvent(exception, name: name));
    }

    _context._notifyReactionErrorHandlers(exception, this);
  }

  @override
  String toString() =>
      'Reaction(name: $name, identity: ${identityHashCode(this)})';
}
