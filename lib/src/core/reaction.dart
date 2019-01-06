import 'package:mobx/src/core/atom.dart';
import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/core/derivation.dart';

class TrackingReaction extends Reaction {
  TrackingReaction(ReactiveContext context, Function() onInvalidate,
      {String name})
      : super(context, onInvalidate, name: name);

  Derivation startTracking() {
    _context.startBatch();
    _isRunning = true;
    return _context.startTracking(this);
  }

  void endTracking(Derivation previous) {
    _context.endTracking(this, previous);
    _isRunning = false;

    if (_isDisposed) {
      _context.clearObservables(this);
    }

    _context.endBatch();
  }
}

class Reaction implements Derivation {
  Reaction(this._context, Function() onInvalidate, {this.name}) {
    _onInvalidate = onInvalidate;
  }

  final ReactiveContext _context;
  void Function() _onInvalidate;
  bool _isScheduled = false;
  bool _isDisposed = false;
  bool _isRunning = false;

  @override
  String name;

  @override
  Set<Atom> newObservables;

  @override
  Set<Atom> observables = Set();

  @override
  DerivationState dependenciesState = DerivationState.notTracking;

  bool get isDisposed => _isDisposed;

  @override
  void onBecomeStale() {
    schedule();
  }

  void track(void Function() fn) {
    _context.startBatch();

    _isRunning = true;
    _context.trackDerivation(this, fn);
    _isRunning = false;

    if (_isDisposed) {
      _context.clearObservables(this);
    }

    _context.endBatch();
  }

  void run() {
    if (_isDisposed) {
      return;
    }

    _context.startBatch();

    _isScheduled = false;

    if (_context.shouldCompute(this)) {
      _onInvalidate();
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
  void suspend() {
    // Not applicable right now
  }
}
