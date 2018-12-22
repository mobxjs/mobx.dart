import 'package:mobx/src/global_state.dart';
import 'package:mobx/src/observable.dart';

abstract class Derivation {
  String name;
  Set<Atom> observables;
  Set<Atom> newObservables;

  void onBecomeStale() {}
}

class Reaction implements Derivation {
  void Function() _onInvalidate;
  bool _isScheduled = false;

  @override
  String name;

  @override
  Set<Atom> newObservables;

  @override
  Set<Atom> observables;

  Reaction(onInvalidate, {String name}) {
    this.name = name ?? "Reaction@${global.nextId}";
    _onInvalidate = onInvalidate;
  }

  @override
  void onBecomeStale() {
    schedule();
  }

  run() {
    global.startBatch();
    _onInvalidate();
    global.endBatch();
  }

  dispose() {}

  schedule() {
    if (_isScheduled) {
      return;
    }

    _isScheduled = true;
    global.enqueueReaction(this);
    global.runReactions();
  }
}
