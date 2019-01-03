import 'dart:async';

import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/core/base_types.dart';
import 'package:mobx/src/core/reaction.dart';
import 'package:mobx/src/utils.dart';

/// A callable class that is used to dispose a [reaction], [autorun] or [when]
///
/// ```
/// var dispose = autorun((){
///   // ...
/// });
///
/// dispose(); // dispose the autorun()
/// ```
///
/// In the above code, `dispose` is of type `ReactionDisposer`.
class ReactionDisposer {
  Reaction _rxn;

  /// A special property that has a reference to the underlying reaction. Most
  /// of the time you won't need this, but it's good to have it for those special cases!
  /// MobX uses it internally for _unit-testing_ and other developer features like _spying_ and
  /// _tracing_.
  Reaction get $mobx => _rxn;

  ReactionDisposer(Reaction rxn) {
    _rxn = rxn;
  }

  /// Invoking it will dispose the underlying [reaction]
  call() => $mobx.dispose();
}

ReactionDisposer createAutorun(Function fn, {String name, int delay}) {
  Reaction rxn;

  var rxnName = name ?? 'Autorun@${ctx.nextId}';
  var trackingFn = prepareTrackingFunction(fn);

  if (delay == null) {
    // Use a sync-scheduler.
    rxn = Reaction(() {
      rxn.track(() => trackingFn(rxn));
    }, name: rxnName);
  } else {
    // Use a delayed scheduler.
    var scheduler = createDelayedScheduler(delay);
    var isScheduled = false;
    Timer timer;

    rxn = Reaction(() {
      if (!isScheduled) {
        isScheduled = true;

        if (timer != null) {
          timer.cancel();
          timer = null;
        }

        timer = scheduler(() {
          isScheduled = false;
          if (!rxn.isDisposed) {
            rxn.track(() => trackingFn(rxn));
          } else {
            timer.cancel();
          }
        });
      }
    }, name: rxnName);
  }

  rxn.schedule();
  return ReactionDisposer(rxn);
}

ReactionDisposer createReaction<T>(Function predicate, void Function(T) effect,
    {String name, int delay, bool fireImmediately}) {
  Reaction rxn;

  var rxnName = name ?? 'Reaction@${ctx.nextId}';
  var trackingPredicateFn = prepareTrackingFunction(predicate);

  var effectAction =
      action((T value) => effect(value), name: '${rxnName}-effect');

  var runSync = (delay == null);
  var scheduler = delay != null ? createDelayedScheduler(delay) : null;

  var firstTime = true;
  T value;

  reactionRunner() {
    if (rxn.isDisposed) {
      return;
    }

    var changed = false;

    rxn.track(() {
      var nextValue = trackingPredicateFn(rxn);
      changed = firstTime || (nextValue != value);
      value = nextValue;
    });

    var canInvokeEffect =
        (firstTime && fireImmediately == true) || (!firstTime && changed);
    if (canInvokeEffect) {
      effectAction([value]);
    }
    if (firstTime) {
      firstTime = false;
    }
  }

  Timer timer;
  var isScheduled = false;

  rxn = Reaction(() {
    if (firstTime || runSync) {
      reactionRunner();
    } else if (!isScheduled) {
      isScheduled = true;

      if (timer != null) {
        timer.cancel();
        timer = null;
      }

      timer = scheduler(() {
        isScheduled = false;
        if (!rxn.isDisposed) {
          reactionRunner();
        } else {
          timer.cancel();
        }
      });
    }
  }, name: rxnName);

  rxn.schedule();
  return ReactionDisposer(rxn);
}

ReactionDisposer createWhenReaction(
  bool Function() predicate,
  void Function() effect, {
  String name,
}) {
  ReactionDisposer disposer;

  var rxnName = name ?? 'When@${ctx.nextId}';
  var effectAction = action(effect, name: '${rxnName}-effect');

  disposer = createAutorun((Reaction r) {
    if (predicate()) {
      r.dispose();
      effectAction();
    }
  }, name: rxnName);

  return disposer;
}

Future<void> createAsyncWhenReaction(bool Function() predicate, {String name}) {
  var completer = Completer<void>();

  var disposer = createWhenReaction(predicate, completer.complete, name: name);

  completer.future.catchError((error) {
    disposer();
    throw error;
  });

  return completer.future;
}
