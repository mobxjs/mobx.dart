part of '../observable_collections.dart';

Atom _observableListAtom<T>(ReactiveContext? context, String? name) {
  final ctx = context ?? mainContext;
  return Atom(name: name ?? ctx.nameFor('ObservableList<$T>'), context: ctx);
}

/// The ObservableList tracks the various read-methods (eg: [List.first], [List.last]) and
/// write-methods (eg: [List.add], [List.insert]) making it easier to use it inside reactions.
///
/// As the name suggests, this is the Observable-counterpart to the standard Dart `List<T>`.
///
/// ```dart
/// final list = ObservableList<int>.of([1]);
///
/// autorun((_) {
///   print(list.first);
/// }) // prints 1
///
/// list[0] = 100; // autorun prints 100
/// ```
class ObservableList<T>
    with
        // ignore: prefer_mixin
        ListMixin<T>
    implements Listenable<ListChange<T>> {
  ObservableList({ReactiveContext? context, String? name})
    : this._wrap(context, _observableListAtom<T>(context, name), []);

  ObservableList.of(
    Iterable<T> elements, {
    ReactiveContext? context,
    String? name,
  }) : this._wrap(
         context,
         _observableListAtom<T>(context, name),
         List<T>.of(elements, growable: true),
       );

  ObservableList._wrap(ReactiveContext? context, this._atom, this._list)
    : _context = context ?? mainContext;

  final ReactiveContext _context;
  final Atom _atom;
  final List<T> _list;

  List<T> get nonObservableInner => _list;

  Listeners<ListChange<T>>? _listenersField;

  Listeners<ListChange<T>> get _listeners =>
      _listenersField ??= Listeners(_context);

  /// The name used to identify for debugging purposes
  String get name => _atom.name;

  @override
  int get length {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.length;
  }

  @override
  set length(int value) {
    /// There is no need to enforceWritePolicy since we are conditionally wrapping in an Action.
    _context.conditionallyRunInAction(() {
      if (value < _list.length) {
        final removed = _list.sublist(value);
        _list.length = value;
        _notifyRangeUpdate(value, null, removed);
      } else if (value > _list.length) {
        final index = _list.length;
        _list.length = value;
        _notifyRangeUpdate(index, _list.sublist(index), null);
      }
    }, _atom);
  }

  @override
  List<T> operator +(List<T> other) {
    _context.enforceReadPolicy(_atom);

    final newList = _list + other;
    _atom.reportObserved();
    return newList;
  }

  @override
  T operator [](int index) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _context.conditionallyRunInAction(() {
      final oldValue = _list[index];

      if (oldValue != value) {
        _list[index] = value;
        _notifyElementUpdate(index, value, oldValue);
      }
    }, _atom);
  }

  @override
  void add(T element) {
    _context.conditionallyRunInAction(() {
      final index = _list.length;
      _list.add(element);
      _notifyElementUpdate(index, element, null, type: OperationType.add);
    }, _atom);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      final list = iterable.toList(growable: false);

      if (list.isNotEmpty) {
        final index = _list.length;

        _list.addAll(list);
        _notifyRangeUpdate(index, list, null);
      }
    }, _atom);
  }

  @override
  Iterator<T> get iterator {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.iterator;
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.lastIndexWhere(test, start);
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.lastWhere(test, orElse: orElse);
  }

  @override
  T get single {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.single;
  }

  @override
  List<T> sublist(int start, [int? end]) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.sublist(start, end);
  }

  @override
  Map<int, T> asMap() => ObservableMap._wrap(_context, _list.asMap(), _atom);

  @override
  List<R> cast<R>() => ObservableList._wrap(_context, _atom, _list.cast<R>());

  @override
  List<T> toList({bool growable = true}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _list.toList(growable: growable);
  }

  @override
  set first(T value) {
    _context.conditionallyRunInAction(() {
      final oldValue = _list.first;
      if (oldValue != value) {
        _list.first = value;
        _notifyElementUpdate(0, value, oldValue);
      }
    }, _atom);
  }

  @override
  void clear() {
    _context.conditionallyRunInAction(() {
      if (_list.isNotEmpty) {
        final oldItems = _list.toList(growable: false);
        _list.clear();
        _notifyRangeUpdate(0, null, oldItems);
      }
    }, _atom);
  }

  @override
  void fillRange(int start, int end, [T? fill]) {
    _context.conditionallyRunInAction(() {
      if (end > start) {
        final oldContents = _list.sublist(start, end);
        _list.fillRange(start, end, fill);
        final newContents = _list.sublist(start, end);
        _notifyRangeUpdate(start, newContents, oldContents);
      }
    }, _atom);
  }

  @override
  void insert(int index, T element) {
    _context.conditionallyRunInAction(() {
      _list.insert(index, element);
      _notifyElementUpdate(index, element, null, type: OperationType.add);
    }, _atom);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      final list = iterable.toList(growable: false);

      if (list.isNotEmpty) {
        _list.insertAll(index, list);
        _notifyRangeUpdate(index, list, null);
      }
    }, _atom);
  }

  @override
  bool remove(Object? element) {
    var didRemove = false;

    _context.conditionallyRunInAction(() {
      final index = _list.indexOf(element as T);
      if (index >= 0) {
        _list.removeAt(index);
        _notifyElementUpdate(index, null, element, type: OperationType.remove);
        didRemove = true;
      }
    }, _atom);

    return didRemove;
  }

  @override
  T removeAt(int index) {
    late T value;

    _context.conditionallyRunInAction(() {
      value = _list.removeAt(index);
      _notifyElementUpdate(index, null, value, type: OperationType.remove);
    }, _atom);

    return value;
  }

  @override
  T removeLast() {
    late T value;

    _context.conditionallyRunInAction(() {
      value = _list.removeLast();
      // Index is _list.length as it points to the index before the last element is removed
      _notifyElementUpdate(
        _list.length,
        null,
        value,
        type: OperationType.remove,
      );
    }, _atom);

    return value;
  }

  @override
  void removeRange(int start, int end) {
    _context.conditionallyRunInAction(() {
      if (end > start) {
        final removedItems = _list.sublist(start, end);
        _list.removeRange(start, end);
        _notifyRangeUpdate(start, null, removedItems);
      }
    }, _atom);
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _context.conditionallyRunInAction(() {
      final removedElements = Queue<ElementChange<T>>();
      for (var i = _list.length - 1; i >= 0; --i) {
        final element = _list[i];
        if (test(element)) {
          removedElements.addFirst(
            ElementChange(
              index: i,
              oldValue: element,
              type: OperationType.remove,
            ),
          );
          _list.removeAt(i);
        }
      }
      if (removedElements.isNotEmpty) {
        _notifyElementsUpdate(removedElements.toList(growable: false));
      }
    }, _atom);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    _context.conditionallyRunInAction(() {
      final list = newContents.toList(growable: false);

      if (end > start || list.isNotEmpty) {
        final oldContents = _list.sublist(start, end);

        _list.replaceRange(start, end, list);
        _notifyRangeUpdate(start, list, oldContents);
      }
    }, _atom);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _context.conditionallyRunInAction(() {
      final removedElements = Queue<ElementChange<T>>();
      for (var i = _list.length - 1; i >= 0; --i) {
        final element = _list[i];
        if (!test(element)) {
          removedElements.addFirst(
            ElementChange(
              index: i,
              oldValue: element,
              type: OperationType.remove,
            ),
          );
          _list.removeAt(i);
        }
      }
      if (removedElements.isNotEmpty) {
        _notifyElementsUpdate(removedElements.toList(growable: false));
      }
    }, _atom);
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      final newValues = iterable.toList(growable: false);

      if (newValues.isNotEmpty) {
        final oldValues = _list.sublist(index, index + newValues.length);
        _list.setAll(index, newValues);
        _notifyRangeUpdate(index, newValues, oldValues);
      }
    }, _atom);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _context.conditionallyRunInAction(() {
      if (end > start) {
        final oldValues = _list.sublist(start, end);

        final newValues = iterable
            .skip(skipCount)
            .take(end - start)
            .toList(growable: false);

        _list.setRange(start, end, newValues);

        _notifyRangeUpdate(start, newValues, oldValues);
      }
    }, _atom);
  }

  @override
  void shuffle([Random? random]) {
    _context.conditionallyRunInAction(() {
      if (_list.isNotEmpty) {
        final oldList = _list.toList(growable: false);
        _list.shuffle(random);
        final changes = <ElementChange<T>>[];
        for (var i = 0; i < _list.length; ++i) {
          final oldValue = oldList[i];
          final newValue = _list[i];
          if (newValue != oldValue) {
            changes.add(
              ElementChange(index: i, oldValue: oldValue, newValue: newValue),
            );
          }
        }
        if (changes.isNotEmpty) {
          _notifyElementsUpdate(changes);
        }
      }
    }, _atom);
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _context.conditionallyRunInAction(() {
      if (_list.isNotEmpty) {
        final oldList = _list.toList(growable: false);
        _list.sort(compare);
        final changes = <ElementChange<T>>[];
        for (var i = 0; i < _list.length; ++i) {
          final oldValue = oldList[i];
          final newValue = _list[i];
          if (newValue != oldValue) {
            changes.add(
              ElementChange(index: i, oldValue: oldValue, newValue: newValue),
            );
          }
        }
        if (changes.isNotEmpty) {
          _notifyElementsUpdate(changes);
        }
      }
    }, _atom);
  }

  /// Attach a [listener] to the changes happening in the list.
  ///
  /// You can choose to receive the change notification immediately (with [fireImmediately])
  /// or on the first change
  @override
  Dispose observe(
    Listener<ListChange<T>> listener, {
    bool fireImmediately = false,
  }) {
    if (fireImmediately == true) {
      final change = ListChange<T>(
        list: this,
        rangeChanges: <RangeChange<T>>[
          RangeChange(index: 0, newValues: toList(growable: false)),
        ],
      );
      listener(change);
    }

    return _listeners.add(listener);
  }

  void _notifyElementUpdate(
    int index,
    T? newValue,
    T? oldValue, {
    OperationType type = OperationType.update,
  }) {
    _atom.reportChanged();

    final change = ListChange<T>(
      list: this,
      elementChanges: <ElementChange<T>>[
        ElementChange(
          index: index,
          newValue: newValue,
          oldValue: oldValue,
          type: type,
        ),
      ],
    );

    _listeners.notifyListeners(change);
  }

  void _notifyElementsUpdate(final List<ElementChange<T>> elementChanges) {
    _atom.reportChanged();

    final change = ListChange<T>(list: this, elementChanges: elementChanges);

    _listeners.notifyListeners(change);
  }

  void _notifyRangeUpdate(int index, List<T>? newValues, List<T>? oldValues) {
    _atom.reportChanged();

    final change = ListChange<T>(
      list: this,
      rangeChanges: <RangeChange<T>>[
        RangeChange(index: index, newValues: newValues, oldValues: oldValues),
      ],
    );

    _listeners.notifyListeners(change);
  }
}

typedef ListChangeListener<TNotification> =
    void Function(ListChange<TNotification>);

/// Stores the change in the value of an element with specific [index].
///
/// The value [OperationType.update] of [type] means changing the value of the element
/// from [oldValue] to [newValue].
///
/// The value [OperationType.add] of [type] means inserting the element with value
/// [newValue] in the list.
///
/// The value [OperationType.remove] of [type] means the element with value [oldValue]
/// was removed from the list.
class ElementChange<T> {
  ElementChange({
    required this.index,
    this.type = OperationType.update,
    this.newValue,
    this.oldValue,
  });

  final int index;
  final OperationType type;
  final T? newValue;
  final T? oldValue;
}

/// Stores the change of values in a range of [ObservableList] started with specific [index].
///
/// The values of elements in the range were changed if [oldValues] and [newValues] are not null
/// and have the same length.
///
/// The elements were added to the list if [newValues] is set and not empty, and [oldValues] is
/// null.
///
/// The elements were removed from the list if [oldValues] is set and not empty, and [newValues]
/// is null.
class RangeChange<T> {
  RangeChange({required this.index, this.newValues, this.oldValues});

  final int index;
  final List<T>? newValues;
  final List<T>? oldValues;
}

/// Stores the change related information when items was modified, added or removed from [list].
///
/// The [elementChanges] object stores change mappings for the indexes of changed elements.
/// The [rangeChanges] object stores mappings of the changed ranges to the indexes of the first
/// elements of this ranges.
/// These two objects cannot overlap (cannot contain the same indexes of changed elements), in
/// most cases only one of them will be defined.
class ListChange<T> {
  ListChange({required this.list, this.elementChanges, this.rangeChanges});

  final ObservableList<T> list;
  final List<ElementChange<T>>? elementChanges;
  final List<RangeChange<T>>? rangeChanges;
}

/// Used during testing for wrapping a regular `List<T>` as an `ObservableList<T>`
@visibleForTesting
ObservableList<T> wrapInObservableList<T>(Atom atom, List<T> list) =>
    ObservableList._wrap(mainContext, atom, list);
