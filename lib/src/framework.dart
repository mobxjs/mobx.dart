import 'package:meta/meta.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:mobx/src/interceptable.dart';
import 'package:mobx/src/listenable.dart';
import 'package:mobx/src/utils.dart';

class MobXException implements Exception {
  MobXException(this.message);

  String message;
}

enum OperationType { add, update, delete }

class WillChangeNotification<T> {
  WillChangeNotification({this.type, this.newValue, this.object});

  /// One of add | update | delete
  final OperationType type;

  T newValue;
  final dynamic object;

  static WillChangeNotification unchanged = WillChangeNotification();
}

class ChangeNotification<T> {
  ChangeNotification({this.type, this.newValue, this.oldValue, this.object});

  /// One of add | update | delete
  final OperationType type;

  final T oldValue;
  T newValue;

  dynamic object;
}

enum DerivationState {
  // before being run or (outside batch and not being observed)
  // at this point derivation is not holding any data about dependency tree
  notTracking,

  // no shallow dependency changed since last computation
  // won't recalculate derivation
  // this is what makes mobx fast
  upToDate,

  // some deep dependency changed, but don't know if shallow dependency changed
  // will require to check first if UP_TO_DATE or POSSIBLY_STALE
  // currently only ComputedValue will propagate POSSIBLY_STALE
  //
  // having this state is second big optimization:
  // don't have to recompute on every dependency change, but only when it's needed
  possiblyStale,

  // A shallow dependency has changed since last computation and the derivation
  // will need to recompute when it's needed next.
  stale
}

abstract class Derivation {
  String get name;
  Set<Atom> observables;
  Set<Atom> newObservables;

  DerivationState dependenciesState;

  void onBecomeStale();
  void suspend();
}

class _ReactiveState {
  int batch = 0;

  int nextIdCounter = 0;

  Derivation trackingDerivation;
  List<Reaction> pendingReactions = [];
  bool isRunningReactions = false;
  List<Atom> pendingUnobservations = [];
}

class ReactiveContext {
  final _ReactiveState _state = _ReactiveState();

  int get nextId => ++_state.nextIdCounter;

  String nameFor(String prefix) {
    assert(prefix != null);
    assert(prefix.isNotEmpty);
    return '$prefix@$nextId';
  }

  void startBatch() {
    _state.batch++;
  }

  void endBatch() {
    if (--_state.batch == 0) {
      runReactions();

      for (var i = 0; i < _state.pendingUnobservations.length; i++) {
        final ob = _state.pendingUnobservations[i]
          ..isPendingUnobservation = false;

        if (ob.observers.isEmpty) {
          if (ob.isBeingObserved) {
            // if this observable had reactive observers, trigger the hooks
            ob
              ..isBeingObserved = false
              ..notifyOnBecomeUnobserved();
          }

          if (ob is ComputedValue) {
            ob.suspend();
          }
        }
      }

      _state.pendingUnobservations = [];
    }
  }

  Derivation startTracking(Derivation derivation) {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = derivation;

    resetDerivationState(derivation);
    derivation.newObservables = Set();

    return prevDerivation;
  }

  void endTracking(Derivation currentDerivation, Derivation prevDerivation) {
    _state.trackingDerivation = prevDerivation;
    bindDependencies(currentDerivation);
  }

  T trackDerivation<T>(Derivation d, T Function() fn) {
    final prevDerivation = startTracking(d);
    final result = fn();
    endTracking(d, prevDerivation);
    return result;
  }

  void reportObserved(Atom atom) {
    final derivation = _state.trackingDerivation;

    if (derivation != null) {
      derivation.newObservables.add(atom);
      if (!atom.isBeingObserved) {
        atom
          ..isBeingObserved = true
          ..notifyOnBecomeObserved();
      }
    }
  }

  void bindDependencies(Derivation derivation) {
    final staleObservables =
        derivation.observables.difference(derivation.newObservables);
    final newObservables =
        derivation.newObservables.difference(derivation.observables);
    var lowestNewDerivationState = DerivationState.upToDate;

    // Add newly found observables
    for (final observable in newObservables) {
      observable.addObserver(derivation);

      // ComputedValue = ObservableValue + Derivation
      if (observable is ComputedValue) {
        if (observable.dependenciesState.index >
            lowestNewDerivationState.index) {
          lowestNewDerivationState = observable.dependenciesState;
        }
      }
    }

    // Remove previous observables
    for (final ob in staleObservables) {
      ob.removeObserver(derivation);
    }

    if (lowestNewDerivationState != DerivationState.upToDate) {
      derivation
        ..dependenciesState = lowestNewDerivationState
        ..onBecomeStale();
    }

    derivation
      ..observables = derivation.newObservables
      ..newObservables = Set(); // No need for newObservables beyond this point
  }

  void addPendingReaction(Reaction reaction) {
    _state.pendingReactions.add(reaction);
  }

  void runReactions() {
    if (_state.batch > 0 || _state.isRunningReactions) {
      return;
    }

    _state.isRunningReactions = true;

    for (final reaction in _state.pendingReactions) {
      reaction.run();
    }

    _state
      ..pendingReactions = []
      ..isRunningReactions = false;
  }

  void propagateChanged(Atom atom) {
    if (atom.lowestObserverState == DerivationState.stale) {
      return;
    }

    atom.lowestObserverState = DerivationState.stale;

    for (final observer in atom.observers) {
      if (observer.dependenciesState == DerivationState.upToDate) {
        observer.onBecomeStale();
      }
      observer.dependenciesState = DerivationState.stale;
    }
  }

  void propagatePossiblyChanged(Atom atom) {
    if (atom.lowestObserverState != DerivationState.upToDate) {
      return;
    }

    atom.lowestObserverState = DerivationState.possiblyStale;

    for (final observer in atom.observers) {
      if (observer.dependenciesState == DerivationState.upToDate) {
        observer
          ..dependenciesState = DerivationState.possiblyStale
          ..onBecomeStale();
      }
    }
  }

  void propagateChangeConfirmed(Atom atom) {
    if (atom.lowestObserverState == DerivationState.stale) {
      return;
    }

    atom.lowestObserverState = DerivationState.stale;

    for (final observer in atom.observers) {
      if (observer.dependenciesState == DerivationState.possiblyStale) {
        observer.dependenciesState = DerivationState.stale;
      } else if (observer.dependenciesState == DerivationState.upToDate) {
        atom.lowestObserverState = DerivationState.upToDate;
      }
    }
  }

  void clearObservables(Derivation derivation) {
    final observables = derivation.observables;
    derivation.observables = Set();

    for (final x in observables) {
      x.removeObserver(derivation);
    }

    derivation.dependenciesState = DerivationState.notTracking;
  }

  void enqueueForUnobservation(Atom atom) {
    if (atom.isPendingUnobservation) {
      return;
    }

    atom.isPendingUnobservation = true;
    _state.pendingUnobservations.add(atom);
  }

  void resetDerivationState(Derivation d) {
    if (d.dependenciesState == DerivationState.upToDate) {
      return;
    }

    d.dependenciesState = DerivationState.upToDate;
    for (final obs in d.observables) {
      obs.lowestObserverState = DerivationState.upToDate;
    }
  }

  bool shouldCompute(Derivation derivation) {
    switch (derivation.dependenciesState) {
      case DerivationState.upToDate:
        return false;

      case DerivationState.notTracking:
      case DerivationState.stale:
        return true;

      case DerivationState.possiblyStale:
        return untracked(() {
          for (final obs in derivation.observables) {
            if (obs is ComputedValue) {
              // Force a computation
              obs.value;

              if (derivation.dependenciesState == DerivationState.stale) {
                return true;
              }
            }
          }

          resetDerivationState(derivation);
          return false;
        });
    }

    return false;
  }

  bool isInBatch() => _state.batch > 0;

  bool isComputingDerivation() => _state.trackingDerivation != null;

  Derivation untrackedStart() {
    final prevDerivation = _state.trackingDerivation;
    _state.trackingDerivation = null;
    return prevDerivation;
  }

  // ignore: use_setters_to_change_properties
  void untrackedEnd(Derivation prevDerivation) {
    _state.trackingDerivation = prevDerivation;
  }

  T untracked<T>(T Function() action) {
    final prevDerivation = untrackedStart();
    try {
      return action();
    } finally {
      untrackedEnd(prevDerivation);
    }
  }
}

class Reaction implements Derivation {
  Reaction(this._context, Function() onInvalidate, {this.name}) {
    _onInvalidate = onInvalidate;
  }

  final ReactiveContext _context;
  void Function() _onInvalidate;
  bool _isScheduled = false;
  bool _isDisposed = false;
  bool _isRunning = false;

  @override
  String name;

  @override
  Set<Atom> newObservables;

  @override
  Set<Atom> observables = Set();

  @override
  DerivationState dependenciesState = DerivationState.notTracking;

  bool get isDisposed => _isDisposed;

  @override
  void onBecomeStale() {
    schedule();
  }

  @experimental
  Derivation _startTracking() {
    _context.startBatch();
    _isRunning = true;
    return _context.startTracking(this);
  }

  @experimental
  void _endTracking(Derivation previous) {
    _context.endTracking(this, previous);
    _isRunning = false;

    if (_isDisposed) {
      _context.clearObservables(this);
    }

    _context.endBatch();
  }

  void track(void Function() fn) {
    _context.startBatch();

    _isRunning = true;
    _context.trackDerivation(this, fn);
    _isRunning = false;

    if (_isDisposed) {
      _context.clearObservables(this);
    }

    _context.endBatch();
  }

  void run() {
    if (_isDisposed) {
      return;
    }

    _context.startBatch();

    _isScheduled = false;

    if (_context.shouldCompute(this)) {
      _onInvalidate();
    }

    _context.endBatch();
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    if (_isRunning) {
      return;
    }

    _context
      ..startBatch()
      ..clearObservables(this)
      ..endBatch();
  }

  void schedule() {
    if (_isScheduled) {
      return;
    }

    _isScheduled = true;
    _context
      ..addPendingReaction(this)
      ..runReactions();
  }

  @override
  void suspend() {
    // Not applicable right now
  }
}

/// Tracks changes that happen between [start] and [end].
///
/// This should only be used in situations where it is not possible to
/// track changes inside a callback function.
@experimental
class DerivationTracker {
  DerivationTracker(ReactiveContext context, Function() onInvalidate,
      {String name})
      : _reaction = Reaction(context, onInvalidate, name: name);

  final Reaction _reaction;
  Derivation _previousDerivation;

  void start() {
    if (_reaction._isRunning) {
      return;
    }
    _previousDerivation = _reaction._startTracking();
  }

  void end() {
    if (!_reaction._isRunning) {
      return;
    }
    _reaction._endTracking(_previousDerivation);
    _previousDerivation = null;
  }

  void dispose() {
    end();
    _reaction.dispose();
  }
}

enum _ListenerKind {
  onBecomeObserved,
  onBecomeUnobserved,
}

class Atom {
  Atom(this._context, {String name, Function onObserve, Function onUnobserve})
      : name = name ?? _context.nameFor('Atom') {
    if (onObserve != null) {
      onBecomeObserved(onObserve);
    }

    if (onUnobserve != null) {
      onBecomeUnobserved(onUnobserve);
    }
  }

  final ReactiveContext _context;

  final String name;

  bool isPendingUnobservation = false;

  DerivationState lowestObserverState = DerivationState.notTracking;

  bool isBeingObserved = false;

  Set<Derivation> observers = Set();

  final Map<_ListenerKind, Set<Function()>> _observationListeners = {};

  void reportObserved() {
    _context.reportObserved(this);
  }

  void reportChanged() {
    _context
      ..startBatch()
      ..propagateChanged(this)
      ..endBatch();
  }

  void addObserver(Derivation d) {
    observers.add(d);

    if (lowestObserverState.index > d.dependenciesState.index) {
      lowestObserverState = d.dependenciesState;
    }
  }

  void removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
    if (observers.isEmpty) {
      _context.enqueueForUnobservation(this);
    }
  }

  void notifyOnBecomeObserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeObserved];
    listeners?.forEach(_notifyListener);
  }

  static void _notifyListener(Function() listener) => listener();

  void notifyOnBecomeUnobserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeUnobserved];
    listeners?.forEach(_notifyListener);
  }

  void Function() onBecomeObserved(Function fn) =>
      _addListener(_ListenerKind.onBecomeObserved, fn);

  void Function() onBecomeUnobserved(Function fn) =>
      _addListener(_ListenerKind.onBecomeUnobserved, fn);

  void Function() _addListener(_ListenerKind kind, Function fn) {
    if (fn == null) {
      throw MobXException('$kind handler cannot be null');
    }

    if (_observationListeners[kind] == null) {
      _observationListeners[kind] = Set()..add(fn);
    } else {
      _observationListeners[kind].add(fn);
    }

    return () {
      if (_observationListeners[kind] == null) {
        return;
      }

      _observationListeners[kind].removeWhere((f) => f == fn);
      if (_observationListeners[kind].isEmpty) {
        _observationListeners[kind] = null;
      }
    };
  }
}

class Action {
  Action(this._context, this._fn, {String name})
      : name = name ?? _context.nameFor('Action');

  final ReactiveContext _context;

  final Function _fn;

  final String name;

  dynamic call([List args = const [], Map<String, dynamic> namedArgs]) {
    final prevDerivation = _startAction();

    try {
      // Invoke the actual function
      if (namedArgs == null) {
        return Function.apply(_fn, args);
      } else {
        // Convert to symbol-based named-args
        final namedSymbolArgs =
            namedArgs.map((key, value) => MapEntry(Symbol(key), value));
        return Function.apply(_fn, args, namedSymbolArgs);
      }
    } finally {
      _endAction(prevDerivation);
    }
  }

  Derivation _startAction() {
    final prevDerivation = _context.untrackedStart();
    _context.startBatch();

    return prevDerivation;
  }

  void _endAction(Derivation prevDerivation) {
    _context
      ..endBatch()
      ..untrackedEnd(prevDerivation);
  }
}

class ObservableValue<T> extends Atom
    implements Interceptable<T>, Listenable<T> {
  ObservableValue(ReactiveContext context, this._value, {String name})
      : _interceptors = Interceptors(context),
        _listeners = Listeners(context),
        super(context, name: name ?? context.nameFor('Observable'));

  final Interceptors<T> _interceptors;
  final Listeners<T> _listeners;

  T _value;

  T get value {
    reportObserved();
    return _value;
  }

  set value(T value) {
    final oldValue = _value;
    final newValue = _prepareNewValue(value);

    if (newValue == WillChangeNotification.unchanged) {
      return;
    }

    _value = newValue;

    reportChanged();

    if (_listeners.hasListeners) {
      final change = ChangeNotification<T>(
          newValue: value,
          oldValue: oldValue,
          type: OperationType.update,
          object: this);
      _listeners.notifyListeners(change);
    }
  }

  dynamic _prepareNewValue(T newValue) {
    var prepared = newValue;
    if (_interceptors.hasInterceptors) {
      final change = _interceptors.interceptChange(WillChangeNotification(
          newValue: prepared, type: OperationType.update, object: this));

      if (change == null) {
        return WillChangeNotification.unchanged;
      }

      prepared = change.newValue;
    }

    return (prepared != _value) ? prepared : WillChangeNotification.unchanged;
  }

  @override
  Dispose observe(Listener<T> listener, {bool fireImmediately}) {
    if (fireImmediately == true) {
      listener(ChangeNotification<T>(
          type: OperationType.update,
          newValue: _value,
          oldValue: null,
          object: this));
    }

    return _listeners.registerListener(listener);
  }

  @override
  Dispose intercept(Interceptor<T> interceptor) =>
      _interceptors.intercept(interceptor);
}

class ComputedValue<T> extends Atom implements Derivation {
  ComputedValue(ReactiveContext context, this._fn, {String name})
      : super(context, name: name ?? context.nameFor('Computed'));

  @override
  Set<Atom> observables = Set();

  @override
  Set<Atom> newObservables;

  T Function() _fn;

  @override
  DerivationState dependenciesState = DerivationState.notTracking;

  T _value;

  bool _isComputing = false;

  T get value {
    if (_isComputing) {
      throw MobXException('Cycle detected in computation $name: $_fn');
    }

    if (!_context.isInBatch() && observers.isEmpty) {
      if (_context.shouldCompute(this)) {
        _context.startBatch();
        _value = computeValue(track: false);
        _context.endBatch();
      }
    } else {
      reportObserved();
      if (_context.shouldCompute(this)) {
        if (_trackAndCompute()) {
          _context.propagateChangeConfirmed(this);
        }
      }
    }

    return _value;
  }

  T computeValue({bool track}) {
    _isComputing = true;

    T value;
    if (track) {
      value = _context.trackDerivation(this, _fn);
    } else {
      value = _fn();
    }

    _isComputing = false;

    return value;
  }

  @override
  void suspend() {
    _context.clearObservables(this);
    _value = null;
  }

  @override
  void onBecomeStale() {
    _context.propagatePossiblyChanged(this);
  }

  bool _trackAndCompute() {
    final oldValue = _value;
    final wasSuspended = dependenciesState == DerivationState.notTracking;

    final newValue = computeValue(track: true);

    final changed = wasSuspended || !_isEqual(oldValue, newValue);

    if (changed) {
      _value = newValue;
    }

    return changed;
  }

  bool _isEqual(T x, T y) => x == y;

  Function observe(void Function(ChangeNotification<T>) handler,
      {bool fireImmediately}) {
    var firstTime = true;
    T prevValue;

    return autorun((_) {
      final newValue = value;
      if (firstTime == true || fireImmediately == true) {
        _context.untracked(() {
          handler(ChangeNotification(
              type: OperationType.update,
              object: this,
              oldValue: prevValue,
              newValue: newValue));
        });
      }

      firstTime = false;
      prevValue = newValue;
    }, context: _context);
  }
}
