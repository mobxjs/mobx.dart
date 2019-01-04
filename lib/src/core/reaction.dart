import 'package:mobx/src/core/atom_derivation.dart';

class Reaction implements Derivation {
  Reaction(onInvalidate, {this.name}) {
    _onInvalidate = onInvalidate;
  }

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
    ctx.startBatch();

    _isRunning = true;
    ctx.trackDerivation(this, fn);
    _isRunning = false;

    if (_isDisposed) {
      ctx.clearObservables(this);
    }

    ctx.endBatch();
  }

  void run() {
    if (_isDisposed) {
      return;
    }

    ctx.startBatch();

    _isScheduled = false;

    if (ctx.shouldCompute(this)) {
      _onInvalidate();
    }

    ctx.endBatch();
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    if (_isRunning) {
      return;
    }

    ctx
      ..startBatch()
      ..clearObservables(this)
      ..endBatch();
  }

  void schedule() {
    if (_isScheduled) {
      return;
    }

    _isScheduled = true;
    ctx
      ..addPendingReaction(this)
      ..runReactions();
  }

  @override
  void suspend() {
    // Not applicable right now
  }
}
