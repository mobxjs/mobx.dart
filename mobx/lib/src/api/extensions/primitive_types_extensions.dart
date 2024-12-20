part of '../extensions.dart';

extension IntExtension on int {
  /// turns an int into Observable
  Observable<int> obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension BoolExtension on bool {
  /// turns a bool into Observable
  Observable<bool> obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension ObservableBoolExtension on Observable<bool> {
  /// lets you toggle the internal value of ObservableBool
  void toggle() {
    runInAction(() => value = !value);
  }
}

extension DoubleExtension on double {
  /// turns a double into Observable
  Observable<double> obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension StringExtension on String {
  /// turns a String into Observable
  Observable<String> obs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}
