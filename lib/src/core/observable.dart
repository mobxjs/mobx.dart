import 'package:mobx/src/core/atom_derivation.dart';
import 'package:mobx/src/interceptable.dart';
import 'package:mobx/src/listenable.dart';

class ObservableValue<T> extends Atom implements Listenable, Interceptable {
  T _value;

  ObservableValue(T value, {String name}) : super(name) {
    this.name = name ?? 'Observable@${ctx.nextId}';
    this._value = value;
  }

  T get value {
    reportObserved();
    return _value;
  }

  set value(T value) {
    final oldValue = _value;
    final newValue = _prepareNewValue(value);

    if (newValue == WillChangeNotification.UNCHANGED) {
      return;
    }

    _value = newValue as T;

    reportChanged();

    if (hasListeners(this)) {
      final change = ChangeNotification<T>(
          newValue: value, oldValue: oldValue, type: 'update', object: this);
      notifyListeners<T>(this, change);
    }
  }

  dynamic _prepareNewValue(T newValue) {
    if (hasInterceptors(this)) {
      final change = interceptChange(
          this,
          WillChangeNotification(
              newValue: newValue, type: 'update', object: this));

      if (change == null) {
        return WillChangeNotification.UNCHANGED;
      }

      newValue = change.newValue;
    }

    return (newValue != _value) ? newValue : WillChangeNotification.UNCHANGED;
  }

  // Listenable ------
  @override
  List<Function> changeListeners;

  @override
  Function observe<T>(void Function(ChangeNotification<T>) handler,
      {bool fireImmediately}) {
    if (fireImmediately == true) {
      handler(ChangeNotification<T>(
          type: 'update', newValue: _value as T, oldValue: null, object: this));
    }

    return registerListener(this, handler);
  }

  // Interceptable ----------
  @override
  List<Function> interceptors;

  @override
  Function intercept<T>(
      WillChangeNotification<T> Function(WillChangeNotification<T>) handler) {
    return registerInterceptor(this, handler);
  }
}
