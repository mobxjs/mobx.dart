import 'package:mobx/src/core/base_types.dart';

class Action {
  Function _fn;
  String name;

  Action(Function fn, {String name}) {
    _fn = fn;

    this.name = name ?? 'Action@${global.nextId}';
  }

  dynamic call([List args = const [], Map<String, dynamic> namedArgs]) {
    var prevDerivation = _startAction();

    try {
      // Invoke the actual function
      if (namedArgs == null) {
        return Function.apply(_fn, args);
      } else {
        // Convert to symbol-based named-args
        var namedSymbolArgs =
            namedArgs.map((key, value) => MapEntry(Symbol(key), value));
        return Function.apply(_fn, args, namedSymbolArgs);
      }
    } finally {
      _endAction(prevDerivation);
    }
  }

  Derivation _startAction() {
    var prevDerivation = global.untrackedStart();
    global.startBatch();

    return prevDerivation;
  }

  _endAction(Derivation prevDerivation) {
    global.endBatch();
    global.untrackedEnd(prevDerivation);
  }
}

/**
 * Untracked ensures there is no tracking derivation while the given action runs.
 * This is useful in cases where no observers should be linked to a running (tracking) derivation.
 */
T untracked<T>(T Function() action) {
  var prev = global.untrackedStart();
  try {
    return action();
  } finally {
    global.untrackedEnd(prev);
  }
}

/**
 * During a transaction, no derivations (Reaction or ComputedValue<T>) will be run
 * and will be deferred until the end of the transaction (batch). Transactions can
 * be nested, in which case, no derivation will be run until the top-most batch completes
 */
T transaction<T>(T Function() action) {
  global.startBatch();
  try {
    return action();
  } finally {
    global.endBatch();
  }
}
