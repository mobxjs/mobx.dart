part of '../core.dart';

class NotificationHandlers<TNotification> {
  NotificationHandlers(this._context) : assert(_context != null);

  final ReactiveContext _context;

  Set<Function> _handlers;

  Dispose add(covariant Function handler) {
    assert(handler != null);

    // ignore: prefer_collection_literals
    _handlers ??= LinkedHashSet<Function>();
    final listeners = _handlers..add(handler);
    return () => listeners.remove(handler);
  }

  bool get hasHandlers => _handlers?.isNotEmpty ?? false;

  bool _canHandle(TNotification notification) {
    assert(notification != null);

    return hasHandlers;
  }
}
