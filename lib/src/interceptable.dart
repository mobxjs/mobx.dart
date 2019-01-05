import 'package:mobx/src/core/action.dart';
import 'package:mobx/src/core/atom.dart';

typedef Interceptor<T> = Function(WillChangeNotification<T>);

abstract class Interceptable<T> {
  List<Interceptor<T>> interceptors;

  Function intercept(
      WillChangeNotification<T> Function(WillChangeNotification<T>) handler);
}

bool hasInterceptors<T>(Interceptable<T> obj) =>
    obj.interceptors != null && obj.interceptors.isNotEmpty;

Function registerInterceptor<T>(
    Interceptable<T> obj, Interceptor<T> interceptor) {
  if (obj.interceptors == null) {
    obj.interceptors = [];
  }
  final listeners = obj.interceptors..add(interceptor);

  return () {
    final index = listeners.indexOf(interceptor);
    if (index != -1) {
      listeners.removeAt(index);
    }
  };
}

WillChangeNotification<T> interceptChange<T>(
        Interceptable<T> obj, WillChangeNotification<T> change) =>
    untracked(() {
      if (obj.interceptors == null) {
        return change;
      }

      var nextChange = change;
      final interceptors = obj.interceptors.toList(growable: false);
      for (var i = 0; i < interceptors.length; i++) {
        final listener = interceptors[i];

        nextChange = listener(nextChange);
        if (nextChange == null) {
          break;
        }
      }

      return nextChange;
    });
