part of '../extensions.dart';

extension IntExtension on int {
  /// turns an int into ObservableInt
  ObsInt obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension BoolExtension on bool {
  /// turns a bool into ObservableBool
  ObsBool obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension ObservableBoolExtension on ObsBool {
  /// lets you toggle the internal value of ObservableBool
  void toggle() {
    runInAction(() => value = !value);
  }
}

extension DoubleExtension on double {
  /// turns a double into ObservableDouble
  ObsDouble obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension StringExtension on String {
  /// turns a String into ObservableString
  ObsString obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}