part of 'core.dart';

typedef Listener<T> = void Function(ChangeNotification<T>);

// ignore: one_member_abstracts
abstract class Listenable<T> {
  Dispose observe(Listener<T> listener, {bool fireImmediately});
}

class Listeners<T>
    extends NotificationHandlers<ChangeNotification<T>, Listener<T>> {
  Listeners(ReactiveContext context) : super(context);

  Dispose registerListener(Listener<T> listener) => add(listener);

  void notifyListeners(ChangeNotification<T> change) {
    if (!_canHandle(change)) {
      return;
    }

    _context.untracked(() {
      for (final listener in _handlers.toList(growable: false)) {
        listener(change);
      }
    });
  }
}
