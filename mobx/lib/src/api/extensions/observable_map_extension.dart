part of '../extensions.dart';

/// Turn the Map into an ObservableMap.
extension ObservableMapExtension<K, V> on Map<K, V> {
  ObservableMap<K, V> asObservable() {
    return ObservableMap<K, V>.of(this);
  }
}
