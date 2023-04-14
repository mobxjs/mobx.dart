import 'package:mobx_codegen/src/template/annotations_generator_mixin.dart';
import 'package:mobx_codegen/src/template/method_override.dart';

class ObservableFutureTemplate with AnnotationsGenerator {
  ObservableFutureTemplate({
    required this.method,
    required bool hasProtected,
    required bool hasVisibleForOverriding,
    required bool hasVisibleForTesting,
  }) {
    this.hasProtected = hasProtected;
    this.hasVisibleForOverriding = hasVisibleForOverriding;
    this.hasVisibleForTesting = hasVisibleForTesting;
  }

  final MethodOverrideTemplate method;

  @override
  String toString() => """
  $annotations
  ObservableFuture${method.returnTypeArgs} ${method.name}${method.typeParams}(${method.params}) {
    final _\$future = super.${method.name}${method.typeArgs}(${method.args});
    return ObservableFuture${method.returnTypeArgs}(_\$future, context: context);
  }""";
}
