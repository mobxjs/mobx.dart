part of '../core.dart';

class NotificationHandlers<TNotification,
    TNotificationHandler extends Function> {
  NotificationHandlers(this._context) : assert(_context != null);

  final ReactiveContext _context;

  Set<TNotificationHandler> _handlers;

  Dispose add(TNotificationHandler handler) {
    assert(handler != null);

    _handlers ??= LinkedHashSet<TNotificationHandler>();
    final listeners = _handlers..add(handler);
    return () => listeners.remove(handler);
  }

  bool get hasHandlers => _handlers?.isNotEmpty ?? false;

  bool _canHandle(TNotification notification) {
    assert(notification != null);

    return hasHandlers;
  }
}
