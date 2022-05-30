part of '../extensions.dart';

/// Turn the Map into an ObservableMap.
extension ObservableMapExtension<K, V> on Map<K, V> {
  @Deprecated('Use toObs() instead')
  ObservableMap<K, V> asObservable({ReactiveContext? context, String? name})  => toObs(context: context, name: name);

  ObservableMap<K, V> toObs({ReactiveContext? context, String? name}) =>
      ObservableMap<K, V>.of(this, context: context, name: name);
}
