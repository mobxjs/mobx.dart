import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/store_class_visitor.dart';
import 'package:mobx_codegen/src/template/store_file.dart';
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
      if (isMixinStoreClass(classElement)) {
        yield* _generateCodeForMixinStore(library, classElement);
      } else if (isAnnotatedStoreClass(classElement)) {
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
    // Strip off leading underscore
    final publicTypeName = baseClass.name.replaceFirst(RegExp('^_'), '');
    yield _generateCodeFromTemplate(
        publicTypeName, baseClass, SubclassStoreTemplate());
  }

  String _generateCodeFromTemplate(
    String publicTypeName,
    ClassElement userStoreClass,
    StoreTemplate template,
  ) {
    final visitor = StoreClassVisitor(publicTypeName, userStoreClass, template);
    userStoreClass
      ..accept(visitor)
      ..visitChildren(visitor);
    return visitor.source;
  }
}
