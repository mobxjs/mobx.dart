// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mobx_codegen/src/utils/non_private_name_extension.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

class MockTypeChecker extends Mock implements TypeChecker {}

class MockMethod extends Mock implements MethodElement2 {}

class MockMethodFragment extends Mock implements MethodFragment {}

class MockType extends Mock implements DartType {}

class DynamicMockType extends Mock implements DynamicType {}

MockMethod mockFutureMethod({
  bool returnsDynamic = false,
  bool returnsFuture = false,
  bool returnsFutureOr = false,
  bool isAsync = false,
  bool isGenerator = false,
}) {
  final DartType returnType;
  if (returnsDynamic) {
    returnType = DynamicMockType();
  } else {
    returnType = MockType();
  }
  when(() => returnType.isDartAsyncFuture).thenReturn(returnsFuture);
  when(() => returnType.isDartAsyncFutureOr).thenReturn(returnsFutureOr);

  final methodFragment = MockMethodFragment();
  when(() => methodFragment.isGenerator).thenReturn(isGenerator);
  when(() => methodFragment.isAsynchronous).thenReturn(isAsync);

  final method = MockMethod();
  when(() => method.returnType).thenReturn(returnType);
  when(() => method.fragments).thenReturn([methodFragment]);

  return method;
}

MockMethod mockStreamMethod({
  bool isAsync = false,
  bool isGenerator = false,
  bool returnsDynamic = false,
}) {
  final DartType returnType;
  if (returnsDynamic) {
    returnType = DynamicMockType();
  } else {
    returnType = MockType();
  }

  final mockMethodFragment = MockMethodFragment();
  when(() => mockMethodFragment.isGenerator).thenReturn(isGenerator);
  when(() => mockMethodFragment.isAsynchronous).thenReturn(isAsync);

  final method = MockMethod();
  when(() => method.returnType).thenReturn(returnType);
  when(() => method.fragments).thenReturn([mockMethodFragment]);

  return method;
}

MockTypeChecker streamChecker({bool isStream = false}) {
  final checker = MockTypeChecker();
  when(() => checker.isAssignableFromType(any())).thenReturn(isStream);
  return checker;
}

void main() {
  setUpAll(() {
    registerFallbackValue(MockType());
  });

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
                .returnsStream(mockStreamMethod(returnsDynamic: true)),
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

  test('NonPrivateNameExtension should remove only leading underscores', () {
    expect('__foo_bar__'.nonPrivateName, equals('foo_bar__'));
  });
}
