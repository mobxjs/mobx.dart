import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mobx_codegen/src/store_class_visitor.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/type_names.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class PropertyAccessorElementMock extends Fake
    implements PropertyAccessorElement {
  PropertyAccessorElementMock(this._displayName);

  final String _displayName;

  @override
  String get displayName => _displayName;
}

class ClassElementMock extends Fake implements ClassElement {
  ClassElementMock(this._name);

  final String _name;

  @override
  String get name => _name;

  @override
  List<TypeParameterElement> get typeParameters => [];
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
      BuilderOptions.empty);
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
  });
}
