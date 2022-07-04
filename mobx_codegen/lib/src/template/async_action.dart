import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/params.dart';
import 'package:mobx_codegen/src/template/store.dart';

class AsyncActionTemplate {
  AsyncActionTemplate(
      {required this.storeTemplate,
      required this.isObservable,
      required this.method});

  final StoreTemplate storeTemplate;
  final bool isObservable;
  final MethodOverrideTemplate method;

  String get _actionField => '_\$${method.name}AsyncAction';

  String get _futureType => isObservable ? 'ObservableFuture' : 'Future';

  String get _methodCall =>
      // ignore: unnecessary_brace_in_string_interps
      '${_actionField}.run(() => super.${method.name}${method.typeArgs}(${method.args}))';

  String get _wrappedMethodCall => isObservable
      ? 'ObservableFuture${method.returnTypeArgs}($_methodCall)'
      : _methodCall;

  String get _newBehavior {
    bool? isNewBehavior;

    for (final list in method.params.templates) {
      for (final ParamTemplate param in list.templates) {
        if (param.name == '\$newBehavior') {
          isNewBehavior = param.defaultValue == 'true';

          break;
        }
      }

      if (isNewBehavior != null) break;
    }

    if (isNewBehavior == true) {
      return ', newBehavior: $isNewBehavior';
    }

    return '';
  }

  @override
  String toString() => """
  late final $_actionField = AsyncAction('${storeTemplate.parentTypeName}.${method.name}', context: context$_newBehavior);

  @override
  $_futureType${method.returnTypeArgs} ${method.name}${method.typeParams}(${method.params}) {
    return $_wrappedMethodCall;
  }""";
}
