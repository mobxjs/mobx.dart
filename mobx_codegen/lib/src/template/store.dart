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
  String publicTypeName;
  String parentTypeName;

  final Rows<ObservableTemplate> observables = Rows();
  final Rows<ComputedTemplate> computeds = Rows();
  final Rows<ActionTemplate> actions = Rows();
  final Rows<AsyncActionTemplate> asyncActions = Rows();
  final Rows<ObservableFutureTemplate> observableFutures = Rows();
  final Rows<ObservableStreamTemplate> observableStreams = Rows();
  final List<String> toStringList = [];

  bool generateToString = false;
  String _actionControllerName;
  String get actionControllerName =>
      _actionControllerName ??= '_\$${parentTypeName}ActionController';

  String get actionControllerField => actions.isEmpty
      ? ''
      : "final $actionControllerName = ActionController(name: '$parentTypeName');";

  String get storeBody {
    var toStringMethod = '';
    final baseBody = '''
  $computeds

  $observables

  $observableFutures

  $observableStreams

  $asyncActions

  $actionControllerField

  $actions''';

    if (generateToString) {
      for(var i = 0; i < observables.templates.length; i++){
        final ObservableTemplate current =  observables.templates[i];
        toStringList.add('${current.name}: \${${current.name}.toString()}');
      }

      for(var i = 0; i < computeds.templates.length; i++){
        final ComputedTemplate current =  computeds.templates[i];
        toStringList.add('${current.name}: \${${current.name}.toString()}');
      }

      toStringMethod = '''
  @override
  String toString() {
    final toStringList = [${toStringList.sublist(1).fold("'${toStringList[0]}'", (curr, next) => "$curr, '$next'")}];
    final string = toStringList.reduce((curr, next) => '\$curr, \$next');
    return '{\$string}';
  }
  ''';
    }

    return baseBody + toStringMethod;
  }

  @override
  String toString();
}
