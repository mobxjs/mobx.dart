import 'dart:async';

import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/core/base_types.dart';
import 'package:mobx/src/core/reaction.dart';
import 'package:mobx/src/utils.dart';

class ReactionDisposer {
  Reaction $mobx;

  ReactionDisposer(this.$mobx);

  call() => $mobx.dispose();
}

/**
 * Executes the reaction whenever the dependent observables change.
 *
 * Optional configuration:
 * name: debug name for this reaction
 * delay: debouncing delay in milliseconds
 */
ReactionDisposer autorun(Function fn, {String name, int delay}) {
  Reaction rxn;

  var rxnName = name ?? 'Autorun@${global.nextId}';

  if (delay == null) {
    // Sync scheduler
    rxn = Reaction(() {
      rxn.track(fn);
    }, name: rxnName);
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
    }, name: rxnName);
  }

  rxn.schedule();
  return ReactionDisposer(rxn);
}

ReactionDisposer reaction<T>(T predicate(), void effect(T),
    {String name, int delay, bool fireImmediately}) {
  Reaction rxn;

  var rxnName = name ?? 'Reaction@${global.nextId}';
  var effectAction =
      action((T value) => effect(value), name: '${rxnName}-effect');

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
  }, name: rxnName);

  rxn.schedule();
  return ReactionDisposer(rxn);
}

ReactionDisposer when(
  bool predicate(),
  void effect(), {
  String name,
}) {
  ReactionDisposer disposer;

  var rxnName = name ?? 'When@${global.nextId}';
  var effectAction = action(effect, name: '${rxnName}-effect');

  disposer = autorun(() {
    if (predicate()) {
      disposer();
      effectAction();
    }
  }, name: rxnName);

  return disposer;
}

Future<void> asyncWhen(bool predicate(), {String name}) {
  var completer = Completer<void>();

  var disposer = when(predicate, completer.complete, name: name);

  completer.future.catchError((error) {
    disposer();
    throw error;
  });

  return completer.future;
}
