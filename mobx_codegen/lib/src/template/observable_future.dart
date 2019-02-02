import 'package:mobx_codegen/src/template/method_override.dart';

class ObservableFutureTemplate {
  MethodOverrideTemplate method;

  @override
  String toString() => """
  @override
  ObservableFuture${method.returnTypeArgs} ${method.name}${method.typeParams}(${method.params}) {
    final _\$future = super.${method.name}${method.typeArgs}(${method.args});
    return ObservableFuture${method.returnTypeArgs}(_\$future);
  }""";
}
