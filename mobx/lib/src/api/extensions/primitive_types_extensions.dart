part of '../extensions.dart';

/// turns an int into ObservableInt
extension IntExtension on int {
  @Deprecated('Use toObs() instead')
  ObservableInt asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }

  ObservableInt toObs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

/// turns a bool into ObservableBool
extension BoolExtension on bool {
  @Deprecated('Use toObs() instead')
  ObservableBool asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }

  ObservableBool toObs({ReactiveContext? context, String? name}) {
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
  @Deprecated('Use toObs() instead')
  ObservableDouble asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }

  ObservableDouble toObs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

/// turns a String into ObservableString
extension StringExtension on String {
  @Deprecated('Use toObs() instead')
  ObservableString asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }

  ObservableString toObs({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}
