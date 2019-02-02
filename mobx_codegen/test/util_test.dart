import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMethod extends Mock implements MethodElement {}

class MockType extends Mock implements DartType {}

MockMethod mockMethod({
  bool returnsVoid = false,
  bool returnsFuture = false,
  bool returnsFutureOr = false,
  bool isAsync = false,
  bool isGenerator = false,
}) {
  final returnType = MockType();
  when(returnType.isVoid).thenReturn(returnsVoid);
  when(returnType.isDartAsyncFuture).thenReturn(returnsFuture);
  when(returnType.isDartAsyncFutureOr).thenReturn(returnsFutureOr);

  final method = MockMethod();
  when(method.returnType).thenReturn(returnType);
  when(method.isAsynchronous).thenReturn(isAsync);
  when(method.isGenerator).thenReturn(isGenerator);
  return method;
}

void main() {
  group('returnsFuture', () {
    test('should return false if element.returnType.isVoid is true', () {
      final method =
          mockMethod(returnsVoid: true, isAsync: true, isGenerator: false);
      expect(returnsFuture(method), isFalse);
    });

    test('should return true if element.returnType.isDartAsyncFuture is true',
        () {
      final method = mockMethod(returnsFuture: true);
      expect(returnsFuture(method), isTrue);
    });

    test('should return true if element.returnType.isDartAsyncFutureOr is true',
        () {
      final method = mockMethod(returnsFutureOr: true);
      expect(returnsFuture(method), isTrue);
    });

    test('should return true if element is async and not a generator', () {
      final method = mockMethod(isAsync: true);
      expect(returnsFuture(method), isTrue);
    });

    test('should return false if element is async and a generator', () {
      final method = mockMethod(isAsync: true, isGenerator: true);
      expect(returnsFuture(method), isFalse);
    });

    test('should return false if no matches', () {
      final method = mockMethod();
      expect(returnsFuture(method), isFalse);
    });
  });
}
