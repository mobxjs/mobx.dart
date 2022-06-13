part of '../extensions.dart';

extension IntExtension on int {
  /// turns an int into ObservableInt
  ObservableInt obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension BoolExtension on bool {
  /// turns a bool into ObservableBool
  ObservableBool obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension ObservableBoolExtension on ObservableBool {
  /// lets you toggle the internal value of ObservableBool
  void toggle() {
    runInAction(() => value = !value);
  }
}

extension DoubleExtension on double {
  /// turns a double into ObservableDouble
  ObservableDouble obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension StringExtension on String {
  /// turns a String into ObservableString
  ObservableString obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}
