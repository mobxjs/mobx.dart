part of '../extensions.dart';

/// turns an int into ObservableInt
extension IntExtension on int {
  ObservableInt asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

/// turns a bool into ObservableBool
extension BoolExtension on bool {
  ObservableBool asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

/// lets you toggle the internal value of ObservableBool
extension ObservableBoolExtension on ObservableBool {
  void toggle() {
    runInAction(() => value = !value);
  }
}

/// turns a double into ObservableDouble
extension DoubleExtension on double {
  ObservableDouble asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

/// turns a String into ObservableString
extension StringExtension on String {
  ObservableString asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}
