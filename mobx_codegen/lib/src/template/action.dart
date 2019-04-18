import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/store.dart';

class ActionTemplate {
  StoreTemplate storeTemplate;
  MethodOverrideTemplate method;

  @override
  String toString() => """
    @override
    ${method.returnType} ${method.name}${method.typeParams}(${method.params}) {
      final _\$actionInfo = ${storeTemplate.actionControllerName}.startAction();
      try {
        return super.${method.name}${method.typeArgs}(${method.args});
      } finally {
        ${storeTemplate.actionControllerName}.endAction(_\$actionInfo);
      }
    }""";
}
