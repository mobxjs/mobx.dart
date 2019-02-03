import 'package:mobx_codegen/src/template/method_override.dart';

class ObservableStreamTemplate {
  MethodOverrideTemplate method;

  @override
  String toString() => """
  @override
  ObservableStream${method.returnTypeArgs} ${method.name}${method.typeParams}(${method.params}) {
    final _\$stream = super.${method.name}${method.typeArgs}(${method.args});
    return ObservableStream${method.returnTypeArgs}(_\$stream);
  }""";
}
