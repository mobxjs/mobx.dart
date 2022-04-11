part of '../extensions.dart';


extension ObservableIntExtension on int {
  ObservableInt asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension ObservableBoolExtension on bool {
  ObservableBool asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

/// lets you toggle the internal value of ObservableBool
extension ObservableBoolToggle on ObservableBool {
  void toggle() {
    runInAction(() => value = !value);
  }
}

extension ObservableDoubleExtension on double {
  ObservableDouble asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}

extension ObservableStringExtension on String {
  ObservableString asObservable({ReactiveContext? context, String? name}) {
    return Observable(this, context: context, name: name);
  }
}
