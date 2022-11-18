import 'package:mobx_codegen/src/errors.dart';
import 'package:test/test.dart';

class TestFieldErrors extends PropertyErrors {
  @override
  String get message => 'test $property $propertyList';
}

void main() {
  group('StoreClassCodegenErrors', () {
    late StoreClassCodegenErrors storeClassCodegenErrors;
    late List<String> errorsMessages;

    setUp(() {
      storeClassCodegenErrors = StoreClassCodegenErrors('store')
        ..nonAbstractStoreMixinDeclarations
            .addIf(true, 'nonAbstractStoreMixinDeclarations')
        ..invalidComputedAnnotations.addIf(true, 'invalidComputedAnnotations')
        ..invalidObservableAnnotations
            .addIf(true, 'invalidObservableAnnotations')
        ..invalidReadOnlyAnnotations.addIf(true, 'invalidReadOnlyAnnotations')
        ..invalidActionAnnotations.addIf(true, 'invalidActionAnnotations')
        ..staticObservables.addIf(true, 'staticObservables')
        ..invalidPublicSetterOnReadOnlyObservable
            .addIf(true, 'invalidPublicSetterOnReadOnlyObservable')
        ..staticMethods.addIf(true, 'staticMethods')
        ..finalObservables.addIf(true, 'finalObservables')
        ..asyncGeneratorActions.addIf(true, 'asyncGeneratorActions')
        ..nonAsyncMethods.addIf(true, 'nonAsyncMethods');

      errorsMessages = <CodegenError>[
        NonAbstractStoreMixinDeclarations()
          ..addIf(true, 'nonAbstractStoreMixinDeclarations'),
        InvalidComputedAnnotations()..addIf(true, 'invalidComputedAnnotations'),
        InvalidObservableAnnotations()
          ..addIf(true, 'invalidObservableAnnotations'),
        InvalidReadOnlyAnnotations()..addIf(true, 'invalidReadOnlyAnnotations'),
        InvalidActionAnnotations()..addIf(true, 'invalidActionAnnotations'),
        StaticObservableFields()..addIf(true, 'staticObservables'),
        InvalidSetterOnReadOnlyObservable()
          ..addIf(true, 'invalidPublicSetterOnReadOnlyObservable'),
        InvalidStaticMethods()..addIf(true, 'staticMethods'),
        FinalObservableFields()..addIf(true, 'finalObservables'),
        AsyncGeneratorActionMethods()..addIf(true, 'asyncGeneratorActions'),
        NonAsyncMethods()..addIf(true, 'nonAsyncMethods'),
      ].map((error) => error.message).toList();
    });

    test('message accounts for all kinds of PropertyErrors', () {
      expect(
        storeClassCodegenErrors.message,
        allOf(errorsMessages.map(contains).toList()),
      );
    });

    test('message contains only errors, nothing else', () {
      var message = storeClassCodegenErrors.message;
      message = message.replaceFirst(
          'Could not make class "store" observable. Changes needed:', '');
      for (final errorMessage in errorsMessages) {
        message = message.replaceFirst(errorMessage, '');
      }
      message = message.replaceAll(RegExp(r'\s*\d+\.\s'), '').trim();
      expect(message, isEmpty);
    });
  });

  group('Pluralize', () {
    test('Pluralize.call returns single string when count is 1', () {
      expect(Pluralize('the item', 'items').call(1), 'the item');
    });

    test('Pluralize.call returns multiple string when count is not 1', () {
      expect(Pluralize('the item', 'items').call(2), 'items');
    });
  });

  group('NameList', () {
    test('toString returns one quoted name if has single name added', () {
      expect((NameList()..add('myField')).toString(), equals('"myField"'));
    });

    test('toString returns two quoted fields with and between', () {
      expect(
          (NameList()
                ..add('myField1')
                ..add('myField2'))
              .toString(),
          equals('"myField1" and "myField2"'));
    });

    test(
        'toString returns three quoted fields with a comma between first two and "and" between last two',
        () {
      expect(
          (NameList()
                ..add('myField1')
                ..add('myField2')
                ..add('myField3'))
              .toString(),
          equals('"myField1", "myField2" and "myField3"'));
    });

    test('length returns the count of added names', () {
      expect(
          (NameList()
                ..add('myField1')
                ..add('myField2'))
              .length,
          equals(2));
    });

    test('isEmpty returns false if items are added', () {
      final names = NameList();
      expect(names.isNotEmpty, equals(false));

      names.add('myField');
      expect(names.isNotEmpty, equals(true));
    });
  });

  group('PropertyErrors', () {
    test('hasErrors returns true if a name is added successfully', () {
      final errors = TestFieldErrors();
      expect(errors.hasErrors, isFalse);

      expect(errors.addIf(false, 'testField1'), isFalse);
      expect(errors.hasErrors, isFalse);

      expect(errors.addIf(true, 'testField2'), isTrue);
      expect(errors.hasErrors, isTrue);
    });

    test(
        'returns a formatted message when a field is added and the condition is true',
        () {
      final errors = TestFieldErrors()..addIf(true, 'testField');
      expect(errors.message, equals('test the field "testField"'));
    });

    test(
        'returns a formatted message when multiple fields are added and the condition is true',
        () {
      final errors = TestFieldErrors()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(
          errors.message, equals('test fields "testField1" and "testField2"'));
    });

    test('does not add field if condition is false', () {
      final errors = TestFieldErrors()
        ..addIf(true, 'testField1')
        ..addIf(false, 'testField2');
      expect(errors.message, equals('test the field "testField1"'));
    });

    test(
        ".property returns singular property string if there's only one item added",
        () {
      final errors = TestFieldErrors()..addIf(true, 'testField');
      expect(errors.property, equals('the field'));
    });

    test(
        ".property returns plural property string if there's more than one item added",
        () {
      final errors = TestFieldErrors()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(errors.property, equals('fields'));
    });
  });

  group('FinalObservableFields', () {
    test('message returns singular message with one field added', () {
      final fields = FinalObservableFields()..addIf(true, 'testField');
      expect(
          fields.message, 'Remove final modifier from the field "testField".');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = FinalObservableFields()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(fields.message,
          'Remove final modifier from fields "testField1" and "testField2".');
    });
  });

  group('InvalidReadOnlyAnnotations', () {
    test('message returns singular message with one field added', () {
      final fields = InvalidReadOnlyAnnotations()..addIf(true, 'testField');
      expect(fields.message,
          'You should only use @readonly annotation with private properties. Please remove from the field "testField".');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = InvalidReadOnlyAnnotations()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(fields.message,
          'You should only use @readonly annotation with private properties. Please remove from fields "testField1" and "testField2".');
    });
  });

  group('StaticObservableFields', () {
    test('message returns singular message with one field added', () {
      final fields = StaticObservableFields()..addIf(true, 'testField');
      expect(
          fields.message, 'Remove static modifier from the field "testField".');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = StaticObservableFields()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(fields.message,
          'Remove static modifier from fields "testField1" and "testField2".');
    });
  });

  group('AsyncActionMethods', () {
    test('message returns singular message with one field added', () {
      final fields = AsyncGeneratorActionMethods()..addIf(true, 'testMethod');
      expect(fields.message,
          'Replace async* modifier with async from the method "testMethod".');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = AsyncGeneratorActionMethods()
        ..addIf(true, 'testMethod1')
        ..addIf(true, 'testMethod2');
      expect(fields.message,
          'Replace async* modifier with async from methods "testMethod1" and "testMethod2".');
    });
  });

  group('InvalidStaticMethods', () {
    test('message returns singular message with one field added', () {
      final fields = InvalidStaticMethods()..addIf(true, 'testMethod');
      expect(fields.message,
          'Remove static modifier from the method "testMethod".');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = InvalidStaticMethods()
        ..addIf(true, 'testMethod1')
        ..addIf(true, 'testMethod2');
      expect(fields.message,
          'Remove static modifier from methods "testMethod1" and "testMethod2".');
    });
  });

  group('NonAsyncMethods', () {
    test('message returns singular message with one field added', () {
      final fields = NonAsyncMethods()..addIf(true, 'testMethod');
      expect(fields.message,
          'Return a Future or a Stream from the method "testMethod".');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = NonAsyncMethods()
        ..addIf(true, 'testMethod1')
        ..addIf(true, 'testMethod2');
      expect(fields.message,
          'Return a Future or a Stream from methods "testMethod1" and "testMethod2".');
    });
  });
}
