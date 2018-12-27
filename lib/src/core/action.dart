import 'package:mobx/src/core/base_types.dart';

class Action {
  Function _fn;
  String name;

  Action(Function fn, {String name}) {
    _fn = fn;

    this.name = name ?? 'Action@${global.nextId}';
  }

  dynamic call([List args, Map<String, dynamic> namedArgs]) {
    var prevDerivation = global.untrackedStart();
    global.startBatch();

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
      global.endBatch();
      global.untrackedEnd(prevDerivation);
    }
  }
}
