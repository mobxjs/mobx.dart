import 'package:analyzer/dart/element/element.dart';

String surroundNonEmpty(String prefix, String suffix, dynamic content) {
  final contentStr = content.toString();
  return contentStr.isEmpty ? '' : '$prefix$contentStr$suffix';
}

bool returnsFuture(MethodElement method) =>
    method.returnType.isDartAsyncFuture ||
    method.returnType.isDartAsyncFutureOr ||
    (method.isAsynchronous && !method.returnType.isVoid && !method.isGenerator);
