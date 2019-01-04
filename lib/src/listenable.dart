import 'package:mobx/src/core/action.dart';
import 'package:mobx/src/core/atom_derivation.dart';

abstract class Listenable<T> {
  List<Listener<T>> changeListeners;

  Function observe(void Function(ChangeNotification<T>) handler,
      {bool fireImmediately});
}

typedef Listener<T> = Function(ChangeNotification<T>);

bool hasListeners<T>(Listenable<T> obj) =>
    obj.changeListeners != null && obj.changeListeners.isNotEmpty;

Function() registerListener<T>(Listenable<T> listenable, Listener<T> listener) {
  if (listenable.changeListeners == null) {
    listenable.changeListeners = [];
  }
  final listeners = listenable.changeListeners..add(listener);

  return () {
    final index = listeners.indexOf(listener);
    if (index != -1) {
      listeners.removeAt(index);
    }
  };
}

void notifyListeners<T>(Listenable<T> obj, ChangeNotification<T> change) {
  untracked(() {
    if (obj.changeListeners == null) {
      return;
    }

    final listeners = obj.changeListeners.toList(growable: false);
    for (var i = 0; i < listeners.length; i++) {
      final listener = listeners[i];

      listener(change);
    }
  });
}
