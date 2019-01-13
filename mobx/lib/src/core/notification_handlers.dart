part of '../core.dart';

class NotificationHandlers<TNotification, THandler extends Function> {
  NotificationHandlers(this._context) : assert(_context != null);

  final ReactiveContext _context;

  Set<THandler> _handlers;

  Dispose add(THandler handler) {
    assert(handler != null);

    _handlers ??= LinkedHashSet<THandler>();
    final listeners = _handlers..add(handler);
    return () => listeners.remove(handler);
  }

  bool get hasHandlers => _handlers?.isNotEmpty ?? false;

  bool _canHandle(TNotification notification) {
    assert(notification != null);

    return hasHandlers;
  }
}
