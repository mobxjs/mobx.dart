import 'package:mobx_codegen/src/errors.dart';
import 'package:test/test.dart';

class TestFieldErrors extends PropertyErrors {
  @override
  String get message => 'test $property $propertyList';
}

void main() {
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
      expect((NameList()..add('myField1')..add('myField2')).toString(),
          equals('"myField1" and "myField2"'));
    });

    test(
        'toString returns three quoted fields with a comma between first two and "and" between last two',
        () {
      expect(
          (NameList()..add('myField1')..add('myField2')..add('myField3'))
              .toString(),
          equals('"myField1", "myField2" and "myField3"'));
    });

    test('length returns the count of added names', () {
      expect((NameList()..add('myField1')..add('myField2')).length, equals(2));
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
      final errors = TestFieldErrors();
      errors.addIf(true, 'testField');
      expect(errors.message, equals('test the field "testField"'));
    });

    test(
        'returns a formatted message when multiple fields are added and the condition is true',
        () {
      final errors = TestFieldErrors();
      errors.addIf(true, 'testField1');
      errors.addIf(true, 'testField2');
      expect(
          errors.message, equals('test fields "testField1" and "testField2"'));
    });

    test('does not add field if condition is false', () {
      final errors = TestFieldErrors();
      errors.addIf(true, 'testField1');
      errors.addIf(false, 'testField2');
      expect(errors.message, equals('test the field "testField1"'));
    });

    test(
        ".property returns singular property string if there's only one item added",
        () {
      final errors = TestFieldErrors();
      errors.addIf(true, 'testField');
      expect(errors.property, equals('the field'));
    });

    test(
        ".property returns plural property string if there's more than one item added",
        () {
      final errors = TestFieldErrors();
      errors.addIf(true, 'testField1');
      errors.addIf(true, 'testField2');
      expect(errors.property, equals('fields'));
    });
  });

  group('FinalObservableFields', () {
    test('message returns singular message with one field added', () {
      final fields = FinalObservableFields()..addIf(true, 'testField');
      expect(
          fields.message, 'Remove final modifier from the field "testField"');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = FinalObservableFields()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(fields.message,
          'Remove final modifier from fields "testField1" and "testField2"');
    });
  });

  group('StaticObservableFields', () {
    test('message returns singular message with one field added', () {
      final fields = StaticObservableFields()..addIf(true, 'testField');
      expect(
          fields.message, 'Remove static modifier from the field "testField"');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = StaticObservableFields()
        ..addIf(true, 'testField1')
        ..addIf(true, 'testField2');
      expect(fields.message,
          'Remove static modifier from fields "testField1" and "testField2"');
    });
  });

  group('AsyncActionMethods', () {
    test('message returns singular message with one field added', () {
      final fields = AsyncGeneratorActionMethods()..addIf(true, 'testMethod');
      expect(fields.message,
          'Replace async* modifier with async from the method "testMethod"');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = AsyncGeneratorActionMethods()
        ..addIf(true, 'testMethod1')
        ..addIf(true, 'testMethod2');
      expect(fields.message,
          'Replace async* modifier with async from methods "testMethod1" and "testMethod2"');
    });
  });

  group('InvalidStaticMethods', () {
    test('message returns singular message with one field added', () {
      final fields = InvalidStaticMethods()..addIf(true, 'testMethod');
      expect(fields.message,
          'Remove static modifier from the method "testMethod"');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = InvalidStaticMethods()
        ..addIf(true, 'testMethod1')
        ..addIf(true, 'testMethod2');
      expect(fields.message,
          'Remove static modifier from methods "testMethod1" and "testMethod2"');
    });
  });

  group('NonAsyncMethods', () {
    test('message returns singular message with one field added', () {
      final fields = NonAsyncMethods()..addIf(true, 'testMethod');
      expect(fields.message,
          'Return a Future or a Stream from the method "testMethod"');
    });

    test('message returns plural message with multiple fields added', () {
      final fields = NonAsyncMethods()
        ..addIf(true, 'testMethod1')
        ..addIf(true, 'testMethod2');
      expect(fields.message,
          'Return a Future or a Stream from methods "testMethod1" and "testMethod2"');
    });
  });
}
