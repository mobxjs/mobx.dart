import 'package:mobx/src/core/base_types.dart';
import 'package:mobx/src/listenable.dart';

class ObservableValue<T> extends Atom implements Listenable {
  T _value;

  ObservableValue(T value, {String name}) : super(name) {
    this.name = name ?? 'Observable@${global.nextId}';
    this._value = value;
  }

  T get value {
    reportObserved();
    return _value;
  }

  set value(T value) {
    var oldValue = _value;
    _value = value;
    reportChanged();

    if (hasListeners(this)) {
      var change = ChangeNotification(
          newValue: value, oldValue: oldValue, type: 'update', object: this);
      notifyListeners(this, change);
    }
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
}
