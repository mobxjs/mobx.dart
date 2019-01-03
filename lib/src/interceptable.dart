import 'package:mobx/src/core/action.dart';
import 'package:mobx/src/core/atom_derivation.dart';

abstract class Interceptable {
  List<Function> interceptors;
  Function intercept<T>(
      WillChangeNotification<T> Function(WillChangeNotification<T>) handler);
}

bool hasInterceptors(Interceptable obj) {
  return obj.interceptors != null && obj.interceptors.length > 0;
}

Function registerInterceptor(Interceptable obj, Function handler) {
  var listeners = obj.interceptors ?? (obj.interceptors = List());
  listeners.add(handler);

  return () {
    var index = listeners.indexOf(handler);
    if (index != -1) {
      listeners.removeAt(index);
    }
  };
}

WillChangeNotification<T> interceptChange<T>(
    Interceptable obj, WillChangeNotification<T> change) {
  return untracked(() {
    if (obj.interceptors == null) {
      return change;
    }

    var nextChange = change;
    var listeners = obj.interceptors.toList(growable: false);
    for (var i = 0; i < listeners.length; i++) {
      var listener = listeners[i];

      nextChange = listener(nextChange);
      if (nextChange == null) {
        break;
      }
    }

    return nextChange;
  });
}
