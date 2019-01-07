import 'dart:collection';

import 'package:mobx/src/core.dart';
import 'package:mobx/src/utils.dart';

typedef Interceptor<T> = WillChangeNotification<T> Function(
    WillChangeNotification<T>);

// ignore: one_member_abstracts
abstract class Interceptable<T> {
  Dispose intercept(Interceptor<T> interceptor);
}

class Interceptors<T> implements Interceptable<T> {
  Interceptors(this._context) : assert(_context != null);

  final ReactiveContext _context;

  Set<Interceptor<T>> _interceptors;

  @override
  Dispose intercept(Interceptor<T> interceptor) {
    assert(interceptor != null);

    _interceptors ??= LinkedHashSet();
    final listeners = _interceptors..add(interceptor);
    return () => listeners.remove(interceptor);
  }

  bool get hasInterceptors => _interceptors?.isNotEmpty ?? false;

  WillChangeNotification interceptChange(WillChangeNotification<T> change) {
    assert(change != null);

    if (!hasInterceptors) {
      return change;
    }
    return _context.untracked(() {
      var nextChange = change;
      for (final interceptor in _interceptors.toList(growable: false)) {
        nextChange = interceptor(nextChange);
        if (nextChange == null) {
          break;
        }
      }

      return nextChange;
    });
  }
}
