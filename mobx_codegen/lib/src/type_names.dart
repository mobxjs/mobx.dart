import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/resolver/scope.dart';
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

  final LibraryElement library;

  Map<Element, String> _namesByElement;
  Map<Element, String> get namesByElement {
    if (_namesByElement != null) {
      return _namesByElement;
    }

    // Reverse each import's export namespace, so that we can easily map
    // Elements to names.
    _namesByElement = {};
    final namespaceBuilder = NamespaceBuilder();
    for (final import in library.imports) {
      // Build a namespace so that combinators (show/hide) can be computed
      final namespace =
          namespaceBuilder.createImportNamespaceForDirective(import);

      // Record each element by name
      for (final entry in namespace.definedNames.entries) {
        _namesByElement[entry.value] = entry.key;
      }
    }

    return _namesByElement;
  }

  String findVariableTypeName(VariableElement variable) =>
      _getTypeName(variable.type);

  String findGetterTypeName(PropertyAccessorElement getter) {
    assert(getter.isGetter);
    return findReturnTypeName(getter);
  }

  String findParameterTypeName(ParameterElement parameter) =>
      _getTypeName(parameter.type);

  String findReturnTypeName(FunctionTypedElement executable) =>
      _getTypeName(executable.returnType);

  List<String> findReturnTypeArgumentTypeNames(ExecutableElement executable) {
    final returnType = executable.returnType;
    return returnType is ParameterizedType
        ? returnType.typeArguments.map(_getTypeName).toList()
        : [];
  }

  String findTypeParameterBoundsTypeName(TypeParameterElement typeParameter) {
    assert(typeParameter.bound != null);
    return _getTypeName(typeParameter.bound);
  }

  /// Calculates a type name, including its type arguments
  ///
  /// The returned string will include import prefixes on all applicable types.
  String _getTypeName(DartType type) {
    final typeElement = type.element;
    if (type is FunctionType) {
      // A type with a typedef should be written as is
      if (typeElement is GenericFunctionTypeElement &&
          typeElement.enclosingElement is GenericTypeAliasElement) {
        return typeElement.enclosingElement.displayName;
      }

      return _findFunctionTypeName(type);
    } else if (
        // If the library has no named imports, we don't need to worry about
        // prefixes
        library.prefixes.isEmpty ||
            // Some types don't have associated elements, like void
            typeElement == null ||
            // This is a bare type param, like "T"
            type is TypeParameterType ||
            // If the type lives in this library, no prefix necessary
            typeElement.library == library) {
      // TODO(shyndman): This ignored deprecation can be removed when we
      // increase the analyzer dependency's lower bound to 0.39.2, and
      // migrate to using `DartType.getDisplayString`.
      // ignore: deprecated_member_use
      return type.displayName;
    }

    assert(namesByElement.containsKey(typeElement));
    return namesByElement[typeElement];
  }

  String _findFunctionTypeName(FunctionType type) {
    final returnTypeName = _getTypeName(type.returnType);

    final normalParameterTypeNames =
        CommaList(type.normalParameterTypes.map(_getTypeName).toList());
    final optionalParameterTypeNames = SurroundedCommaList(
        '[', ']', type.optionalParameterTypes.map(_getTypeName).toList());
    final namedParameterPairs = type.namedParameterTypes.entries
        .map((entry) => '${_getTypeName(entry.value)} ${entry.key}')
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
}
