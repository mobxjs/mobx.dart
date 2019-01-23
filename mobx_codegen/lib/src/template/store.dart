import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/rows.dart';

class StoreTemplate {
  String mixinName;
  String parentName;

  final Rows<ObservableTemplate> observables = Rows();
  final Rows<ComputedTemplate> computeds = Rows();
  final Rows<ActionTemplate> actions = Rows();

  String _actionControllerName;
  String get actionControllerName =>
      _actionControllerName ??= '_\$${parentName}ActionController';

  String get _actionControllerField => actions.isEmpty
      ? ''
      : "final $actionControllerName = ActionController(name: '${parentName}');";

  @override
  String toString() => """
  mixin $mixinName on $parentName, Store {
    $computeds

    $observables

    $_actionControllerField

    $actions
  }""";
}
