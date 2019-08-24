import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:mobx/mobx.dart' show Store;
// ignore: implementation_imports
import 'package:mobx/src/api/annotations.dart'
    show ComputedMethod, MakeAction, MakeObservable, MakeStore;
import 'package:mobx_codegen/src/errors.dart';
import 'package:mobx_codegen/src/template/action.dart';
import 'package:mobx_codegen/src/template/async_action.dart';
import 'package:mobx_codegen/src/template/computed.dart';
import 'package:mobx_codegen/src/template/constructor_override.dart';
import 'package:mobx_codegen/src/template/method_override.dart';
import 'package:mobx_codegen/src/template/observable.dart';
import 'package:mobx_codegen/src/template/observable_future.dart';
import 'package:mobx_codegen/src/template/observable_stream.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/template/store_file.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:source_gen/source_gen.dart';

class StoreGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    final file = StoreFileTemplate()
      ..storeSources = _generateCodeForLibrary(library).toSet();
    return file.toString();
  }

  Iterable<String> _generateCodeForLibrary(LibraryReader library) sync* {
    for (final classElement in library.classes) {
      if (isValidMixinStoreClass(classElement)) {
        yield* _generateCodeForMixinStore(library, classElement);
      } else if (isValidAnnotatedStoreClass(classElement)) {
        yield* _generateCodeForAnnotatedStore(library, classElement);
      }
    }
  }

  Iterable<String> _generateCodeForMixinStore(
    LibraryReader library,
    ClassElement baseClass,
  ) sync* {
    final otherClasses = library.classes.where((c) => c != baseClass);
    final mixedClass = otherClasses.firstWhere((c) {
      // If our base class has different type parameterization requirements than
      // the class we're evaluating provides, we know it's not a subclass.
      if (baseClass.typeParameters.length != c.supertype.typeArguments.length) {
        return false;
      }

      // Apply the subclass' type arguments to the base type (if there are none
      // this has no impact), and perform a supertype check.
      return baseClass.type
          .instantiate(c.supertype.typeArguments)
          .isSupertypeOf(c.type);
    }, orElse: () => null);

    if (mixedClass != null) {
      yield _generateCodeFromTemplate(
          mixedClass.name, baseClass, MixinStoreTemplate());
    }
  }

  Iterable<String> _generateCodeForAnnotatedStore(
    LibraryReader reader,
    ClassElement baseClass,
  ) sync* {
    assert(baseClass.isPrivate);
    // Strip off leading underscore
    final publicTypeName = baseClass.name.substring(1);
    yield _generateCodeFromTemplate(
        publicTypeName, baseClass, SubclassStoreTemplate());
  }

  String _generateCodeFromTemplate(
    String publicTypeName,
    ClassElement userStoreClass,
    StoreTemplate template,
  ) {
    final visitor = StoreMixinVisitor(publicTypeName, userStoreClass, template);
    userStoreClass
      ..accept(visitor)
      ..visitChildren(visitor);
    return visitor.source;
  }
}

const _storeMixinChecker = TypeChecker.fromRuntime(Store);
const _storeAnnotationChecker = TypeChecker.fromRuntime(MakeStore);

bool isValidMixinStoreClass(ClassElement classElement) =>
    classElement.isAbstract &&
    classElement.mixins.any(_storeMixinChecker.isExactlyType);

bool isValidAnnotatedStoreClass(ClassElement classElement) =>
    classElement.isPrivate &&
    _storeAnnotationChecker.hasAnnotationOfExact(classElement);

class StoreMixinVisitor extends SimpleElementVisitor {
  StoreMixinVisitor(
    String publicTypeName,
    ClassElement userClass,
    StoreTemplate template,
  ) : _errors = StoreClassCodegenErrors(publicTypeName) {
    _storeTemplate = template
      ..typeParams
          .templates
          .addAll(userClass.typeParameters.map(typeParamTemplate))
      ..typeArgs.templates.addAll(userClass.typeParameters.map((t) => t.name))
      ..parentTypeName = userClass.name
      ..publicTypeName = publicTypeName;
  }

  final _observableChecker = const TypeChecker.fromRuntime(MakeObservable);

  final _computedChecker = const TypeChecker.fromRuntime(ComputedMethod);

  final _actionChecker = const TypeChecker.fromRuntime(MakeAction);

  final _asyncChecker = AsyncMethodChecker();

  StoreTemplate _storeTemplate;

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
    if (isValidAnnotatedStoreClass(element) &&
        isValidMixinStoreClass(element)) {
      _errors.invalidStoreDeclaration.addIf(true, element.name);
    }
  }

  @override
  void visitConstructorElement(ConstructorElement element) {
    // Note that these constructor templates are only used for annotation stye
    // store definition. They're ignored otherwise.
    final template = ConstructorOverrideTemplate()
      ..store = _storeTemplate
      ..constructor = MethodOverrideTemplate.fromElement(element);

    _storeTemplate.constructors.add(template);
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
      ..type = element.type.displayName
      ..name = element.name;

    _storeTemplate.observables.add(template);
    return;
  }

  bool _fieldIsNotValid(FieldElement element) => any([
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
      ..name = element.name
      ..type = element.returnType.displayName;
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
          ..isObservable = _observableChecker.hasAnnotationOfExact(element)
          ..method = MethodOverrideTemplate.fromElement(element);

        _storeTemplate.asyncActions.add(template);
      } else {
        final template = ActionTemplate()
          ..storeTemplate = _storeTemplate
          ..method = MethodOverrideTemplate.fromElement(element);

        _storeTemplate.actions.add(template);
      }
    } else if (_observableChecker.hasAnnotationOfExact(element)) {
      if (_asyncObservableIsNotValid(element)) {
        return;
      }

      if (_asyncChecker.returnsFuture(element)) {
        final template = ObservableFutureTemplate()
          ..method = MethodOverrideTemplate.fromElement(element);

        _storeTemplate.observableFutures.add(template);
      } else if (_asyncChecker.returnsStream(element)) {
        final template = ObservableStreamTemplate()
          ..method = MethodOverrideTemplate.fromElement(element);

        _storeTemplate.observableStreams.add(template);
      }
    }

    return;
  }

  bool _asyncObservableIsNotValid(MethodElement method) => any([
        _errors.staticMethods.addIf(method.isStatic, method.name),
        _errors.nonAsyncMethods.addIf(
            !_asyncChecker.returnsFuture(method) &&
                !_asyncChecker.returnsStream(method),
            method.name),
      ]);

  bool _actionIsNotValid(MethodElement element) => any([
        _errors.staticMethods.addIf(element.isStatic, element.name),
        _errors.asyncGeneratorActions
            .addIf(element.isAsynchronous && element.isGenerator, element.name),
      ]);
}

bool any(List<bool> list) => list.any(identity);

T identity<T>(T value) => value;
