part of '../observable_collections.dart';

Atom _observableMapAtom<K, V>(ReactiveContext context) {
  final ctx = context ?? mainContext;
  return Atom(name: ctx.nameFor('ObservableMap<$K, $V>'), context: ctx);
}

// ignore:prefer_mixin
class ObservableMap<K, V> with MapMixin<K, V> {
  ObservableMap({ReactiveContext context})
      : _atom = _observableMapAtom<K, V>(context),
        _map = <K, V>{};

  ObservableMap.of(Map<K, V> other, {ReactiveContext context})
      : _atom = _observableMapAtom<K, V>(context),
        _map = Map.of(other);

  ObservableMap.linkedHashMapFrom(Map<K, V> other, {ReactiveContext context})
      : _atom = _observableMapAtom<K, V>(context),
        _map = LinkedHashMap.from(other);

  ObservableMap.splayTreeMapFrom(Map<K, V> other,
      {int Function(K, K) compare,
      // ignore: avoid_annotating_with_dynamic
      bool Function(dynamic) isValidKey,
      ReactiveContext context})
      : _atom = _observableMapAtom<K, V>(context),
        _map = SplayTreeMap.from(other, compare, isValidKey);

  ObservableMap._wrap(this._map, this._atom);

  final Atom _atom;
  final Map<K, V> _map;

  @override
  V operator [](Object key) {
    _atom.reportObserved();
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
    _atom.reportChanged();
  }

  @override
  void clear() {
    _map.clear();
    _atom.reportChanged();
  }

  @override
  Iterable<K> get keys => MapKeysIterable(_map.keys, _atom);

  @override
  Map<RK, RV> cast<RK, RV>() => ObservableMap._wrap(super.cast(), _atom);

  @override
  V remove(Object key) {
    final value = _map.remove(key);
    _atom.reportChanged();
    return value;
  }

  @override
  int get length {
    _atom.reportObserved();
    return _map.length;
  }

  @override
  bool get isNotEmpty {
    _atom.reportObserved();
    return _map.isNotEmpty;
  }

  @override
  bool get isEmpty {
    _atom.reportObserved();
    return _map.isEmpty;
  }

  @override
  bool containsKey(Object key) {
    _atom.reportObserved();
    return _map.containsKey(key);
  }
}

@visibleForTesting
ObservableMap<K, V> wrapInObservableMap<K, V>(Atom atom, Map<K, V> map) =>
    ObservableMap._wrap(map, atom);

// ignore:prefer_mixin
class MapKeysIterable<K> with IterableMixin<K> {
  MapKeysIterable(this._iterable, this._atom);

  final Iterable<K> _iterable;
  final Atom _atom;

  @override
  int get length {
    _atom.reportObserved();
    return _iterable.length;
  }

  @override
  bool contains(Object element) {
    _atom.reportObserved();
    return _iterable.contains(element);
  }

  @override
  Iterator<K> get iterator => MapKeysIterator(_iterable.iterator, _atom);
}

class MapKeysIterator<K> implements Iterator<K> {
  MapKeysIterator(this._iterator, this._atom);

  final Iterator<K> _iterator;
  final Atom _atom;

  @override
  K get current {
    _atom.reportObserved();
    return _iterator.current;
  }

  @override
  bool moveNext() {
    _atom.reportObserved();
    return _iterator.moveNext();
  }
}
