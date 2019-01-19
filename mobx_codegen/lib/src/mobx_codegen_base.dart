import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:source_gen/source_gen.dart';
import 'package:mobx/mobx.dart' show Store;

import 'package:mobx/src/api/annotations.dart'
    show ComputedMethod, MakeAction, MakeObservable;

class StoreGenerator extends Generator {
  final _storeChecker = TypeChecker.fromRuntime(Store);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    return library.classes
        .where((c) => c.isAbstract)
        .where((c) => c.interfaces.any(_storeChecker.isExactlyType))
        .map(generateStoreClassCode)
        .toSet()
        .join('\n\n');
  }

  String generateStoreClassCode(ClassElement storeClass) {
    final visitor = new StoreClassVisitor(storeClass.name);
    storeClass.visitChildren(visitor);
    return visitor.source;
  }
}

class StoreClassVisitor extends SimpleElementVisitor {
  StoreClassVisitor(String parentName) {
    _storeTemplate = StoreTemplate()
      ..parentName = parentName
      ..name = '_\$$parentName';
  }

  final _observableChecker = TypeChecker.fromRuntime(MakeObservable);

  final _computedChecker = TypeChecker.fromRuntime(ComputedMethod);

  final _actionChecker = TypeChecker.fromRuntime(MakeAction);

  StoreTemplate _storeTemplate;

  String get source => _storeTemplate.toString();

  @override
  visitFieldElement(FieldElement element) async {
    if (!element.isFinal && _observableChecker.hasAnnotationOfExact(element)) {
      final template = ObservableTemplate()
        ..storeTemplate = _storeTemplate
        ..atomName = '_\$${element.name}Atom'
        ..type = element.type.name
        ..name = element.name;

      _storeTemplate.observables.add(template);
    }
    return null;
  }

  @override
  visitPropertyAccessorElement(PropertyAccessorElement element) {
    if (element.isGetter && _computedChecker.hasAnnotationOfExact(element)) {
      _storeTemplate.addComputed(
          computedName: '_\$${element.name}Computed',
          name: element.name,
          type: element.returnType.name);
    }
    return null;
  }

  @override
  visitMethodElement(MethodElement element) {
    if (!element.isAsynchronous &&
        _actionChecker.hasAnnotationOfExact(element)) {
      final typeParam = (TypeParameterElement elem) => TypeParamTemplate()
        ..name = elem.name
        ..bound = elem.bound?.name;

      final param = (ParameterElement elem) => ParamTemplate()
        ..name = elem.name
        ..type = elem.type.name
        ..defaultValue = elem.defaultValueCode;

      final arg = (ParameterElement elem) => elem.name;

      final namedArg =
          (ParameterElement elem) => NamedArgTemplate()..name = elem.name;

      final positionalParams = element.parameters
          .where((param) => param.isPositional && !param.isOptionalPositional)
          .toList();

      final optionalParams = element.parameters
          .where((param) => param.isOptionalPositional)
          .toList();

      final namedParams =
          element.parameters.where((param) => param.isNamed).toList();

      final template = ActionTemplate()
        ..storeTemplate = _storeTemplate
        ..name = element.name
        ..returnType = element.returnType.name
        ..typeParams = element.typeParameters.map(typeParam)
        ..typeArgs = element.typeParameters.map((param) => param.name)
        ..positionalParams = positionalParams.map(param)
        ..positionalArgs = positionalParams.map(arg)
        ..optionalParams = optionalParams.map(param)
        ..optionalArgs = optionalParams.map(arg)
        ..namedParams = namedParams.map(param)
        ..namedArgs = namedParams.map(namedArg);

      _storeTemplate.actions.add(template);
    }
    return super.visitMethodElement(element);
  }
}
