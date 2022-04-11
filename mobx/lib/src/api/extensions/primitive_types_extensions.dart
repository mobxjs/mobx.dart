part of '../extensions.dart';


extension IntExtension on int {
  ObservableInt asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

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

extension DoubleExtension on double {
  ObservableDouble asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension StringExtension on String {
  ObservableString asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}
