import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/observable_future.dart';
import 'package:mobx_codegen/src/template/rows.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:test/test.dart';

void main() {
  group('surroundNonEmpty', () {
    test('surrounds a non empty string', () {
      expect(surroundNonEmpty('<', '>', 'A, B'), equals('<A, B>'));
    });

    test('returns empty when content is empty', () {
      expect(surroundNonEmpty('<', '>', ''), equals(''));
    });
  });

  group('Rows', () {
    test('Rows toString joins non empty strings on their own lines', () {
      final rows = Rows()..add('first')..add('')..add('third');

      expect(rows.toString(), equals('first\nthird'));
    });

    test('isEmpty works', () {
      final rows = Rows();

      expect(rows.isEmpty, isTrue);

      rows.add(12);
      expect(rows.isEmpty, isFalse);
    });
  });

  group('CommaList', () {
    test('toString joins templates with a comma', () {
      expect(CommaList(['A', 2, 'C']).toString(), equals('A, 2, C'));
    });

    test('toString filters empty templates', () {
      expect(CommaList(['A', 2, '', '', 'C']).toString(), equals('A, 2, C'));
    });

    test('toString returns empty string if templates are empty', () {
      expect(CommaList([]).toString(), equals(''));
    });

    test('constructor throws if templates list is null', () {
      expect(() => CommaList(null).toString(), throwsA(anything));
    });
  });

  group('SurroundedCommaList', () {
    test('toString joins templates with a comma and surrounds them', () {
      expect(SurroundedCommaList('[', ']', ['A', 2, 'C']).toString(),
          equals('[A, 2, C]'));
    });

    test('toString filters empty templates', () {
      expect(SurroundedCommaList('(', ')', ['A', 2, '', '', 'C']).toString(),
          equals('(A, 2, C)'));
    });

    test('constructor throws if any argument is null', () {
      expect(() => SurroundedCommaList(null, ')', ['A']).toString(),
          throwsA(anything));
      expect(() => SurroundedCommaList('(', null, ['B']).toString(),
          throwsA(anything));
      expect(() => SurroundedCommaList('(', ')', null).toString(),
          throwsA(anything));
    });
  });

  group('ComputedTemplate', () {
    test('renders template based on template data', () {
      final template = ComputedTemplate()
        ..computedName = 'computedName'
        ..type = 'ReturnType'
        ..name = 'computedField';

      expect(template.toString(), equals("""
  Computed<ReturnType> computedName;

  @override
  ReturnType get computedField => (computedName ??= Computed<ReturnType>(() => super.computedField)).value;"""));
    });
  });

  group('ObservableTemplate', () {
    test('renders template based on template data', () {
      final template = ObservableTemplate()
        ..storeTemplate = (StoreTemplate()..parentName = 'ParentName')
        ..atomName = '_atomFieldName'
        ..type = 'FieldType'
        ..name = 'fieldName';

      expect(template.toString(), equals("""
  final _atomFieldName = Atom(name: 'ParentName.fieldName');

  @override
  FieldType get fieldName {
    _atomFieldName.reportObserved();
    return super.fieldName;
  }

  @override
  set fieldName(FieldType value) {
    mainContext.checkIfStateModificationsAreAllowed(_atomFieldName);
    super.fieldName = value;
    _atomFieldName.reportChanged();
  }"""));
    });
  });

  group('ParamTemplate', () {
    test('renders parameter without default value', () {
      final template = ParamTemplate()
        ..name = 'size'
        ..type = 'int';

      expect(template.toString(), equals('int size'));
    });

    test('renders parameter with a default value', () {
      final template = ParamTemplate()
        ..name = 'address'
        ..type = 'String'
        ..defaultValue = '"unknown"';

      expect(template.toString(), equals('String address = "unknown"'));
    });

    test('asArgument returns name', () {
      final template = ParamTemplate()
        ..name = 'address'
        ..type = 'String'
        ..defaultValue = '"unknown"';

      expect(template.asArgument, equals('address'));
    });

    test('asNamedArgument.toString() returns named argument code', () {
      final template = ParamTemplate()
        ..name = 'address'
        ..type = 'String'
        ..defaultValue = '"unknown"';

      expect(template.asNamedArgument.toString(), equals('address: address'));
    });
  });

  group('TypeParamTemplate', () {
    test('renders type parameter without a bound', () {
      final template = TypeParamTemplate()..name = 'T';

      expect(template.toString(), equals('T'));
    });

    test('renders type parameter with a bound', () {
      final template = TypeParamTemplate()
        ..name = 'T'
        ..bound = 'String';

      expect(template.toString(), equals('T extends String'));
    });

    test('asArgument returns the name', () {
      final template = TypeParamTemplate()
        ..name = 'T'
        ..bound = 'String';

      expect(template.asArgument, equals('T'));
    });
  });

  group('NamedArgTemplate', () {
    test('renders named argument list entry', () {
      final template = NamedArgTemplate()..name = 'address';

      expect(template.toString(), equals('address: address'));
    });
  });

  group('ActionTemplate', () {
    test('renders properly', () {
      final template = ActionTemplate()
        ..storeTemplate = (StoreTemplate()..parentName = 'ParentClass')
        ..method = (MethodOverrideTemplate()
          ..name = 'myAction'
          ..returnType = 'ReturnType'
          ..setTypeParams([
            TypeParamTemplate()..name = 'T',
            TypeParamTemplate()
              ..name = 'S'
              ..bound = 'String'
          ])
          ..positionalParams = [
            ParamTemplate()
              ..name = 'arg1'
              ..type = 'T'
          ]
          ..optionalParams = [
            ParamTemplate()
              ..name = 'arg2'
              ..type = 'S'
              ..defaultValue = '"arg2value"',
            ParamTemplate()
              ..name = 'arg3'
              ..type = 'String'
          ]
          ..namedParams = [
            ParamTemplate()
              ..name = 'namedArg1'
              ..type = 'String'
              ..defaultValue = '"default"',
            ParamTemplate()
              ..name = 'namedArg2'
              ..type = 'int'
              ..defaultValue = '3'
          ]);

      expect(template.toString(), equals("""
    @override
    ReturnType myAction<T, S extends String>(T arg1, [S arg2 = "arg2value", String arg3], {String namedArg1 = "default", int namedArg2 = 3}) {
      final _\$actionInfo = _\$ParentClassActionController.startAction();
      try {
        return super.myAction<T, S>(arg1, arg2, arg3, namedArg1: namedArg1, namedArg2: namedArg2);
      } finally {
        _\$ParentClassActionController.endAction(_\$actionInfo);
      }
    }"""));
    });
  });

  group('ObservableFutureTemplate', () {
    test('renders properly', () {
      final template = ObservableFutureTemplate()
        ..method = (MethodOverrideTemplate()
          ..name = 'fetchData'
          ..returnType = 'Future'
          ..returnTypeArgs = SurroundedCommaList('<', '>', ['T'])
          ..setTypeParams([
            TypeParamTemplate()..name = 'T',
            TypeParamTemplate()
              ..name = 'S'
              ..bound = 'String'
          ])
          ..positionalParams = [
            ParamTemplate()
              ..name = 'arg1'
              ..type = 'T'
          ]
          ..optionalParams = [
            ParamTemplate()
              ..name = 'arg2'
              ..type = 'S'
              ..defaultValue = '"arg2value"',
            ParamTemplate()
              ..name = 'arg3'
              ..type = 'String'
          ]
          ..namedParams = [
            ParamTemplate()
              ..name = 'namedArg1'
              ..type = 'String'
              ..defaultValue = '"default"',
            ParamTemplate()
              ..name = 'namedArg2'
              ..type = 'int'
              ..defaultValue = '3'
          ]);

      expect(template.toString(), equals("""
  @override
  ObservableFuture<T> fetchData<T, S extends String>(T arg1, [S arg2 = "arg2value", String arg3], {String namedArg1 = "default", int namedArg2 = 3}) {
    final _\$future = super.fetchData<T, S>(arg1, arg2, arg3, namedArg1: namedArg1, namedArg2: namedArg2);
    return ObservableFuture<T>(_\$future);
  }"""));
    });
  });
}
