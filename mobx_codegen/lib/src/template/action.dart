import 'package:mobx_codegen/src/template/annotations_generator_mixin.dart';
import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/store.dart';

class ActionTemplate with AnnotationsGenerator {
  ActionTemplate({
    required this.storeTemplate,
    required this.method,
    required bool hasProtected,
    required bool hasVisibleForOverriding,
    required bool hasVisibleForTesting,
  }) {
    this.hasProtected = hasProtected;
    this.hasVisibleForOverriding = hasVisibleForOverriding;
    this.hasVisibleForTesting = hasVisibleForTesting;
  }

  final StoreTemplate storeTemplate;
  final MethodOverrideTemplate method;

  @override
  String toString() => """
    $annotations
    ${method.returnType} ${method.name}${method.typeParams}(${method.params}) {
      final _\$actionInfo = ${storeTemplate.actionControllerName}.startAction(name: '${storeTemplate.parentTypeName}.${method.name}${method.typeParams}');
      try {
        return super.${method.name}${method.typeArgs}(${method.args});
      } finally {
        ${storeTemplate.actionControllerName}.endAction(_\$actionInfo);
      }
    }""";
}
