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
/// In the above code, `dispose` is of type `ReactionDisposer`. It also includes a
/// special property `$mobx`, that has a reference to the underlying reaction. Most
/// of the time you won't need this, but it's good to have it for those special cases!
/// MobX uses it internally for _unit-testing_ and other developer features like _spying_ and
/// _tracing_.
class ReactionDisposer {
  Reaction _rxn;

  Reaction get $mobx => _rxn;

  ReactionDisposer(Reaction rxn) {
    _rxn = rxn;
  }

  call() => $mobx.dispose();
}

/// Executes the specified [fn], whenever the dependent observables change. It returns
/// a disposer that can be used to dispose the autorun.
///
/// Optional configuration:
/// * [name]: debug name for this reaction
/// * [delay]: debouncing delay in milliseconds
///
/// ```
/// var x = observable(10);
/// var y = observable(20);
/// var total = observable(0);
///
/// var dispose = autorun((){
///   print('x = ${x}, y = ${y}, total = ${total}');
/// });
///
/// x.value = 20; // will cause autorun() to re-trigger.
///
/// dispose(); // This disposes the autorun() and will not be triggered again
///
/// x.value = 30; // Will not cause autorun() to re-trigger as it's disposed.
/// ```

ReactionDisposer autorun(Function fn, {String name, int delay}) {
  Reaction rxn;

  var rxnName = name ?? 'Autorun@${global.nextId}';

  if (delay == null) {
    // Use a sync-scheduler.
    rxn = Reaction(() {
      rxn.track(fn);
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

ReactionDisposer reaction<T>(T Function() predicate, void Function(T) effect,
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
  bool Function() predicate,
  void Function() effect, {
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

Future<void> asyncWhen(bool Function() predicate, {String name}) {
  var completer = Completer<void>();

  var disposer = when(predicate, completer.complete, name: name);

  completer.future.catchError((error) {
    disposer();
    throw error;
  });

  return completer.future;
}
