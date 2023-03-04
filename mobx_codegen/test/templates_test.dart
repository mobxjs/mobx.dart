import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/observable_future.dart';
import 'package:mobx_codegen/src/template/params.dart';
import 'package:mobx_codegen/src/template/rows.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mobx_codegen/src/utils/non_private_name_extension.dart';
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
      final rows = Rows()
        ..add('first')
        ..add('')
        ..add('third');

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
  });

  group('ComputedTemplate', () {
    test('renders template based on template data', () {
      final template = ComputedTemplate(
          storeTemplate: (MixinStoreTemplate()..parentTypeName = 'Base'),
          computedName: 'computedName',
          type: 'ReturnType',
          name: 'computedField');

      expect(template.toString(), equals("""
  Computed<ReturnType>? computedName;

  @override
  ReturnType get computedField => (computedName ??= Computed<ReturnType>(() => super.computedField, name: 'Base.computedField')).value;"""));
    });
  });

  group('ObservableTemplate', () {
    test('generates public getter when isReadOnly is false', () {
      final template = ObservableTemplate(
        storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentName'),
        atomName: '_atomFieldName',
        type: 'FieldType',
        name: 'fieldName',
        isPrivate: false,
        isReadOnly: false,
      );
      expect(template.getterName, equals(template.name));
    });

    test('generates private getter when isReadOnly is true', () {
      final template = ObservableTemplate(
        storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentName'),
        atomName: '_atom_FieldName',
        type: 'FieldType',
        name: '_fieldName',
        isPrivate: true,
        isReadOnly: true,
      );
      expect(template.getterName, equals(template.name.nonPrivateName));
    });

    group('renders template based on template data', () {
      test('on public field', () {
        final template = ObservableTemplate(
            storeTemplate: (MixinStoreTemplate()
              ..parentTypeName = 'ParentName'),
            atomName: '_atomFieldName',
            type: 'FieldType',
            name: 'fieldName');
        final output = template.toString();
        expect(output, equals("""
  late final _atomFieldName = Atom(name: 'ParentName.fieldName', context: context);

  @override
  FieldType get fieldName {
    _atomFieldName.reportRead();
    return super.fieldName;
  }

  @override
  set fieldName(FieldType value) {
    _atomFieldName.reportWrite(value, super.fieldName, () {
      super.fieldName = value;
    });
  }"""));
      });

      test('on readonly field', () {
        final template = ObservableTemplate(
          storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentName'),
          atomName: '_atomFieldName',
          type: 'FieldType',
          name: '_fieldName',
          isPrivate: true,
          isReadOnly: true,
        );
        final output = template.toString();
        expect(output, equals("""
  late final _atomFieldName = Atom(name: 'ParentName._fieldName', context: context);

  FieldType get fieldName {
    _atomFieldName.reportRead();
    return super._fieldName;
  }

  @override
  FieldType get _fieldName => fieldName;

  @override
  set _fieldName(FieldType value) {
    _atomFieldName.reportWrite(value, super._fieldName, () {
      super._fieldName = value;
    });
  }"""));
      });
    });
  });

  group('ParamTemplate', () {
    test('renders parameter without default value', () {
      final template = ParamTemplate(name: 'size', type: 'int');

      expect(template.toString(), equals('int size'));
    });

    test('renders parameter with a default value', () {
      final template = ParamTemplate(
          name: 'address', type: 'String', defaultValue: '"unknown"');

      expect(template.toString(), equals('String address = "unknown"'));
    });

    test('asArgument returns name', () {
      final template = ParamTemplate(
          name: 'address', type: 'String', defaultValue: '"unknown"');

      expect(template.asArgument, equals('address'));
    });

    test('asNamedArgument.toString() returns named argument code', () {
      final template = ParamTemplate(
          name: 'address', type: 'String', defaultValue: '"unknown"');

      expect(template.asNamedArgument.toString(), equals('address: address'));
    });
  });

  group('TypeParamTemplate', () {
    test('renders type parameter without a bound', () {
      final template = TypeParamTemplate(name: 'T');

      expect(template.toString(), equals('T'));
    });

    test('renders type parameter with a bound', () {
      final template = TypeParamTemplate(name: 'T', bound: 'String');

      expect(template.toString(), equals('T extends String'));
    });

    test('asArgument returns the name', () {
      final template = TypeParamTemplate(name: 'T', bound: 'String');

      expect(template.asArgument, equals('T'));
    });
  });

  group('NamedArgTemplate', () {
    test('renders named argument list entry', () {
      final template = NamedArgTemplate(name: 'address');

      expect(template.toString(), equals('address: address'));
    });
  });

  group('ActionTemplate', () {
    final method = MethodOverrideTemplate()
      ..name = 'myAction'
      ..returnType = 'ReturnType'
      ..setTypeParams([
        TypeParamTemplate(name: 'T'),
        TypeParamTemplate(name: 'S', bound: 'String')
      ])
      ..positionalParams = [ParamTemplate(name: 'arg1', type: 'T')]
      ..optionalParams = [
        ParamTemplate(name: 'arg2', type: 'S', defaultValue: '"arg2value"'),
        ParamTemplate(name: 'arg3', type: 'String')
      ]
      ..namedParams = [
        ParamTemplate(
            name: 'namedArg1', type: 'String', defaultValue: '"default"'),
        ParamTemplate(name: 'namedArg2', type: 'int', defaultValue: '3')
      ];

    test('renders properly', () {
      final template = ActionTemplate(
        storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentClass'),
        method: method,
        hasProtected: false,
        hasVisibleForOverriding: false,
        hasVisibleForTesting: false,
      );

      expect(template.toString(), equals("""
    @override
    ReturnType myAction<T, S extends String>(T arg1, [S arg2 = "arg2value", String arg3], {String namedArg1 = "default", int namedArg2 = 3}) {
      final _\$actionInfo = _\$ParentClassActionController.startAction(name: 'ParentClass.myAction<T, S extends String>');
      try {
        return super.myAction<T, S>(arg1, arg2, arg3, namedArg1: namedArg1, namedArg2: namedArg2);
      } finally {
        _\$ParentClassActionController.endAction(_\$actionInfo);
      }
    }"""));
    });

    test('generates template with "@protected" annotation', () {
      final template = ActionTemplate(
        storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentClass'),
        method: method,
        hasProtected: true,
        hasVisibleForOverriding: false,
        hasVisibleForTesting: false,
      );

      expect(template.toString(), contains('@protected'));
    });

    test('generates template with "@visibleForOverriding" annotation', () {
      final template = ActionTemplate(
        storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentClass'),
        method: method,
        hasProtected: false,
        hasVisibleForOverriding: true,
        hasVisibleForTesting: false,
      );

      expect(template.toString(), contains('@visibleForOverriding'));
    });

    test('generates template with "@visibleForTesting" annotation', () {
      final template = ActionTemplate(
        storeTemplate: (MixinStoreTemplate()..parentTypeName = 'ParentClass'),
        method: method,
        hasProtected: false,
        hasVisibleForOverriding: false,
        hasVisibleForTesting: true,
      );

      expect(template.toString(), contains('@visibleForTesting'));
    });
  });

  group('ObservableFutureTemplate', () {
    final method = MethodOverrideTemplate()
      ..name = 'fetchData'
      ..returnType = 'Future'
      ..returnTypeArgs = SurroundedCommaList('<', '>', ['T'])
      ..setTypeParams([
        TypeParamTemplate(name: 'T'),
        TypeParamTemplate(name: 'S', bound: 'String')
      ])
      ..positionalParams = [
        ParamTemplate(
          name: 'arg1',
          type: 'T',
        )
      ]
      ..optionalParams = [
        ParamTemplate(name: 'arg2', type: 'S', defaultValue: '"arg2value"'),
        ParamTemplate(
          name: 'arg3',
          type: 'String',
        )
      ]
      ..namedParams = [
        ParamTemplate(
            name: 'namedArg1', type: 'String', defaultValue: '"default"'),
        ParamTemplate(name: 'namedArg2', type: 'int', defaultValue: '3')
      ];

    test('renders properly', () {
      final template = ObservableFutureTemplate(
        method: method,
        hasProtected: false,
        hasVisibleForOverriding: false,
        hasVisibleForTesting: false,
      );

      expect(template.toString(), equals("""
  @override
  ObservableFuture<T> fetchData<T, S extends String>(T arg1, [S arg2 = "arg2value", String arg3], {String namedArg1 = "default", int namedArg2 = 3}) {
    final _\$future = super.fetchData<T, S>(arg1, arg2, arg3, namedArg1: namedArg1, namedArg2: namedArg2);
    return ObservableFuture<T>(_\$future, context: context);
  }"""));
    });

    test('generates template with "@protected" annotation', () {
      final template = ObservableFutureTemplate(
        method: method,
        hasProtected: true,
        hasVisibleForOverriding: false,
        hasVisibleForTesting: false,
      );

      expect(template.toString(), contains('@protected'));
    });
    test('generates template with "@visibleForOverriding" annotation', () {
      final template = ObservableFutureTemplate(
        method: method,
        hasProtected: false,
        hasVisibleForOverriding: true,
        hasVisibleForTesting: false,
      );

      expect(template.toString(), contains('@visibleForOverriding'));
    });
    test('generates template with "@visibleForTesting" annotation', () {
      final template = ObservableFutureTemplate(
        method: method,
        hasProtected: false,
        hasVisibleForOverriding: false,
        hasVisibleForTesting: true,
      );

      expect(template.toString(), contains('@visibleForTesting'));
    });
  });
}
