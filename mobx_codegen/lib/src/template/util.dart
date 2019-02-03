import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

String surroundNonEmpty(String prefix, String suffix, dynamic content) {
  final contentStr = content.toString();
  return contentStr.isEmpty ? '' : '$prefix$contentStr$suffix';
}

final _streamChecker = TypeChecker.fromRuntime(Stream);

class AsyncMethodChecker {
  AsyncMethodChecker([TypeChecker checkStream]) {
    this._checkStream = checkStream ?? _streamChecker;
  }

  TypeChecker _checkStream;

  bool returnsFuture(MethodElement method) =>
      method.returnType.isDartAsyncFuture ||
      (method.isAsynchronous &&
          !method.isGenerator &&
          method.returnType.isDynamic);

  bool returnsStream(MethodElement method) =>
      _checkStream.isAssignableFromType(method.returnType) ||
      (method.isAsynchronous &&
          method.isGenerator &&
          method.returnType.isDynamic);
}
