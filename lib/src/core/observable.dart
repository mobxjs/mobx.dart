import 'package:mobx/src/core/atom.dart';
import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/interceptable.dart';
import 'package:mobx/src/listenable.dart';
import 'package:mobx/src/utils.dart';

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
