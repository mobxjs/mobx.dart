import 'package:meta/meta.dart';
import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/core/derivation.dart';
import 'package:mobx/src/core/reaction.dart';

/// Tracks changes that happen between [Tracking.begin] and [Tracking.end].
///
/// This should only be used in situations where it is not possible to
/// track changes inside a callback function.
@experimental
class Tracking {
  Tracking.begin(ReactiveContext context, Function() onInvalidate,
      {String name})
      : assert(context != null),
        assert(onInvalidate != null),
        assert(name != ''),
        _reaction = TrackingReaction(context, onInvalidate,
            name: name ?? context.nameFor('Transaction')) {
    _prevDerivation = _reaction.startTracking();
  }

  final TrackingReaction _reaction;
  Derivation _prevDerivation;
  bool _ended = false;

  void end() {
    if (_ended) {
      return;
    }

    _ended = true;
    _reaction.endTracking(_prevDerivation);
    _prevDerivation = null;
  }

  void dispose() {
    end();
    _reaction.dispose();
  }
}
