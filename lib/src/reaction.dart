import 'package:mobx/mobx.dart';
import 'package:mobx/src/global_state.dart';

abstract class Derivation {
  String name;
  Set<Atom> observing;
  Set<Atom> newObserving;

  void execute() {}
}

class Reaction implements Derivation {
  void Function() _onInvalidate;

  @override
  String name;

  @override
  Set<Atom> newObserving;

  @override
  Set<Atom> observing;

  Reaction(this.name, this._onInvalidate);

  @override
  void execute() {
    _runReaction();
  }

  _runReaction() {
    global.startBatch();
    _onInvalidate();
    global.endBatch();
  }
}
