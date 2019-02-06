import 'package:mobx_codegen/src/template/method_override.dart';

class AsyncActionTemplate {
  bool isObservable;
  MethodOverrideTemplate method;

  String get _actionField => '_\$${method.name}AsyncAction';

  String get _futureType => isObservable ? 'ObservableFuture' : 'Future';

  String get _methodCall =>
      '${_actionField}.run(() => super.${method.name}${method.typeArgs}(${method.args}))';

  String get _wrappedMethodCall => isObservable
      ? 'ObservableFuture${method.returnTypeArgs}($_methodCall)'
      : _methodCall;

  @override
  String toString() => """
    final ${_actionField} = AsyncAction('${method.name}');

    @override
    ${_futureType}${method.returnTypeArgs} ${method.name}${method.typeParams}(${method.params}) {
      return $_wrappedMethodCall;
    }""";
}
