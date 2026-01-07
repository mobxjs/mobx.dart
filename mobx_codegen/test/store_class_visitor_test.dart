// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:mobx_codegen/src/store_class_visitor.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/type_names.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class PropertyAccessorElementMock extends Fake
    implements PropertyAccessorElement2 {
  PropertyAccessorElementMock(this._displayName);

  final String _displayName;

  @override
  String get displayName => _displayName;
}

class ClassElementMock extends Fake implements ClassElement2 {
  ClassElementMock(this._name);

  final String _name;

  @override
  String get name3 => _name;

  @override
  List<TypeParameterElement2> get typeParameters2 => [];
}

class StoreTemplateFake extends StoreTemplate {}

class StoreClassVisitorFake extends Fake implements StoreClassVisitor {}

class LibraryScopedNameFinderFake extends Fake
    implements LibraryScopedNameFinder {}

StoreClassVisitor makeVisitorWithErrors() {
  final store = StoreTemplateFake();
  final readOnlyTemplate = ObservableTemplate(
    storeTemplate: store,
    type: 'FieldType',
    name: '_name',
    atomName: '_atomName',
    isReadOnly: true,
    isPrivate: true,
  );
  store.observables.add(readOnlyTemplate);
  final visitor = StoreClassVisitor(
    'publicTypeName',
    ClassElementMock('anotherName'),
    store,
    LibraryScopedNameFinderFake(),
    BuilderOptions.empty,
  );
  final setter = PropertyAccessorElementMock('name');
  visitor.publicSettersCache.add(setter);
  return visitor;
}

void main() {
  group('StoreClassVisitor', () {
    test('validates errors before generating its source', () {
      final visitor = makeVisitorWithErrors();
      final source = visitor.source;
      expect(source, isEmpty);
      expect(visitor.errors.hasErrors, isTrue);
    });

    test('hasGeneratedToString understands BuilderOptions', () {
      expect(
        hasGeneratedToString(BuilderOptions({'hasToString': true}), null),
        true,
      );
    });

    test(
      'useDeepEquality is included in generated setter when set to true',
      () {
        final store = StoreTemplateFake()..parentTypeName = 'TestStore';
        final template = ObservableTemplate(
          storeTemplate: store,
          type: 'List<int>',
          name: 'items',
          atomName: '_itemsAtom',
          useDeepEquality: true,
        );
        final output = template.toString();
        expect(output, contains('useDeepEquality: true'));
      },
    );

    test(
      'useDeepEquality is included in generated setter when set to false',
      () {
        final store = StoreTemplateFake()..parentTypeName = 'TestStore';
        final template = ObservableTemplate(
          storeTemplate: store,
          type: 'List<int>',
          name: 'items',
          atomName: '_itemsAtom',
          useDeepEquality: false,
        );
        final output = template.toString();
        expect(output, contains('useDeepEquality: false'));
      },
    );

    test('useDeepEquality is not included in generated setter when null', () {
      final store = StoreTemplateFake()..parentTypeName = 'TestStore';
      final template = ObservableTemplate(
        storeTemplate: store,
        type: 'List<int>',
        name: 'items',
        atomName: '_itemsAtom',
        useDeepEquality: null,
      );
      final output = template.toString();
      expect(output, isNot(contains('useDeepEquality')));
    });

    test(
      'useDeepEquality is included in generated late field setter when set to true',
      () {
        final store = StoreTemplateFake()..parentTypeName = 'TestStore';
        final template = ObservableTemplate(
          storeTemplate: store,
          type: 'List<int>',
          name: 'items',
          atomName: '_itemsAtom',
          isLate: true,
          useDeepEquality: true,
        );
        final output = template.toString();
        expect(output, contains('useDeepEquality: true'));
      },
    );

    test(
      'useDeepEquality is included in generated late field setter when set to false',
      () {
        final store = StoreTemplateFake()..parentTypeName = 'TestStore';
        final template = ObservableTemplate(
          storeTemplate: store,
          type: 'List<int>',
          name: 'items',
          atomName: '_itemsAtom',
          isLate: true,
          useDeepEquality: false,
        );
        final output = template.toString();
        expect(output, contains('useDeepEquality: false'));
      },
    );

    test(
      'useDeepEquality is not included in generated late field setter when null',
      () {
        final store = StoreTemplateFake()..parentTypeName = 'TestStore';
        final template = ObservableTemplate(
          storeTemplate: store,
          type: 'List<int>',
          name: 'items',
          atomName: '_itemsAtom',
          isLate: true,
          useDeepEquality: null,
        );
        final output = template.toString();
        expect(output, isNot(contains('useDeepEquality')));
      },
    );
  });
}
