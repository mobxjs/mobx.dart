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

/// An internal helper function to create a [autorun]
ReactionDisposer createAutorun(
  ReactiveContext context,
  Function(Reaction) trackingFn, {
  String? name,
  int? delay,
  Timer Function(void Function())? scheduler,
  void Function(Object, Reaction)? onError,
}) {
  late ReactionImpl rxn;

  final rxnName = name ?? context.nameFor('Autorun');
  final runSync = scheduler == null && delay == null;

  if (runSync) {
    // Use a sync-scheduler.
    rxn = ReactionImpl(
      context,
      () {
        rxn.track(() => trackingFn(rxn));
      },
      name: rxnName,
      onError: onError,
    );
  } else {
    // Use a scheduler or delayed scheduler.
    final schedulerFromOptions =
        scheduler ?? (delay != null ? createDelayedScheduler(delay) : null);
    var isScheduled = false;
    Timer? timer;

    rxn = ReactionImpl(
      context,
      () {
        if (!isScheduled) {
          isScheduled = true;

          timer?.cancel();
          timer = null;

          timer = schedulerFromOptions!(() {
            isScheduled = false;
            if (!rxn.isDisposed) {
              rxn.track(() => trackingFn(rxn));
            } else {
              timer?.cancel();
            }
          });
        }
      },
      name: rxnName,
      onError: onError,
    );
  }

  rxn.schedule();
  return ReactionDisposer(rxn);
}

/// An internal helper function to create a [reaction]
ReactionDisposer createReaction<T>(
  ReactiveContext context,
  T Function(Reaction) fn,
  void Function(T) effect, {
  String? name,
  int? delay,
  bool? fireImmediately,
  EqualityComparer<T>? equals,
  Timer Function(void Function())? scheduler,
  void Function(Object, Reaction)? onError,
}) {
  late ReactionImpl rxn;

  final rxnName = name ?? context.nameFor('Reaction');

  final effectAction = Action(
    (T? value) => effect(value as T),
    name: '$rxnName-effect',
  );

  final runSync = scheduler == null && delay == null;
  final schedulerFromOptions =
      scheduler ?? (delay != null ? createDelayedScheduler(delay) : null);

  var firstTime = true;
  T? value;

  void reactionRunner() {
    if (rxn.isDisposed) {
      return;
    }

    var changed = false;

    rxn.track(() {
      final nextValue = fn(rxn);

      // Use the equality-comparator if provided
      final isEqual =
          equals != null ? equals(nextValue, value) : (nextValue == value);

      changed = firstTime || !isEqual;
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

  Timer? timer;
  var isScheduled = false;

  rxn = ReactionImpl(
    context,
    () {
      if (firstTime || runSync) {
        reactionRunner();
      } else if (!isScheduled) {
        isScheduled = true;

        timer?.cancel();
        timer = null;

        timer = schedulerFromOptions!(() {
          isScheduled = false;
          if (!rxn.isDisposed) {
            reactionRunner();
          } else {
            timer?.cancel();
          }
        });
      }
    },
    name: rxnName,
    onError: onError,
  );

  // ignore: cascade_invocations
  rxn.schedule();

  return ReactionDisposer(rxn);
}

/// An internal helper function to create a [when]
ReactionDisposer createWhenReaction(
  ReactiveContext context,
  bool Function(Reaction) predicate,
  void Function() effect, {
  String? name,
  int? timeout,
  void Function(Object, Reaction)? onError,
}) {
  final rxnName = name ?? context.nameFor('When');
  final effectAction = Action(effect, name: '$rxnName-effect');

  Timer? timer;
  late ReactionDisposer dispose;

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

  return dispose = createAutorun(
    context,
    (reaction) {
      if (predicate(reaction)) {
        reaction.dispose();
        timer?.cancel();
        timer = null;
        effectAction();
      }
    },
    name: rxnName,
    onError: onError,
  );
}

/// An internal helper function to create an [asyncWhen]
Future<void> createAsyncWhenReaction(
  ReactiveContext context,
  bool Function(Reaction) predicate, {
  String? name,
  int? timeout,
}) {
  final completer = Completer<void>();
  createWhenReaction(
    context,
    predicate,
    completer.complete,
    name: name,
    timeout: timeout,
    onError: (error, reaction) {
      reaction.dispose();
      completer.completeError(error);
    },
  );

  return completer.future;
}
