import 'package:mobx/src/core/atom_derivation.dart';

class Reaction implements Derivation {
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
  DerivationState dependenciesState = DerivationState.NOT_TRACKING;

  get isDisposed => _isDisposed;

  Reaction(onInvalidate, {String this.name}) {
    _onInvalidate = onInvalidate;
  }

  @override
  void onBecomeStale() {
    schedule();
  }

  track(void Function() fn) {
    ctx.startBatch();

    _isRunning = true;
    ctx.trackDerivation(this, fn);
    _isRunning = false;

    if (_isDisposed) {
      ctx.clearObservables(this);
    }

    ctx.endBatch();
  }

  run() {
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

  dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    if (_isRunning) {
      return;
    }

    ctx.startBatch();
    ctx.clearObservables(this);
    ctx.endBatch();
  }

  schedule() {
    if (_isScheduled) {
      return;
    }

    _isScheduled = true;
    ctx.addPendingReaction(this);
    ctx.runReactions();
  }

  @override
  suspend() {
    // Not applicable right now
  }
}
