import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:build/build.dart';
import 'package:mobx_codegen/src/store_class_visitor.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/template/store_file.dart';
import 'package:mobx_codegen/src/type_names.dart';
import 'package:source_gen/source_gen.dart';

class StoreGenerator extends Generator {
  final BuilderOptions options;

  StoreGenerator([this.options = BuilderOptions.empty]);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.allElements.isEmpty) {
      return '';
    }

    final typeSystem = library.element.typeSystem;
    final file = StoreFileTemplate(
        storeSources: _generateCodeForLibrary(library, typeSystem).toSet());
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
    try {
      final mixedClass = otherClasses.firstWhere((c) {
        // If our base class has different type parameterization requirements than
        // the class we're evaluating provides, we know it's not a subclass.
        if (baseClass.typeParameters.length !=
            c.supertype!.typeArguments.length) {
          return false;
        }

        // Apply the subclass' type arguments to the base type (if there are none
        // this has no impact), and perform a supertype check.
        return typeSystem.isSubtypeOf(
          c.thisType,
          baseClass.instantiate(
              typeArguments: c.supertype!.typeArguments,
              nullabilitySuffix: NullabilitySuffix.none),
        );
      });

      yield _generateCodeFromTemplate(
          mixedClass.name, baseClass, MixinStoreTemplate(), typeNameFinder);
      // ignore: avoid_catching_errors
    } on StateError {
      // ignore the case when no element is found
    }
  }

  String _generateCodeFromTemplate(
    String publicTypeName,
    ClassElement userStoreClass,
    StoreTemplate template,
    LibraryScopedNameFinder typeNameFinder,
  ) {
    final visitor = StoreClassVisitor(
        publicTypeName, userStoreClass, template, typeNameFinder, options);
    userStoreClass
      ..accept(visitor)
      ..visitChildren(visitor);
    return visitor.source;
  }
}
