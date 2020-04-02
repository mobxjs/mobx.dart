import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:mobx/mobx.dart';
// ignore: implementation_imports
import 'package:mobx/src/api/annotations.dart'
    show ComputedMethod, MakeAction, MakeObservable, StoreConfig;
import 'package:mobx_codegen/src/errors.dart';
import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/async_action.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/observable_future.dart';
import 'package:mobx_codegen/src/template/observable_stream.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mobx_codegen/src/type_names.dart';
import 'package:source_gen/source_gen.dart';

class StoreClassVisitor extends SimpleElementVisitor {
  StoreClassVisitor(
    String publicTypeName,
    ClassElement userClass,
    StoreTemplate template,
    this.typeNameFinder,
  ) : _errors = StoreClassCodegenErrors(publicTypeName) {
    _storeTemplate = template
      ..typeParams.templates.addAll(userClass.typeParameters
          .map((type) => typeParamTemplate(type, typeNameFinder)))
      ..typeArgs.templates.addAll(userClass.typeParameters.map((t) => t.name))
      ..parentTypeName = userClass.name
      ..publicTypeName = publicTypeName;
  }

  final _observableChecker = const TypeChecker.fromRuntime(MakeObservable);

  final _computedChecker = const TypeChecker.fromRuntime(ComputedMethod);

  final _actionChecker = const TypeChecker.fromRuntime(MakeAction);

  final _asyncChecker = AsyncMethodChecker();

  StoreTemplate _storeTemplate;

  LibraryScopedNameFinder typeNameFinder;

  final StoreClassCodegenErrors _errors;

  String get source {
    if (_errors.hasErrors) {
      log.severe(_errors.message);
      return '';
    }
    return _storeTemplate.toString();
  }

  @override
  void visitClassElement(ClassElement element) {
    if (isMixinStoreClass(element)) {
      _errors.nonAbstractStoreMixinDeclarations
          .addIf(!element.isAbstract, element.name);
    }
    // if the class is annotated to generate toString() method we add the information to the _storeTemplate
    _storeTemplate.generateToString = hasGeneratedToString(element);
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (_computedChecker.hasAnnotationOfExact(element)) {
      _errors.invalidComputedAnnotations.addIf(true, element.name);
      return;
    }

    if (_actionChecker.hasAnnotationOfExact(element)) {
      _errors.invalidActionAnnotations.addIf(true, element.name);
      return;
    }

    if (!_observableChecker.hasAnnotationOfExact(element)) {
      return;
    }

    if (_fieldIsNotValid(element)) {
      return;
    }

    final template = ObservableTemplate()
      ..storeTemplate = _storeTemplate
      ..atomName = '_\$${element.name}Atom'
      ..type = typeNameFinder.findVariableTypeName(element)
      ..name = element.name
      ..isPrivate = element.isPrivate;

    _storeTemplate.observables.add(template);
    return;
  }

  bool _fieldIsNotValid(FieldElement element) => _any([
        _errors.staticObservables.addIf(element.isStatic, element.name),
        _errors.finalObservables.addIf(element.isFinal, element.name)
      ]);

  @override
  void visitPropertyAccessorElement(PropertyAccessorElement element) {
    if (_observableChecker.hasAnnotationOfExact(element)) {
      _errors.invalidObservableAnnotations.addIf(true, element.name);
      return;
    }

    if (_actionChecker.hasAnnotationOfExact(element)) {
      _errors.invalidActionAnnotations.addIf(true, element.name);
      return;
    }

    if (!element.isGetter || !_computedChecker.hasAnnotationOfExact(element)) {
      return;
    }

    final template = ComputedTemplate()
      ..computedName = '_\$${element.name}Computed'
      ..storeTemplate = _storeTemplate
      ..name = element.name
      ..type = typeNameFinder.findGetterTypeName(element)
      ..isPrivate = element.isPrivate;

    _storeTemplate.computeds.add(template);
    return;
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (_computedChecker.hasAnnotationOfExact(element)) {
      _errors.invalidComputedAnnotations.addIf(true, element.name);
      return;
    }

    if (_actionChecker.hasAnnotationOfExact(element)) {
      if (_actionIsNotValid(element)) {
        return;
      }

      if (element.isAsynchronous) {
        final template = AsyncActionTemplate()
          ..storeTemplate = _storeTemplate
          ..isObservable = _observableChecker.hasAnnotationOfExact(element)
          ..method =
              MethodOverrideTemplate.fromElement(element, typeNameFinder);

        _storeTemplate.asyncActions.add(template);
      } else {
        final template = ActionTemplate()
          ..storeTemplate = _storeTemplate
          ..method =
              MethodOverrideTemplate.fromElement(element, typeNameFinder);

        _storeTemplate.actions.add(template);
      }
    } else if (_observableChecker.hasAnnotationOfExact(element)) {
      if (_asyncObservableIsNotValid(element)) {
        return;
      }

      if (_asyncChecker.returnsFuture(element)) {
        final template = ObservableFutureTemplate()
          ..method =
              MethodOverrideTemplate.fromElement(element, typeNameFinder);

        _storeTemplate.observableFutures.add(template);
      } else if (_asyncChecker.returnsStream(element)) {
        final template = ObservableStreamTemplate()
          ..method =
              MethodOverrideTemplate.fromElement(element, typeNameFinder);

        _storeTemplate.observableStreams.add(template);
      }
    }

    return;
  }

  bool _asyncObservableIsNotValid(MethodElement method) => _any([
        _errors.staticMethods.addIf(method.isStatic, method.name),
        _errors.nonAsyncMethods.addIf(
            !_asyncChecker.returnsFuture(method) &&
                !_asyncChecker.returnsStream(method),
            method.name),
      ]);

  bool _actionIsNotValid(MethodElement element) => _any([
        _errors.staticMethods.addIf(element.isStatic, element.name),
        _errors.asyncGeneratorActions
            .addIf(element.isAsynchronous && element.isGenerator, element.name),
      ]);
}

const _storeMixinChecker = TypeChecker.fromRuntime(Store);
const _toStringAnnotationChecker = TypeChecker.fromRuntime(StoreConfig);

bool isMixinStoreClass(ClassElement classElement) =>
    classElement.mixins.any(_storeMixinChecker.isExactlyType);

// Checks if the class as a toString annotation
bool isStoreConfigAnnotatedStoreClass(ClassElement classElement) =>
    _toStringAnnotationChecker.hasAnnotationOfExact(classElement);

bool hasGeneratedToString(ClassElement classElement) {
  if (isStoreConfigAnnotatedStoreClass(classElement)) {
    final annotation =
        _toStringAnnotationChecker.firstAnnotationOfExact(classElement);
    return annotation.getField('hasToString').toBoolValue();
  }
  return true;
}

bool _any(List<bool> list) => list.any(_identity);

T _identity<T>(T value) => value;
