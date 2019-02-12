import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:mobx/mobx.dart' show Store;
import 'package:mobx/src/api/annotations.dart'
    show ComputedMethod, MakeAction, MakeObservable;
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
import 'package:source_gen/source_gen.dart';

class StoreGenerator extends Generator {
  final _storeChecker = TypeChecker.fromRuntime(Store);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    final generate = (baseClass) sync* {
      final mixedClass = library.classes
          .firstWhere((c) => c.supertype == baseClass.type, orElse: () => null);
      if (mixedClass != null) {
        yield generateStoreClassCode(library, baseClass, mixedClass);
      }
    };

    return library.classes
        .where((c) => c.isAbstract)
        .where((c) => c.interfaces.any(_storeChecker.isExactlyType))
        .expand(generate)
        .toSet()
        .join('\n\n');
  }

  String generateStoreClassCode(
      LibraryReader library, ClassElement baseClass, ClassElement mixedClass) {
    final visitor = new StoreMixinVisitor(baseClass.name, mixedClass.name);
    baseClass.visitChildren(visitor);
    return visitor.source;
  }
}

class StoreMixinVisitor extends SimpleElementVisitor {
  StoreMixinVisitor(String parentName, String name)
      : _errors = StoreClassCodegenErrors(name) {
    _storeTemplate = StoreTemplate()
      ..parentName = parentName
      ..mixinName = '_\$$name';
  }

  final _observableChecker = TypeChecker.fromRuntime(MakeObservable);

  final _computedChecker = TypeChecker.fromRuntime(ComputedMethod);

  final _actionChecker = TypeChecker.fromRuntime(MakeAction);

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
  visitFieldElement(FieldElement element) async {
    if (!_observableChecker.hasAnnotationOfExact(element)) {
      return null;
    }

    if (_fieldIsNotValid(element)) {
      return null;
    }

    final template = ObservableTemplate()
      ..storeTemplate = _storeTemplate
      ..atomName = '_\$${element.name}Atom'
      ..type = element.type.displayName
      ..name = element.name;

    _storeTemplate.observables.add(template);
    return null;
  }

  bool _fieldIsNotValid(FieldElement element) => any([
        _errors.staticObservables.addIf(element.isStatic, element.name),
        _errors.finalObservables.addIf(element.isFinal, element.name)
      ]);

  @override
  visitPropertyAccessorElement(PropertyAccessorElement element) {
    if (!element.isGetter || !_computedChecker.hasAnnotationOfExact(element)) {
      return null;
    }

    final template = ComputedTemplate()
      ..computedName = '_\$${element.name}Computed'
      ..name = element.name
      ..type = element.returnType.displayName;
    _storeTemplate.computeds.add(template);

    return null;
  }

  @override
  visitMethodElement(MethodElement element) {
    if (_actionChecker.hasAnnotationOfExact(element)) {
      if (_actionIsNotValid(element)) {
        return null;
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
        return null;
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

    return null;
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
