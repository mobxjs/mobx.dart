part of 'core.dart';

typedef Listener<TNotification> = void Function(TNotification);

// ignore: one_member_abstracts
abstract class Listenable<TNotification> {
  Dispose observe(Listener<TNotification> listener, {bool fireImmediately});
}

class Listeners<TNotification>
    extends NotificationHandlers<TNotification, Listener<TNotification>> {
  Listeners(ReactiveContext context) : super(context);

  Dispose registerListener(Listener<TNotification> listener) => add(listener);

  void notifyListeners(TNotification change) {
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
