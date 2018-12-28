import 'dart:async';

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
