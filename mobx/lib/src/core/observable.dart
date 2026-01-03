part of '../core.dart';

class Observable<T> extends Atom
    implements
        Interceptable<T>,
        Listenable<ChangeNotification<T>>,
        ObservableValue<T> {
  /// Create an observable value with an [initialValue] and an optional [name]
  ///
  /// Observable values are tracked inside MobX. When a reaction uses them
  /// they are implicitly added as a dependency of the reaction. When its value changes
  /// the linked reaction is re-triggered.
  ///
  /// An Observable's value is read with the `value` property.
  ///
  /// It is possible to override equality comparison of new values with [equals].
  ///
  /// ```
  /// var x = Observable(10);
  /// var message = Observable('hello');
  ///
  /// print('x = ${x.value}'); // read an Observable's value
  /// ```
  factory Observable(
    T initialValue, {
    String? name,
    ReactiveContext? context,
    EqualityComparer<T>? equals,
  }) => Observable._(
    context ?? mainContext,
    initialValue,
    name: name,
    equals: equals,
  );

  Observable._(super.context, this._value, {String? name, this.equals})
    : _interceptors = Interceptors(context),
      _listeners = Listeners(context),
      super._(name: name ?? context.nameFor('Observable')) {
    if (_context.isSpyEnabled) {
      _context.spyReport(
        ObservableValueSpyEvent(
          this,
          newValue: _value,
          name: this.name,
          isEnd: true,
        ),
      );
    }
  }

  final Interceptors<T> _interceptors;
  final Listeners<ChangeNotification<T>> _listeners;
  final EqualityComparer<T>? equals;

  T _value;

  @override
  T get value {
    _context.enforceReadPolicy(this);

    reportObserved();
    return _value;
  }

  T get nonObservableValue => _value;

  set value(T value) {
    _context.enforceWritePolicy(this);

    final oldValue = _value;
    final newValueDynamic = _prepareNewValue(value);

    if (newValueDynamic is WillChangeNotification &&
        newValueDynamic == WillChangeNotification.unchanged) {
      return;
    }
    final newValue = newValueDynamic as T;

    final notifySpy = _context.isSpyEnabled;

    if (notifySpy) {
      _context.spyReport(
        ObservableValueSpyEvent(
          this,
          newValue: newValue,
          oldValue: oldValue,
          name: name,
        ),
      );
    }

    _value = newValue;

    reportChanged();

    if (_listeners.hasHandlers) {
      final change = ChangeNotification<T>(
        newValue: value,
        oldValue: oldValue,
        type: OperationType.update,
        object: this,
      );
      _listeners.notifyListeners(change);
    }

    if (notifySpy) {
      _context.spyReport(EndedSpyEvent(type: 'observable', name: name));
    }
  }

  dynamic _prepareNewValue(T newValue) {
    T? prepared = newValue;
    if (_interceptors.hasHandlers) {
      final change = _interceptors.interceptChange(
        WillChangeNotification(
          newValue: prepared,
          type: OperationType.update,
          object: this,
        ),
      );

      if (change == null) {
        return WillChangeNotification.unchanged;
      }

      prepared = change.newValue;
    }

    final areEqual =
        equals == null ? equatable(prepared, value) : equals!(prepared, _value);

    return (!areEqual) ? prepared : WillChangeNotification.unchanged;
  }

  @override
  Dispose observe(
    Listener<ChangeNotification<T>> listener, {
    bool fireImmediately = false,
  }) {
    if (fireImmediately == true) {
      listener(
        ChangeNotification<T>(
          type: OperationType.update,
          newValue: _value,
          oldValue: null,
          object: this,
        ),
      );
    }

    return _listeners.add(listener);
  }

  @override
  Dispose intercept(Interceptor<T> interceptor) =>
      _interceptors.add(interceptor);

  @override
  String toString() =>
      'Observable<$T>(name: $name, identity: ${identityHashCode(this)})';
}
