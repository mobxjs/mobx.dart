part of '../observable_collections.dart';

Atom _observableMapAtom<K, V>(ReactiveContext? context, String? name) {
  final ctx = context ?? mainContext;
  return Atom(name: name ?? ctx.nameFor('ObservableMap<$K, $V>'), context: ctx);
}

/// The ObservableMap tracks the various read-methods (eg: [Map.length], [Map.isEmpty]) and
/// write-methods (eg: [Map.[]=], [Map.clear]) making it easier to use it inside reactions.
///
/// As the name suggests, this is the Observable-counterpart to the standard Dart `Map<K,V>`.
///
/// ```dart
/// final map = ObservableMap<String, int>.of({'first': 1});
///
/// autorun((_) {
///   print(map['first']);
/// }) // prints 1
///
/// map['first'] = 100; // autorun prints 100
/// ```

class ObservableMap<K, V>
    with
        // ignore:prefer_mixin
        MapMixin<K, V>
    implements Listenable<MapChange<K, V>> {
  ObservableMap({ReactiveContext? context, String? name})
    : _context = context ?? mainContext,
      _atom = _observableMapAtom<K, V>(context, name),
      _map = <K, V>{};

  ObservableMap.of(Map<K, V> other, {ReactiveContext? context, String? name})
    : _context = context ?? mainContext,
      _atom = _observableMapAtom<K, V>(context, name),
      _map = Map.of(other);

  ObservableMap.linkedHashMapFrom(
    Map<K, V> other, {
    ReactiveContext? context,
    String? name,
  }) : _context = context ?? mainContext,
       _atom = _observableMapAtom<K, V>(context, name),
       _map = LinkedHashMap.from(other);

  ObservableMap.splayTreeMapFrom(
    Map<K, V> other, {
    int Function(K, K)? compare,
    // ignore: avoid_annotating_with_dynamic
    bool Function(dynamic)? isValidKey,
    ReactiveContext? context,
    String? name,
  }) : _context = context ?? mainContext,
       _atom = _observableMapAtom<K, V>(context, name),
       _map = SplayTreeMap.from(other, compare, isValidKey);

  ObservableMap._wrap(this._context, this._map, this._atom);

  final ReactiveContext _context;
  final Atom _atom;
  final Map<K, V> _map;

  Map<K, V> get nonObservableInner => _map;

  String get name => _atom.name;

  Listeners<MapChange<K, V>>? _listenersField;

  Listeners<MapChange<K, V>> get _listeners =>
      _listenersField ??= Listeners(_context);

  bool get _hasListeners =>
      _listenersField != null && _listenersField!.hasHandlers;

  @override
  V? operator [](Object? key) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();

    // Wrap in parentheses to avoid parsing conflicts when casting the key
    return _map[(key as K?)];
  }

  @override
  void operator []=(K key, V value) {
    _context.conditionallyRunInAction(() {
      final oldValue = _map[key];
      var type = 'set';

      if (_hasListeners) {
        if (_map.containsKey(key)) {
          type = 'update';
        } else {
          type = 'add';
        }
      }

      if (!_map.containsKey(key) || value != oldValue) {
        _map[key] = value;
        if (type == 'update') {
          _reportUpdate(key, value, oldValue);
        } else if (type == 'add') {
          _reportAdd(key, value);
        }
        _atom.reportChanged();
      }
    }, _atom);
  }

  @override
  void clear() {
    _context.conditionallyRunInAction(() {
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
    }, _atom);
  }

  @override
  Iterable<K> get keys => MapKeysIterable(_map.keys, _atom);

  @override
  Map<RK, RV> cast<RK, RV>() =>
      ObservableMap._wrap(_context, super.cast(), _atom);

  @override
  V? remove(Object? key) {
    V? value;

    _context.conditionallyRunInAction(() {
      if (_hasListeners) {
        if (_map.containsKey(key)) {
          value = _map.remove(key);
          _reportRemove(key as K?, value);
          _atom.reportChanged();
          return;
        }

        value = null;
      }

      value = _map.remove(key);
      _atom.reportChanged();
    }, _atom);

    return value;
  }

  @override
  int get length {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _map.length;
  }

  @override
  bool get isNotEmpty {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _map.isNotEmpty;
  }

  @override
  bool get isEmpty {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _map.isEmpty;
  }

  @override
  bool containsKey(Object? key) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _map.containsKey(key);
  }

  void _reportUpdate(K key, V newValue, V? oldValue) {
    _listeners.notifyListeners(
      MapChange<K, V>(
        type: OperationType.update,
        key: key,
        newValue: newValue,
        oldValue: oldValue,
        object: this,
      ),
    );
  }

  void _reportAdd(K key, V newValue) {
    _listeners.notifyListeners(
      MapChange<K, V>(
        type: OperationType.add,
        key: key,
        newValue: newValue,
        object: this,
      ),
    );
  }

  void _reportRemove(K? key, V? oldValue) {
    _listeners.notifyListeners(
      MapChange<K, V>(
        type: OperationType.remove,
        key: key,
        oldValue: oldValue,
        object: this,
      ),
    );
  }

  /// Used to attach a listener for getting notified on changes happening to the map
  ///
  /// You can also choose to receive the notifications immediately (with [fireImmediately])
  @override
  Dispose observe(
    MapChangeListener<K, V> listener, {
    bool fireImmediately = false,
  }) {
    if (fireImmediately == true) {
      _map.forEach((key, value) {
        listener(
          MapChange<K, V>(
            type: OperationType.add,
            key: key,
            newValue: value,
            object: this,
          ),
        );
      });
    }
    return _listeners.add(listener);
  }
}

/// A convenience method to wrap the standard `Map<K,V>` in an `ObservableMap<K,V>`.
/// This is mostly to aid in testing.
@visibleForTesting
ObservableMap<K, V> wrapInObservableMap<K, V>(Atom atom, Map<K, V> map) =>
    ObservableMap._wrap(mainContext, map, atom);

typedef MapChangeListener<K, V> = void Function(MapChange<K, V>);

/// Stores the information related to changes happening in an [ObservableMap]. This is
/// used when firing the change notifications to all the listeners
class MapChange<K, V> {
  MapChange({
    this.type,
    this.key,
    this.newValue,
    this.oldValue,
    required this.object,
  });

  final OperationType? type;

  final K? key;
  final V? newValue;
  final V? oldValue;

  final ObservableMap<K, V> object;
}

/// An iterable class that is used to iterate over all the keys of the [ObservableMap].
///
/// We need this wrapper class in order to report the read operations to MobX.
// ignore:prefer_mixin
class MapKeysIterable<K> with IterableMixin<K> {
  MapKeysIterable(this._iterable, this._atom);

  final Iterable<K> _iterable;
  final Atom _atom;

  @override
  int get length {
    _atom.context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _iterable.length;
  }

  @override
  bool contains(Object? element) {
    _atom.context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _iterable.contains(element);
  }

  @override
  Iterator<K> get iterator => MapKeysIterator(_iterable.iterator, _atom);
}

/// An iterator used internally by the ObservableMap to ensure the
/// read operations are reported to MobX correctly
class MapKeysIterator<K> implements Iterator<K> {
  MapKeysIterator(this._iterator, this._atom);

  final Iterator<K> _iterator;
  final Atom _atom;

  @override
  K get current {
    _atom.context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _iterator.current;
  }

  @override
  bool moveNext() {
    _atom.context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _iterator.moveNext();
  }
}
