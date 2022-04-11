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