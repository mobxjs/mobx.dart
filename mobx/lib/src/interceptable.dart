part of 'core.dart';

typedef Interceptor<T> =
    WillChangeNotification<T>? Function(WillChangeNotification<T>);

// ignore: one_member_abstracts
abstract class Interceptable<T> {
  Dispose intercept(Interceptor<T> interceptor);
}

/// Stores the intercept-handlers that have been attached to a specific Observable.
///
/// When `observableInstance.intercept(handler)` is invoked, the passed-in handler
/// is stored inside the `Interceptors<T>`.
/// This is an internal class and should not be used directly.
class Interceptors<T> extends NotificationHandlers<WillChangeNotification<T>> {
  Interceptors(super.context);

  @override
  Dispose add(Interceptor<T> handler) => super.add(handler);

  WillChangeNotification<T>? interceptChange(WillChangeNotification<T> change) {
    if (!_canHandle(change)) {
      return change;
    }

    return _context.untracked(() {
      WillChangeNotification<T>? nextChange = change;
      for (final interceptor in _handlers?.toList(growable: false) ?? []) {
        nextChange = (interceptor as Interceptor<T>)(nextChange!);
        if (nextChange == null) {
          break;
        }
      }

      return nextChange;
    });
  }
}
