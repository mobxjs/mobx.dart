part of '../core.dart';

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
  ReactionDisposer(this.reaction);

  final Reaction reaction;

  /// Invoking it will dispose the underlying [reaction]
  void call() => reaction.dispose();
}

ReactionDisposer createAutorun(
    ReactiveContext context, Function(Reaction) trackingFn,
    {String name, int delay, void Function(Object, Reaction) onError}) {
  ReactionImpl rxn;

  final rxnName = name ?? context.nameFor('Autorun');

  if (delay == null) {
    // Use a sync-scheduler.
    rxn = ReactionImpl(context, () {
      rxn.track(() => trackingFn(rxn));
    }, name: rxnName, onError: onError);
  } else {
    // Use a delayed scheduler.
    final scheduler = createDelayedScheduler(delay);
    var isScheduled = false;
    Timer timer;

    rxn = ReactionImpl(context, () {
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
    }, name: rxnName, onError: onError);
  }

  rxn.schedule();
  return ReactionDisposer(rxn);
}

ReactionDisposer createReaction<T>(ReactiveContext context,
    T Function(Reaction) predicate, void Function(T) effect,
    {String name,
    int delay,
    bool fireImmediately,
    void Function(Object, Reaction) onError}) {
  ReactionImpl rxn;

  final rxnName = name ?? context.nameFor('Reaction');

  final effectAction =
      Action((T value) => effect(value), name: '$rxnName-effect');

  final runSync = delay == null;
  final scheduler = delay != null ? createDelayedScheduler(delay) : null;

  var firstTime = true;
  T value;

  void reactionRunner() {
    if (rxn.isDisposed) {
      return;
    }

    var changed = false;

    rxn.track(() {
      final nextValue = predicate(rxn);
      changed = firstTime || (nextValue != value);
      value = nextValue;
    });

    final canInvokeEffect =
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

  rxn = ReactionImpl(context, () {
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
  }, name: rxnName, onError: onError);

  // ignore: cascade_invocations
  rxn.schedule();

  return ReactionDisposer(rxn);
}

ReactionDisposer createWhenReaction(ReactiveContext context,
    bool Function(Reaction) predicate, void Function() effect,
    {String name, int timeout, void Function(Object, Reaction) onError}) {
  final rxnName = name ?? context.nameFor('When');
  final effectAction = Action(effect, name: '$rxnName-effect');

  Timer timer;
  ReactionDisposer dispose;

  // Run a race with a timeout!
  if (timeout != null) {
    timer = Timer(ms * timeout, () {
      // Timed out before a disposal, effectively a Timeout-Error!
      if (!dispose.reaction.isDisposed) {
        dispose();

        final error = MobXException('WHEN_TIMEOUT');
        if (onError != null) {
          onError(error, dispose.reaction);
        } else {
          // TODO(pavanpodila): Should this be reported with onReactionError handler???
          throw error;
        }
      }
    });
  }

  return dispose = createAutorun(context, (reaction) {
    if (predicate(reaction)) {
      reaction.dispose();
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      effectAction();
    }
  }, name: rxnName, onError: onError);
}

Future<void> createAsyncWhenReaction(
    ReactiveContext context, bool Function(Reaction) predicate,
    {String name, int timeout}) {
  final completer = Completer<void>();
  createWhenReaction(context, predicate, completer.complete,
      name: name, timeout: timeout, onError: (error, reaction) {
    reaction.dispose();
    completer.completeError(error);
  });

  return completer.future;
}
