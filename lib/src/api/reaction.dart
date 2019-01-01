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

/// Executes the [predicate] function and tracks the observables used in it. Returns
/// a function to dispose the reaction.
///
/// The [predicate] is supposed to return a value of type T. When it changes, the
/// [effect] function is executed.
///
/// *Note*: Only the [predicate] function is tracked and not the [effect].
///
/// You can also pass in an optional [name], a debouncing [delay] in milliseconds. Use
/// [fireImmediately] if you want to invoke the effect immediately without waiting for
/// the [predicate] to change its value.
ReactionDisposer reaction<T>(Function predicate, void Function(T) effect,
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

/// A one-time reaction that auto-disposes when the [predicate] becomes true. It also
/// executes the [effect] when the predicate turns true.
///
/// You can read it as: "*when* [predicate()] turns true, the [effect()] is executed."
///
/// Returns a function to dispose pre-maturely.
ReactionDisposer when(
  bool Function() predicate,
  void Function() effect, {
  String name,
}) {
  ReactionDisposer disposer;

  var rxnName = name ?? 'When@${ctx.nextId}';
  var effectAction = action(effect, name: '${rxnName}-effect');

  disposer = autorun((Reaction r) {
    if (predicate()) {
      r.dispose();
      effectAction();
    }
  }, name: rxnName);

  return disposer;
}

/// A variant of [when()] which returns a Future. The Future completes when the [predicate()] turns true.
/// Note that there is no effect function here. Typically you would await on the Future and execute the
/// effect after that.
///
/// ```
/// await asyncWhen(() => x.value > 10);
/// // ... execute the effect ...
/// ```
Future<void> asyncWhen(bool Function() predicate, {String name}) {
  var completer = Completer<void>();

  var disposer = when(predicate, completer.complete, name: name);

  completer.future.catchError((error) {
    disposer();
    throw error;
  });

  return completer.future;
}
