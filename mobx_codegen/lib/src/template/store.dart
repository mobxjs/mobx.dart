import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/async_action.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/observable_future.dart';
import 'package:mobx_codegen/src/template/observable_stream.dart';
import 'package:mobx_codegen/src/template/params.dart';
import 'package:mobx_codegen/src/template/rows.dart';

class MixinStoreTemplate extends StoreTemplate {
  String get typeName => '_\$$publicTypeName';

  @override
  String toString() => '''
  mixin $typeName$typeParams on $parentTypeName$typeArgs, Store {
    $storeBody
  }''';
}

abstract class StoreTemplate {
  final SurroundedCommaList<TypeParamTemplate> typeParams =
      SurroundedCommaList('<', '>', []);
  final SurroundedCommaList<String> typeArgs =
      SurroundedCommaList('<', '>', []);

  late String publicTypeName;
  late String parentTypeName;

  final Rows<ObservableTemplate> observables = Rows();
  final Rows<ComputedTemplate> computeds = Rows();
  final Rows<ActionTemplate> actions = Rows();
  final Rows<AsyncActionTemplate> asyncActions = Rows();
  final Rows<ObservableFutureTemplate> observableFutures = Rows();
  final Rows<ObservableStreamTemplate> observableStreams = Rows();
  final List<String> toStringList = [];

  bool generateToString = false;
  String? _actionControllerName;
  String get actionControllerName =>
      _actionControllerName ??= '_\$${parentTypeName}ActionController';

  String get actionControllerField => actions.isEmpty
      ? ''
      : "late final $actionControllerName = ActionController(name: '$parentTypeName', context: context);";

  String get toStringMethod {
    if (!generateToString) {
      return '';
    }

    final publicObservablesList = observables.templates
        .where((element) => !element.isPrivate)
        .map((current) => '${current.name}: \${${current.name}}');

    final publicComputedsList = computeds.templates
        .where((element) => !element.isPrivate)
        .map((current) => '${current.name}: \${${current.name}}');

    final allStrings = toStringList
      ..addAll(publicObservablesList)
      ..addAll(publicComputedsList);

    // The indents have been kept to ensure each field comes on a separate line without any tabs/spaces
    return '''
  @override
  String toString() {
    return \'\'\'
${allStrings.join(',\n')}
    \'\'\';
  }
  ''';
  }

  String get storeBody => '''
  $computeds

  $observables

  $observableFutures

  $observableStreams

  $asyncActions

  $actionControllerField

  $actions

  $toStringMethod
  ''';
}
