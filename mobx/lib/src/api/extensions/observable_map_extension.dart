part of '../extensions.dart';

/// Turn the Map into an ObservableMap.
extension ObservableMapExtension<K, V> on Map<K, V> {
  ObservableMap<K, V> asObservable({ReactiveContext? context, String? name}) =>
      ObservableMap<K, V>.of(this, context: context, name: name);
}

/// Extension for per-key observation of an ObservableMap.
extension ObservableMapKeyExtension<K, V> on ObservableMap<K, V> {
  /// Returns an [ObservableValue] that tracks only changes to the specified [key].
  ///
  /// This is more efficient than accessing `map[key]` directly when you only
  /// care about one key, as it won't trigger rebuilds when other keys change.
  ///
  /// Example usage inside an Observer:
  /// ```dart
  /// Observer(
  ///   builder: (context) {
  ///     final asset = assetsMap.observeKey(assetId).value;
  ///     if (asset == null) return const SizedBox.shrink();
  ///     return AssetListTile(asset: asset);
  ///   },
  /// )
  /// ```
  ///
  /// The listener is automatically set up when the returned value is first
  /// observed and cleaned up when it is no longer being observed.
  ObservableValue<V?> observeKey(K key,
      {String? name, ReactiveContext? context}) {
    return _MapKeyObservable<K, V>(this, key, context: context, name: name);
  }
}

/// An [ObservableValue] that tracks only a specific key in an [ObservableMap].
///
/// Uses the map's [ObservableMap.observe] listener to filter for changes
/// to the specific key, avoiding rebuilds when other keys change.
class _MapKeyObservable<K, V> implements ObservableValue<V?> {
  _MapKeyObservable(this._map, this._key, {ReactiveContext? context, String? name})
      : _context = context ?? mainContext {
    _atom = Atom(
      name: name ?? _context.nameFor('ObservableMapKey<$K, $V>[$_key]'),
      context: _context,
      onObserved: _startListening,
      onUnobserved: _stopListening,
    );
  }

  final ObservableMap<K, V> _map;
  final K _key;
  final ReactiveContext _context;
  late final Atom _atom;
  Dispose? _disposeListener;

  void _startListening() {
    _disposeListener = _map.observe((change) {
      if (change.key == _key) {
        _atom.reportChanged();
      }
    });
  }

  void _stopListening() {
    _disposeListener?.call();
    _disposeListener = null;
  }

  @override
  V? get value {
    _context.enforceReadPolicy(_atom);
    _atom.reportObserved();
    return _map.nonObservableInner[_key];
  }

  /// The name of this observable, useful for debugging.
  String get name => _atom.name;
}
