part of '../observable_collections.dart';

Atom _observableMapAtom<K, V>(ReactiveContext context) {
  final ctx = context ?? mainContext;
  return Atom(name: ctx.nameFor('ObservableMap<$K, $V>'), context: ctx);
}

class ObservableMap<K, V>
    with
        // ignore:prefer_mixin
        MapMixin<K, V>
    implements
        Listenable<MapChange<K, V>> {
  ObservableMap({ReactiveContext context})
      : _context = context ?? mainContext,
        _atom = _observableMapAtom<K, V>(context),
        _map = <K, V>{};

  ObservableMap.of(Map<K, V> other, {ReactiveContext context})
      : _context = context ?? mainContext,
        _atom = _observableMapAtom<K, V>(context),
        _map = Map.of(other);

  ObservableMap.linkedHashMapFrom(Map<K, V> other, {ReactiveContext context})
      : _context = context ?? mainContext,
        _atom = _observableMapAtom<K, V>(context),
        _map = LinkedHashMap.from(other);

  ObservableMap.splayTreeMapFrom(Map<K, V> other,
      {int Function(K, K) compare,
      // ignore: avoid_annotating_with_dynamic
      bool Function(dynamic) isValidKey,
      ReactiveContext context})
      : _context = context ?? mainContext,
        _atom = _observableMapAtom<K, V>(context),
        _map = SplayTreeMap.from(other, compare, isValidKey);

  ObservableMap._wrap(this._context, this._map, this._atom);

  final ReactiveContext _context;
  final Atom _atom;
  final Map<K, V> _map;

  Listeners<MapChange<K, V>> _listenersField;

  Listeners<MapChange<K, V>> get _listeners =>
      _listenersField ??= Listeners(_context);

  bool get _hasListeners =>
      _listenersField != null && _listenersField.hasHandlers;

  @override
  V operator [](Object key) {
    _atom.reportObserved();
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    if (_hasListeners) {
      if (_map.containsKey(key)) {
        final oldValue = _map[key];
        _map[key] = value;
        _reportUpdate(key, value, oldValue);
      } else {
        _map[key] = value;
        _reportAdd(key, value);
      }
    } else {
      _map[key] = value;
    }
    _atom.reportChanged();
  }

  @override
  void clear() {
    _context.checkIfStateModificationsAreAllowed(_atom);

    if (isEmpty) {
      return;
    }
    if (_hasListeners) {
      final removed = Map<K, V>.from(_map);
      _map.clear();
      removed.forEach(_reportRemove);
    } else {
      _map.clear();
    }
    _atom.reportChanged();
  }

  @override
  Iterable<K> get keys => MapKeysIterable(_map.keys, _atom);

  @override
  Map<RK, RV> cast<RK, RV>() =>
      ObservableMap._wrap(_context, super.cast(), _atom);

  @override
  V remove(Object key) {
    _context.checkIfStateModificationsAreAllowed(_atom);

    if (_hasListeners) {
      if (_map.containsKey(key)) {
        final value = _map.remove(key);
        _reportRemove(key, value);
        _atom.reportChanged();
        return value;
      }
      return null;
    }

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

  void _reportUpdate(K key, V newValue, V oldValue) {
    _listeners.notifyListeners(MapChange<K, V>(
      type: OperationType.update,
      key: key,
      newValue: newValue,
      oldValue: oldValue,
      object: this,
    ));
  }

  void _reportAdd(K key, V newValue) {
    _listeners.notifyListeners(MapChange<K, V>(
      type: OperationType.add,
      key: key,
      newValue: newValue,
      object: this,
    ));
  }

  void _reportRemove(K key, V oldValue) {
    _listeners.notifyListeners(MapChange<K, V>(
      type: OperationType.remove,
      key: key,
      oldValue: oldValue,
      object: this,
    ));
  }

  @override
  Dispose observe(MapChangeListener<K, V> listener, {bool fireImmediately}) {
    final dispose = _listeners.add(listener);
    if (fireImmediately == true) {
      _map.forEach(_reportAdd);
    }
    return dispose;
  }
}

@visibleForTesting
ObservableMap<K, V> wrapInObservableMap<K, V>(Atom atom, Map<K, V> map) =>
    ObservableMap._wrap(mainContext, map, atom);

typedef MapChangeListener<K, V> = void Function(MapChange<K, V>);

class MapChange<K, V> {
  MapChange({this.type, this.key, this.newValue, this.oldValue, this.object});

  final OperationType type;

  final K key;
  final V newValue;
  final V oldValue;

  final ObservableMap<K, V> object;
}

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
