import 'package:mobx/src/core/atom.dart';
import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/interceptable.dart';
import 'package:mobx/src/listenable.dart';

class ObservableValue<T> extends Atom
    implements Listenable<T>, Interceptable<T> {
  ObservableValue(T value, {String name}) : super(name) {
    this.name = name ?? 'Observable@${ctx.nextId}';
    _value = value;
  }

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

    if (hasListeners(this)) {
      final change = ChangeNotification<T>(
          newValue: value,
          oldValue: oldValue,
          type: OperationType.update,
          object: this);
      notifyListeners(this, change);
    }
  }

  dynamic _prepareNewValue(T newValue) {
    var prepared = newValue;
    if (hasInterceptors(this)) {
      final change = interceptChange(
          this,
          WillChangeNotification(
              newValue: prepared, type: OperationType.update, object: this));

      if (change == null) {
        return WillChangeNotification.unchanged;
      }

      prepared = change.newValue;
    }

    return (prepared != _value) ? prepared : WillChangeNotification.unchanged;
  }

  // Listenable ----------

  @override
  List<Listener<T>> changeListeners;

  @override
  Function observe(Listener<T> listener, {bool fireImmediately}) {
    if (fireImmediately == true) {
      listener(ChangeNotification<T>(
          type: OperationType.update,
          newValue: _value,
          oldValue: null,
          object: this));
    }

    return registerListener(this, listener);
  }

  // Interceptable ----------

  @override
  List<Interceptor<T>> interceptors;

  @override
  Function intercept(
          WillChangeNotification<T> Function(WillChangeNotification<T>)
              handler) =>
      registerInterceptor(this, handler);
}
