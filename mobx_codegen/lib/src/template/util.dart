
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mobx_codegen/src/template/params.dart';
import 'package:mobx_codegen/src/type_names.dart';
import 'package:source_gen/source_gen.dart';

// ignore: avoid_annotating_with_dynamic
String surroundNonEmpty(String prefix, String suffix, dynamic content) {
  final contentStr = content.toString();
  return contentStr.isEmpty ? '' : '$prefix$contentStr$suffix';
}

const _streamChecker = TypeChecker.fromRuntime(Stream);

class AsyncMethodChecker {
  AsyncMethodChecker([TypeChecker? checkStream]) {
    _checkStream = checkStream ?? _streamChecker;
  }

  late TypeChecker _checkStream;

  // ignore: deprecated_member_use
  bool returnsFuture(MethodElement method) =>
      method.returnType.isDartAsyncFuture ||
      (method.isAsynchronous &&
          !method.isGenerator &&
          method.returnType is DynamicType);

  // ignore: deprecated_member_use
  bool returnsStream(MethodElement method) =>
      _checkStream.isAssignableFromType(method.returnType) ||
      (method.isAsynchronous &&
          method.isGenerator &&
          method.returnType is DynamicType);
}

TypeParamTemplate typeParamTemplate(
  // ignore: deprecated_member_use
  TypeParameterElement param,
  LibraryScopedNameFinder typeNameFinder,
) =>
    TypeParamTemplate(
        name: param.name,
        bound: param.bound != null
            ? typeNameFinder.findTypeParameterBoundsTypeName(param)
            : null);
