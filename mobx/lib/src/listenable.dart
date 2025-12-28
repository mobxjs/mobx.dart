part of 'core.dart';

typedef Listener<TNotification> = void Function(TNotification);

// ignore: one_member_abstracts
abstract class Listenable<TNotification> {
  Dispose observe(
    Listener<TNotification> listener, {
    bool fireImmediately = false,
  });
}

/// Stores the handler functions that have been attached via [Observable.observe] method
/// This is an internal class and should not be used directly.
class Listeners<TNotification> extends NotificationHandlers<TNotification> {
  Listeners(super.context);

  @override
  Dispose add(Listener<TNotification> handler) => super.add(handler);

  void notifyListeners(TNotification change) {
    if (!_canHandle(change)) {
      return;
    }

    _context.untracked(() {
      for (final listener in _handlers?.toList(growable: false) ?? []) {
        listener(change);
      }
    });
  }
}
