import 'package:meta/meta.dart';
import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/rows.dart';

class StoreTemplate {
  String name;
  String parentName;

  final Rows<ObservableTemplate> observables = Rows();
  final Rows<ComputedTemplate> _computeds = Rows();
  final Rows<ComputedInitTemplate> _computedInitializers = Rows();
  final Rows<ActionTemplate> actions = Rows();

  void addComputed(
      {@required String computedName,
      @required String type,
      @required String name}) {
    _computeds.add(ComputedTemplate()
      ..computedName = computedName
      ..name = name
      ..type = type);

    _computedInitializers.add(ComputedInitTemplate()
      ..computedName = computedName
      ..name = name
      ..type = type);
  }

  String _actionControllerName;
  String get actionControllerName =>
      _actionControllerName ??= '_\$${parentName}ActionController';

  String get _actionControllerField => actions.isEmpty
      ? ''
      : "final $actionControllerName = ActionController(name: '${parentName}');";

  @override
  String toString() => """
  class $name extends $parentName {
    $name() : super._() {
      $_computedInitializers
    }

    $_computeds

    $observables

    $_actionControllerField

    $actions
  }""";
}
