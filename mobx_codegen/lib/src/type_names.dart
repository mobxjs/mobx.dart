// https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/doc/element_model_migration_guide.md

// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';

/// Determines the names of types within the context of a library, determining
/// prefixes if applicable.
///
/// For example, if a library has been imported with a name, references to types
/// contained or exported by that library must be prefixed by that name.
///
/// ```dart
/// import 'dart:io' as io;
///
/// io.File someFile;
/// ```
///
/// If we had a reference to `someFile`'s [Element], [findVariableTypeName]
/// would return `"io.File"`.
class LibraryScopedNameFinder {
  LibraryScopedNameFinder(this.library);

  final LibraryElement2 library;

  final Map<Element2, String?> _namesByElement = {};

  Map<Element2, String?> get namesByElement {
    // Add all of this library's type-defining elements to the name map
    final libraryElements = library.children2.whereType<TypeDefiningElement2>();
    for (final element in libraryElements) {
      _namesByElement[element] = element.name3;
    }

    // Reverse each import's export namespace so we can map elements to their
    // library-local names.
    //
    // Prior to analyzer 7.4.0, definedNames included the import prefix, but it
    // no longer does with the new element API. This means we need to construct
    // it manually.

    final libraryImports = library.fragments
        .map((fragment) => fragment.libraryImports2)
        .expand((t) => t);

    for (final import in libraryImports) {
      final prefix = import.prefix2;
      for (final entry in import.namespace.definedNames2.entries) {
        _namesByElement[entry.value] = prefix?.name2 != null
            // If the prefix exists, we prepend it to the name
            ? '${prefix!.name2!}.${entry.key}'
            // Otherwise, we just use the name
            : entry.key;
      }
    }

    return _namesByElement;
  }

  String findVariableTypeName(VariableElement2 variable) =>
      _getDartTypeName(variable.type);

  String findGetterTypeName(GetterElement getter) {
    return findReturnTypeName(getter);
  }

  String findParameterTypeName(FormalParameterElement parameter) =>
      _getDartTypeName(parameter.type);

  String findReturnTypeName(FunctionTypedElement2 executable) =>
      _getDartTypeName(executable.returnType);

  List<String?> findReturnTypeArgumentTypeNames(ExecutableElement2 executable) {
    final returnType = executable.returnType;
    return returnType is ParameterizedType
        ? returnType.typeArguments.map(_getDartTypeName).toList()
        : [];
  }

  String? findTypeParameterBoundsTypeName(TypeParameterElement2 typeParameter) {
    assert(typeParameter.bound != null);
    return _getDartTypeName(typeParameter.bound!);
  }

  /// Calculates a type name, including its type arguments
  ///
  /// The returned string will include import prefixes on all applicable types.
  String _getDartTypeName(DartType type) {
    var typeElement = type.element3;
    if (type is FunctionType) {
      // If we're dealing with a typedef, we let it undergo the standard name
      // lookup. Otherwise, we special case the function naming.
      if (type.alias?.element2 is TypeAliasElement2) {
        typeElement = type.alias!.element2;
      } else {
        return _getFunctionTypeName(type);
      }
    } else if (
        // Some types don't have associated elements, like void
        typeElement == null ||
            // This is a bare type param, like "T"
            type is TypeParameterType) {
      return type.getDisplayString(withNullability: true);
    }

    return _getNamedElementTypeName(typeElement, type);
  }

  String _getFunctionTypeName(FunctionType type) {
    final returnTypeName = _getDartTypeName(type.returnType);

    final normalParameterTypeNames =
        CommaList(type.normalParameterTypes.map(_getDartTypeName).toList());
    final optionalParameterTypeNames = SurroundedCommaList(
        '[', ']', type.optionalParameterTypes.map(_getDartTypeName).toList());
    final namedParameterPairs = type.namedParameterTypes.entries
        .map((entry) => '${_getDartTypeName(entry.value)} ${entry.key}')
        .toList();
    final namedParameterTypeNames =
        SurroundedCommaList('{', '}', namedParameterPairs);

    final parameterTypeNames = CommaList([
      normalParameterTypeNames,
      optionalParameterTypeNames,
      namedParameterTypeNames,
    ]);

    return '$returnTypeName Function($parameterTypeNames)';
  }

  String _getNamedElementTypeName(Element2 typeElement, DartType type) {
    // Determine the name of the type, without type arguments.
    assert(namesByElement.containsKey(typeElement));

    List<DartType>? genericTypes;
    // If the type is parameterized, we recursively name its type arguments
    if (type is ParameterizedType) {
      genericTypes = type.typeArguments;
    } else if (type is FunctionType) {
      genericTypes = type.alias?.typeArguments;
    }

    if (genericTypes != null && genericTypes.isNotEmpty) {
      final typeArgNames = SurroundedCommaList(
          '<', '>', genericTypes.map(_getDartTypeName).toList());
      return '${namesByElement[typeElement]}$typeArgNames${_nullabilitySuffixToString(type.nullabilitySuffix)}';
    }

    return namesByElement[typeElement]! +
        _nullabilitySuffixToString(type.nullabilitySuffix);
  }

  String _nullabilitySuffixToString(NullabilitySuffix nullabilitySuffix) =>
      nullabilitySuffix == NullabilitySuffix.question ? '?' : '';
}
