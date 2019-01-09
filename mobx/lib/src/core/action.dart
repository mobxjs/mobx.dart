part of '../core.dart';

class Action {
  Action(this._context, this._fn, {String name})
      : name = name ?? _context.nameFor('Action');

  final ReactiveContext _context;

  final Function _fn;

  final String name;

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
    final prevDerivation = _context.untrackedStart();
    _context.startBatch();

    return prevDerivation;
  }

  void _endAction(Derivation prevDerivation) {
    _context
      ..endBatch()
      ..untrackedEnd(prevDerivation);
  }
}
