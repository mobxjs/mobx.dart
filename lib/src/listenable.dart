import 'dart:collection';

import 'package:mobx/src/core.dart';
import 'package:mobx/src/utils.dart';

typedef Listener<T> = void Function(ChangeNotification<T>);

// ignore: one_member_abstracts
abstract class Listenable<T> {
  Dispose observe(Listener<T> listener, {bool fireImmediately});
}

class Listeners<T> {
  Listeners(this._context) : assert(_context != null);

  final ReactiveContext _context;

  Set<Listener<T>> _listeners;

  bool get hasListeners => _listeners?.isNotEmpty ?? false;

  Dispose registerListener(Listener<T> listener) {
    assert(listener != null);

    _listeners ??= LinkedHashSet();
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  void notifyListeners(ChangeNotification<T> change) {
    assert(change != null);

    if (!hasListeners) {
      return;
    }

    _context.untracked(() {
      for (final listener in _listeners.toList(growable: false)) {
        listener(change);
      }
    });
  }
}
