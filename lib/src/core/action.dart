import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/core/derivation.dart';

class Action {
  Action(Function fn, {String name}) {
    _fn = fn;

    this.name = name ?? 'Action@${ctx.nextId}';
  }

  Function _fn;
  String name;

  dynamic call([List args = const [], Map<String, dynamic> namedArgs]) {
    final prevDerivation = _startAction();

    try {
      // Invoke the actual function
      if (namedArgs == null) {
        return Function.apply(_fn, args);
      } else {
        // Convert to symbol-based named-args
        final namedSymbolArgs =
            namedArgs.map((key, value) => MapEntry(Symbol(key), value));
        return Function.apply(_fn, args, namedSymbolArgs);
      }
    } finally {
      _endAction(prevDerivation);
    }
  }

  Derivation _startAction() {
    final prevDerivation = ctx.untrackedStart();
    ctx.startBatch();

    return prevDerivation;
  }

  void _endAction(Derivation prevDerivation) {
    ctx
      ..endBatch()
      ..untrackedEnd(prevDerivation);
  }
}

Action runInAction(Function fn, {String name}) => Action(fn, name: name)();

/// Untracked ensures there is no tracking derivation while the given action runs.
/// This is useful in cases where no observers should be linked to a running (tracking) derivation.
T untracked<T>(T Function() action) {
  final prev = ctx.untrackedStart();
  try {
    return action();
  } finally {
    ctx.untrackedEnd(prev);
  }
}

/// During a transaction, no derivations (Reaction or ComputedValue<T>) will be run
/// and will be deferred until the end of the transaction (batch). Transactions can
/// be nested, in which case, no derivation will be run until the top-most batch completes
T transaction<T>(T Function() action) {
  ctx.startBatch();
  try {
    return action();
  } finally {
    ctx.endBatch();
  }
}
