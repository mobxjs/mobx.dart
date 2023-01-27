part of '../observable_collections.dart';

Atom _observableQueueAtom<T>(ReactiveContext? context, String? name) {
  final ctx = context ?? mainContext;
  return Atom(name: name ?? ctx.nameFor('ObservableQueue<$T>'), context: ctx);
}

/// The ObservableQueue tracks the various read-methods (eg: [List.first], [List.last]) and
/// write-methods (eg: [Queue.add], [Queue.addFirst],  [Queue.addLast]) making it easier to use it inside reactions.
///
/// As the name suggests, this is the Observable-counterpart to the standard Dart `Queue<T>`.
///
/// ```dart
/// final queue = ObservableQueue<int>.of([1]);
///
/// autorun((_) {
///   print(queue.first);
/// }) // prints 1
///
/// queue.addFirst(100); // autorun prints 100
/// ```
class ObservableQueue<T> extends ListQueue<T>
    with
        // ignore: prefer_mixin
        Queue<T>
    implements
        Listenable<QueueChange<T>> {
  ObservableQueue({ReactiveContext? context, String? name})
      : this._wrap(context, _observableQueueAtom<T>(context, name), Queue<T>());

  ObservableQueue.of(Iterable<T> elements,
      {ReactiveContext? context, String? name})
      : this._wrap(context, _observableQueueAtom<T>(context, name),
            Queue<T>.of(elements));

  ObservableQueue._wrap(ReactiveContext? context, this._atom, this._queue)
      : _context = context ?? mainContext;

  final ReactiveContext _context;
  final Atom _atom;
  final Queue<T> _queue;

  Listeners<QueueChange<T>>? _listenersField;

  Listeners<QueueChange<T>> get _listeners =>
      _listenersField ??= Listeners(_context);

  /// The name used to identify for debugging purposes
  String get name => _atom.name;

  @override
  int get length {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.length;
  }

  void _notifyAdd(T value, [int index = 0]) {
    _atom.reportChanged();
    _reportAdd(value, index);
  }

  void _reportAdd(T value, [int index = 0]) {
    _listeners.notifyListeners(QueueChange(queue: this, elementChanges: [
      QueueElementChange(index: index, oldValue: null, newValue: value)
    ]));
  }

  void _notifyRemove(T value, [int index = 0]) {
    _atom.reportChanged();
    _reportRemove(value, index);
  }

  void _reportRemove(T? value, int index) {
    _listeners.notifyListeners(QueueChange(queue: this, elementChanges: [
      QueueElementChange(
          index: index,
          type: OperationType.remove,
          newValue: null,
          oldValue: value)
    ]));
  }

  @override
  void add(T value) {
    _context.conditionallyRunInAction(() {
      final index = _queue.length;
      _queue.add(value);
      _notifyAdd(value, index);
    }, _atom);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _context.conditionallyRunInAction(() {
      if (iterable.isNotEmpty) {
        final index = _queue.length;
        _queue.addAll(iterable);

        _notifyRangeUpdate(index, iterable.toList(growable: false), null);
      }
    }, _atom);
  }

  @override
  Iterator<T> get iterator => ObservableIterator(_atom, _queue.iterator);

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.lastWhere(test, orElse: orElse);
  }

  @override
  T get single {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.single;
  }

  @override
  List<T> toList({bool growable = true}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.toList(growable: growable);
  }

  @override
  void clear() {
    _context.conditionallyRunInAction(() {
      if (_queue.isNotEmpty) {
        final oldItems = _queue.toList(growable: false);
        _queue.clear();
        _notifyRangeUpdate(0, null, oldItems);
      }
    }, _atom);
  }

  @override
  bool remove(Object? value) {
    var didRemove = false;

    _context.conditionallyRunInAction(() {
      for (var i = _queue.length - 1; i >= 0; --i) {
        final element = _queue.elementAt(i);
        if (element == value) {
          _queue.remove(value as T);
          _notifyRemove(value, i);
          didRemove = true;
        }
      }
    }, _atom);

    return didRemove;
  }

  @override
  T removeLast() {
    late T value;

    _context.conditionallyRunInAction(() {
      value = _queue.removeLast();
      // Index is _queue.length as it points to the index before the last element is removed
      _notifyRemove(value, _queue.length);
    }, _atom);

    return value;
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _context.conditionallyRunInAction(() {
      final removedElements = Queue<QueueElementChange<T>>();
      for (var i = _queue.length - 1; i >= 0; --i) {
        final element = _queue.elementAt(i);
        if (test(element)) {
          removedElements.addFirst(QueueElementChange(
              index: i, oldValue: element, type: OperationType.remove));
        }
      }
      _queue.removeWhere(test);
      if (removedElements.isNotEmpty) {
        _notifyElementsUpdate(removedElements.toList(growable: false));
      }
    }, _atom);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _context.conditionallyRunInAction(() {
      final removedElements = Queue<QueueElementChange<T>>();
      for (var i = _queue.length - 1; i >= 0; --i) {
        final element = _queue.elementAt(i);
        if (!test(element)) {
          removedElements.addFirst(QueueElementChange(
              index: i, oldValue: element, type: OperationType.remove));
        }
      }
      _queue.retainWhere(test);
      if (removedElements.isNotEmpty) {
        _notifyElementsUpdate(removedElements.toList(growable: false));
      }
    }, _atom);
  }

  /// Attaches a listener to changes happening in the [ObservableQueue]. You have
  /// the option to be notified immediately ([fireImmediately]) or wait for until the first change.
  @override
  Dispose observe(Listener<QueueChange<T>> listener,
      {bool fireImmediately = false}) {
    final dispose = _listeners.add(listener);
    if (fireImmediately == true) {
      _queue.forEach(_reportAdd);
    }
    return dispose;
  }

  @override
  void addFirst(T value) {
    _context.conditionallyRunInAction(() {
      _queue.addFirst(value);
      _notifyAdd(value, 0);
    }, _atom);
  }

  @override
  void addLast(T value) {
    _context.conditionallyRunInAction(() {
      _queue.addLast(value);
      _notifyAdd(value, _queue.length);
    }, _atom);
  }

  @override
  bool contains(Object? element) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.contains(element);
  }

  @override
  T elementAt(int index) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();

    return _queue.elementAt(index);
  }

  @override
  T get first {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.first;
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.firstWhere(test, orElse: orElse);
  }

  @override
  bool get isEmpty {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.isEmpty;
  }

  @override
  bool get isNotEmpty {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.isNotEmpty;
  }

  @override
  T get last {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.last;
  }

  @override
  T removeFirst() {
    late T value;

    _context.conditionallyRunInAction(() {
      value = _queue.removeFirst();
      _notifyRemove(value, 0);
    }, _atom);

    return value;
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.singleWhere(test, orElse: orElse);
  }

  @override
  Set<T> toSet() {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.toSet();
  }

  void _notifyElementsUpdate(final List<QueueElementChange<T>> elementChanges) {
    _atom.reportChanged();

    final change = QueueChange<T>(queue: this, elementChanges: elementChanges);

    _listeners.notifyListeners(change);
  }

  void _notifyRangeUpdate(int index, List<T>? newValues, List<T>? oldValues) {
    _atom.reportChanged();

    final change =
        QueueChange<T>(queue: this, rangeChanges: <QueueRangeChange<T>>[
      QueueRangeChange(index: index, newValues: newValues, oldValues: oldValues)
    ]);

    _listeners.notifyListeners(change);
  }

  @override
  bool any(bool Function(T element) test) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.any(test);
  }

  @override
  Queue<R> cast<R>() =>
      ObservableQueue._wrap(_context, _atom, _queue.cast<R>());

  @override
  bool every(bool Function(T element) test) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.every(test);
  }

  @override
  void forEach(void Function(T element) f) {
    _context.enforceReadPolicy(_atom);

    _atom.reportObserved();
    return _queue.forEach(f);
  }
}

typedef QueueChangeListener<TNotification> = void Function(
    QueueChange<TNotification>);

/// Stores the change in the value of an element with specific [index].
///
/// The value [OperationType.add] of [type] means inserting the element with value
/// [newValue] in the queue.
///
/// The value [OperationType.remove] of [type] means the element with value [oldValue]
/// was removed from the queue.
class QueueElementChange<T> {
  QueueElementChange(
      {required this.index,
      this.type = OperationType.add,
      this.newValue,
      this.oldValue});

  final int index;
  final OperationType type;
  final T? newValue;
  final T? oldValue;
}

/// Stores the change of values in a range of [ObservableQueue] started with specific [index].
///
/// The values of elements in the range were changed if [oldValues] and [newValues] are not null
/// and have the same length.
///
/// The elements were added to the queue if [newValues] is set and not empty, and [oldValues] is
/// null.
///
/// The elements were removed from the queue if [oldValues] is set and not empty, and [newValues]
/// is null.
class QueueRangeChange<T> {
  QueueRangeChange({required this.index, this.newValues, this.oldValues});

  final int index;
  final List<T>? newValues;
  final List<T>? oldValues;
}

enum ElementPosition { first, last }

/// Stores the change related information when items was modified, added or removed from [list].
///
/// The [elementChanges] object stores change mappings for the indexes of changed elements.
/// The [rangeChanges] object stores mappings of the changed ranges to the indexes of the first
/// elements of this ranges.
/// These two objects cannot overlap (cannot contain the same indexes of changed elements), in
/// most cases only one of them will be defined.
class QueueChange<T> {
  QueueChange({required this.queue, this.elementChanges, this.rangeChanges});

  final ObservableQueue<T> queue;
  final List<QueueElementChange<T>>? elementChanges;
  final List<QueueRangeChange<T>>? rangeChanges;
}

/// Used during testing for wrapping a regular `Queue<T>` as an `ObservableQueue<T>`
@visibleForTesting
ObservableQueue<T> wrapInObservableQueue<T>(Atom atom, Queue<T> queue) =>
    ObservableQueue._wrap(mainContext, atom, queue);
