import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/store.dart';

class ActionTemplate {
  ActionTemplate({required this.storeTemplate, required this.method});

  final StoreTemplate storeTemplate;
  final MethodOverrideTemplate method;

  @override
  // ignore: prefer_single_quotes
  String toString() => """
    @override
    ${method.returnType} ${method.name}${method.typeParams}(${method.params}) {
      final _\$actionInfo = ${storeTemplate.actionControllerName}.startAction(name: '${storeTemplate.parentTypeName}.${method.name}${method.typeParams}');
      try {
        return super.${method.name}${method.typeArgs}(${method.args});
      } finally {
        ${storeTemplate.actionControllerName}.endAction(_\$actionInfo);
      }
    }""";
}
