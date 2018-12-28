import 'dart:async';

import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/core/reaction.dart';
import 'package:mobx/src/utils.dart';

typedef ReactionDisposer = void Function();

/**
 * Executes the reaction whenever the dependent observables change.
 *
 * Optional configuration:
 * name: debug name for this reaction
 * delay: debouncing delay in milliseconds
 */
ReactionDisposer autorun(Function fn, {String name, int delay}) {
  Reaction rxn;

  if (delay == null) {
    // Sync scheduler
    rxn = Reaction(() {
      rxn.track(fn);
    }, name: name);
  } else {
    // Delayed scheduler
    var scheduler = createDelayedScheduler(delay);
    var isScheduled = false;
    Timer timer;

    rxn = Reaction(() {
      if (!isScheduled) {
        isScheduled = true;

        if (timer != null) {
          timer.cancel();
        }

        timer = scheduler(() {
          isScheduled = false;
          if (!rxn.isDisposed) {
            rxn.track(fn);
          } else {
            timer.cancel();
          }
        });
      }
    }, name: name);
  }

  rxn.schedule();
  return rxn.dispose;
}

ReactionDisposer reaction<T>(T Function() predicate, Function(T) effect,
    {String name, int delay, bool fireImmediately}) {
  Reaction rxn;

  var effectAction = action((T value) => effect(value), name: name);

  var runSync = (delay == null);
  var scheduler = delay != null ? createDelayedScheduler(delay) : null;

  var firstTime = true;
  var isScheduled = false;
  T value;

  reactionRunner() {
    isScheduled = false;
    if (rxn.isDisposed) {
      return;
    }

    var changed = false;
    rxn.track(() {
      var nextValue = predicate();
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

  rxn = Reaction(() {
    if (firstTime || runSync) {
      reactionRunner();
    } else if (!isScheduled) {
      isScheduled = true;
      scheduler(reactionRunner);
    }
  }, name: name);

  rxn.schedule();
  return rxn.dispose;
}
