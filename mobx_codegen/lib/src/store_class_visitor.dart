import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:meta/meta.dart';
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
import 'package:mobx_codegen/src/utils/non_private_name_extension.dart';
import 'package:source_gen/source_gen.dart';

class StoreClassVisitor extends SimpleElementVisitor {
  StoreClassVisitor(
    String publicTypeName,
    ClassElement userClass,
    StoreTemplate template,
    this.typeNameFinder,
    this.options,
  ) : errors = StoreClassCodegenErrors(publicTypeName) {
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

  late StoreTemplate _storeTemplate;

  LibraryScopedNameFinder typeNameFinder;

  final BuilderOptions options;

  final StoreClassCodegenErrors errors;

  @visibleForTesting
  final publicSettersCache = <PropertyAccessorElement>[];

  String get source {
    validate();
    if (errors.hasErrors) {
      log.severe(errors.message);
      return '';
    }
    return _storeTemplate.toString();
  }

  @override
  void visitClassElement(ClassElement element) {
    if (isMixinStoreClass(element)) {
      errors.nonAbstractStoreMixinDeclarations
          .addIf(!element.isAbstract, element.name);
    }
    // if the class is annotated to generate toString() method we add the information to the _storeTemplate
    _storeTemplate.generateToString = hasGeneratedToString(options, element);
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (_computedChecker.hasAnnotationOfExact(element)) {
      errors.invalidComputedAnnotations.addIf(true, element.name);
      return;
    }

    if (_actionChecker.hasAnnotationOfExact(element)) {
      errors.invalidActionAnnotations.addIf(true, element.name);
      return;
    }

    if (!_observableChecker.hasAnnotationOfExact(element)) {
      return;
    }

    if (_fieldIsNotValid(element)) {
      return;
    }

    final template = ObservableTemplate(
      storeTemplate: _storeTemplate,
      atomName: '_\$${element.name}Atom',
      type: typeNameFinder.findVariableTypeName(element),
      name: element.name,
      isPrivate: element.isPrivate,
      isReadOnly: _isObservableReadOnly(element),
      isLate: element.isLate,
      equals: _getEquals(element),
    );

    _storeTemplate.observables.add(template);
    return;
  }

  bool _isObservableReadOnly(FieldElement element) =>
      _observableChecker
          .firstAnnotationOfExact(element)
          ?.getField('readOnly')
          ?.toBoolValue() ??
      false;

  ExecutableElement? _getEquals(FieldElement element) => _observableChecker
      .firstAnnotationOfExact(element)
      ?.getField('equals')
      ?.toFunctionValue();

  bool _fieldIsNotValid(FieldElement element) => _any([
        errors.staticObservables.addIf(element.isStatic, element.name),
        errors.finalObservables.addIf(element.isFinal, element.name),
        errors.invalidReadOnlyAnnotations.addIf(
          _isObservableReadOnly(element) && element.setter!.isPublic,
          element.name,
        ),
      ]);

  bool? _isComputedKeepAlive(Element element) => _computedChecker
      .firstAnnotationOfExact(element)
      ?.getField('keepAlive')
      ?.toBoolValue();

  @override
  void visitPropertyAccessorElement(PropertyAccessorElement element) {
    if (element.isSetter && element.isPublic) {
      publicSettersCache.add(element);
    }

    if (_observableChecker.hasAnnotationOfExact(element)) {
      errors.invalidObservableAnnotations.addIf(true, element.name);
      return;
    }

    if (_actionChecker.hasAnnotationOfExact(element)) {
      errors.invalidActionAnnotations.addIf(true, element.name);
      return;
    }

    if (!element.isGetter || !_computedChecker.hasAnnotationOfExact(element)) {
      return;
    }

    final template = ComputedTemplate(
        computedName: '_\$${element.name}Computed',
        storeTemplate: _storeTemplate,
        name: element.name,
        type: typeNameFinder.findGetterTypeName(element),
        isPrivate: element.isPrivate,
        isKeepAlive: _isComputedKeepAlive(element));

    _storeTemplate.computeds.add(template);
    return;
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (_computedChecker.hasAnnotationOfExact(element)) {
      errors.invalidComputedAnnotations.addIf(true, element.name);
      return;
    }

    if (_actionChecker.hasAnnotationOfExact(element)) {
      if (_actionIsNotValid(element)) {
        return;
      }

      if (element.isAsynchronous) {
        final template = AsyncActionTemplate(
          storeTemplate: _storeTemplate,
          isObservable: _observableChecker.hasAnnotationOfExact(element),
          method: MethodOverrideTemplate.fromElement(element, typeNameFinder),
          hasProtected: element.hasProtected,
          hasVisibleForOverriding: element.hasVisibleForOverriding,
          hasVisibleForTesting: element.hasVisibleForTesting,
        );

        _storeTemplate.asyncActions.add(template);
      } else {
        final template = ActionTemplate(
          storeTemplate: _storeTemplate,
          method: MethodOverrideTemplate.fromElement(element, typeNameFinder),
          hasProtected: element.hasProtected,
          hasVisibleForOverriding: element.hasVisibleForOverriding,
          hasVisibleForTesting: element.hasVisibleForTesting,
        );

        _storeTemplate.actions.add(template);
      }
    } else if (_observableChecker.hasAnnotationOfExact(element)) {
      if (_asyncObservableIsNotValid(element)) {
        return;
      }

      if (_asyncChecker.returnsFuture(element)) {
        final template = ObservableFutureTemplate(
          method: MethodOverrideTemplate.fromElement(element, typeNameFinder),
          hasProtected: element.hasProtected,
          hasVisibleForOverriding: element.hasVisibleForOverriding,
          hasVisibleForTesting: element.hasVisibleForTesting,
        );

        _storeTemplate.observableFutures.add(template);
      } else if (_asyncChecker.returnsStream(element)) {
        final template = ObservableStreamTemplate(
          method: MethodOverrideTemplate.fromElement(element, typeNameFinder),
          hasProtected: element.hasProtected,
          hasVisibleForOverriding: element.hasVisibleForOverriding,
          hasVisibleForTesting: element.hasVisibleForTesting,
        );

        _storeTemplate.observableStreams.add(template);
      }
    }

    return;
  }

  bool _asyncObservableIsNotValid(MethodElement method) => _any([
        errors.staticMethods.addIf(method.isStatic, method.name),
        errors.nonAsyncMethods.addIf(
            !_asyncChecker.returnsFuture(method) &&
                !_asyncChecker.returnsStream(method),
            method.name),
      ]);

  bool _actionIsNotValid(MethodElement element) => _any([
        errors.staticMethods.addIf(element.isStatic, element.name),
        errors.asyncGeneratorActions
            .addIf(element.isAsynchronous && element.isGenerator, element.name),
      ]);

  /// Runs validations after all elements have been visited.
  void validate() {
    for (final publicSetter in publicSettersCache) {
      errors.invalidPublicSetterOnReadOnlyObservable.addIf(
        _isInvalidPublicSetterOnReadOnlyObservable(publicSetter),
        publicSetter.displayName,
      );
    }
  }

  bool _isInvalidPublicSetterOnReadOnlyObservable(
          PropertyAccessorElement publicSetter) =>
      _storeTemplate.observables.templates.any(
        (template) =>
            template.name.nonPrivateName == publicSetter.displayName &&
            template.isReadOnly,
      );
}

const _storeMixinChecker = TypeChecker.fromRuntime(Store);
const _toStringAnnotationChecker = TypeChecker.fromRuntime(StoreConfig);

bool isMixinStoreClass(ClassElement classElement) =>
    classElement.mixins.any(_storeMixinChecker.isExactlyType);

// Checks if the class as a toString annotation
bool isStoreConfigAnnotatedStoreClass(ClassElement classElement) =>
    _toStringAnnotationChecker.hasAnnotationOfExact(classElement);

bool hasGeneratedToString(BuilderOptions options, ClassElement? classElement) {
  const fieldKey = 'hasToString';

  if (classElement != null && isStoreConfigAnnotatedStoreClass(classElement)) {
    final annotation =
        _toStringAnnotationChecker.firstAnnotationOfExact(classElement);
    return annotation?.getField(fieldKey)?.toBoolValue() ?? false;
  }

  if (options.config.containsKey(fieldKey)) {
    return options.config[fieldKey]! as bool;
  }

  return true;
}

bool _any(List<bool> list) => list.any(_identity);

T _identity<T>(T value) => value;
