import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mockito/mockito.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

class MockTypeChecker extends Mock implements TypeChecker {}

class MockMethod extends Mock implements MethodElement {}

class MockType extends Mock implements DartType {}

MockMethod mockFutureMethod({
  bool returnsDynamic = false,
  bool returnsFuture = false,
  bool returnsFutureOr = false,
  bool isAsync = false,
  bool isGenerator = false,
}) {
  final returnType = MockType();
  when(returnType.isDynamic).thenReturn(returnsDynamic);
  when(returnType.isDartAsyncFuture).thenReturn(returnsFuture);
  when(returnType.isDartAsyncFutureOr).thenReturn(returnsFutureOr);

  final method = MockMethod();
  when(method.returnType).thenReturn(returnType);
  when(method.isAsynchronous).thenReturn(isAsync);
  when(method.isGenerator).thenReturn(isGenerator);
  return method;
}

MockMethod mockStreamMethod({
  bool isAsync = false,
  bool isGenerator = false,
  bool returnsDynamic = false,
}) {
  final returnType = MockType();
  when(returnType.isDynamic).thenReturn(returnsDynamic);

  final method = MockMethod();
  when(method.returnType).thenReturn(returnType);
  when(method.isAsynchronous).thenReturn(isAsync);
  when(method.isGenerator).thenReturn(isGenerator);
  return method;
}

MockTypeChecker streamChecker({bool isStream = false}) {
  final checker = MockTypeChecker();
  when(checker.isAssignableFromType(any)).thenReturn(isStream);
  return checker;
}

void main() {
  group('AsyncMethodChecker', () {
    group('returnsFuture', () {
      test('true if returns Future', () {
        final method = mockFutureMethod(returnsFuture: true);
        expect(AsyncMethodChecker().returnsFuture(method), isTrue);
      });

      test('false if returns FutureOr', () {
        final method = mockFutureMethod(returnsFutureOr: true);
        expect(AsyncMethodChecker().returnsFuture(method), isFalse);
      });

      test('true if method is async and returns dynamic', () {
        final method = mockFutureMethod(
            isAsync: true, isGenerator: false, returnsDynamic: true);
        expect(AsyncMethodChecker().returnsFuture(method), isTrue);
      });

      test('false if method is async generator', () {
        final method = mockFutureMethod(
            isAsync: true, isGenerator: true, returnsDynamic: true);
        expect(AsyncMethodChecker().returnsFuture(method), isFalse);
      });
    });

    group('returnsStream', () {
      test('true if returns Stream', () {
        expect(
            AsyncMethodChecker(streamChecker(isStream: true))
                .returnsStream(MockMethod()),
            isTrue);
      });

      test('true if is async generator and returns dynamic', () {
        final checker = AsyncMethodChecker(streamChecker(isStream: false));
        expect(
            checker.returnsStream(mockStreamMethod(
                isAsync: true, isGenerator: true, returnsDynamic: true)),
            isTrue);
      });
    });
  });
}
