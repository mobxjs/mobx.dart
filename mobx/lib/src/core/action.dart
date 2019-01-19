part of '../core.dart';

class Action {
  /// Creates an action that encapsulates all the mutations happening on the
  /// observables.
  ///
  /// Wrapping mutations inside an action ensures the depending observers
  /// are only notified when the action completes. This is useful to silent the notifications
  /// when several observables are being changed together. You will want to run your
  /// reactions only when all the mutations complete. This also helps in keeping
  /// the state of your application consistent.
  ///
  /// You can give a debug-friendly [name] to identify the action.
  ///
  /// ```
  /// var x = Observable(10);
  /// var y = Observable(20);
  /// var total = Observable(0);
  ///
  /// autorun((){
  ///   print('x = ${x}, y = ${y}, total = ${total}');
  /// });
  ///
  /// var totalUp = Action((){
  ///   x.value++;
  ///   y.value++;
  ///
  ///   total.value = x.value + y.value;
  /// }, name: 'adder');
  /// ```
  /// Even though we are changing 3 observables (`x`, `y` and `total`), the [autorun()]
  /// is only executed once. This is the benefit of action. It batches up all the change
  /// notifications and propagates them only after the completion of the action. Actions
  /// can also be nested inside, in which case the change notification will propagate when
  /// the top-level action completes.
  factory Action(Function fn, {ReactiveContext context, String name}) =>
      Action._(context ?? mainContext, fn, name: name);

  Action._(this._context, this._fn, {String name})
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

@experimental
class ActionController {
  ActionController({ReactiveContext context, String name})
      : _context = context,
        name = name ?? context.nameFor('Action');

  final ReactiveContext _context;
  final String name;

  Derivation startAction() {
    final prevDerivation = _context.untrackedStart();
    _context.startBatch();

    return prevDerivation;
  }

  void endAction(Derivation prevDerivation) {
    _context
      ..endBatch()
      ..untrackedEnd(prevDerivation);
  }
}
