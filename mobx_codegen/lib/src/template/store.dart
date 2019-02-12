import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/async_action.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/observable_future.dart';
import 'package:mobx_codegen/src/template/observable_stream.dart';
import 'package:mobx_codegen/src/template/rows.dart';

class StoreTemplate {
  String mixinName;
  String parentName;

  final Rows<ObservableTemplate> observables = Rows();
  final Rows<ComputedTemplate> computeds = Rows();
  final Rows<ActionTemplate> actions = Rows();
  final Rows<AsyncActionTemplate> asyncActions = Rows();
  final Rows<ObservableFutureTemplate> observableFutures = Rows();
  final Rows<ObservableStreamTemplate> observableStreams = Rows();

  String _actionControllerName;
  String get actionControllerName =>
      _actionControllerName ??= '_\$${parentName}ActionController';

  String get _actionControllerField => actions.isEmpty
      ? ''
      : "final $actionControllerName = ActionController(name: '${parentName}');";

  @override
  String toString() => """
  // ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

  mixin $mixinName on $parentName, Store {
    $computeds

    $observables

    $observableFutures

    $observableStreams

    $asyncActions

    $_actionControllerField

    $actions
  }""";
}
