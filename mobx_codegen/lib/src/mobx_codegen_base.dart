import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:build/build.dart';
import 'package:mobx_codegen/src/store_class_visitor.dart';
import 'package:mobx_codegen/src/template/store_file.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/type_names.dart';
import 'package:source_gen/source_gen.dart';

class StoreGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.allElements.isEmpty) {
      return '';
    }

    // TODO(shyndman): This ignored deprecation can be removed when we
    // increase the analyzer dependency's lower bound to 0.39.1, and
    // migrate to using `LibraryElement.typeSystem`.
    // ignore: deprecated_member_use
    final typeSystem = await library.allElements.first.session.typeSystem;
    final file = StoreFileTemplate()
      ..storeSources = _generateCodeForLibrary(library, typeSystem).toSet();
    return file.toString();
  }

  Iterable<String> _generateCodeForLibrary(
    LibraryReader library,
    TypeSystem typeSystem,
  ) sync* {
    for (final classElement in library.classes) {
      if (isMixinStoreClass(classElement)) {
        yield* _generateCodeForMixinStore(library, classElement, typeSystem);
      }
    }
  }

  Iterable<String> _generateCodeForMixinStore(
    LibraryReader library,
    ClassElement baseClass,
    TypeSystem typeSystem,
  ) sync* {
    final typeNameFinder = LibraryScopedNameFinder(library.element);
    final otherClasses = library.classes.where((c) => c != baseClass);
    final mixedClass = otherClasses.firstWhere((c) {
      // If our base class has different type parameterization requirements than
      // the class we're evaluating provides, we know it's not a subclass.
      if (baseClass.typeParameters.length != c.supertype.typeArguments.length) {
        return false;
      }

      // Apply the subclass' type arguments to the base type (if there are none
      // this has no impact), and perform a supertype check.
      return typeSystem.isSubtypeOf(
          // TODO(shyndman): This ignored deprecation can be removed when we
          // increase the analyzer dependency's lower bound to 0.38.2, and
          // migrate to using `ClassElement.instantiate`.
          // ignore: deprecated_member_use
          c.type,
          baseClass.instantiate(
              typeArguments: c.supertype.typeArguments,
              nullabilitySuffix: NullabilitySuffix.none));
    }, orElse: () => null);

    if (mixedClass != null) {
      yield _generateCodeFromTemplate(
          mixedClass.name, baseClass, MixinStoreTemplate(), typeNameFinder);
    }
  }

  String _generateCodeFromTemplate(
    String publicTypeName,
    ClassElement userStoreClass,
    StoreTemplate template,
    LibraryScopedNameFinder typeNameFinder,
  ) {
    final visitor = StoreClassVisitor(
        publicTypeName, userStoreClass, template, typeNameFinder);
    userStoreClass
      ..accept(visitor)
      ..visitChildren(visitor);
    return visitor.source;
  }
}
