import 'package:analyzer/dart/element/element.dart';
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

  final LibraryElement library;

  final Map<Element, String?> _namesByElement = {};

  Map<Element, String?> get namesByElement {
    // Add all of this library's type-defining elements to the name map
    final libraryElements =
        library.topLevelElements.whereType<TypeDefiningElement>();
    for (final element in libraryElements) {
      _namesByElement[element] = element.name;
    }

    // Reverse each import's export namespace so we can map elements to their
    // library-local names. Note that the definedNames include a prefix if there
    // is one.
    // ignore: deprecated_member_use
    for (final import in library.libraryImports) {
      for (final entry in import.namespace.definedNames.entries) {
        _namesByElement[entry.value] = entry.key;
      }
    }

    return _namesByElement;
  }

  String findVariableTypeName(VariableElement variable) =>
      _getDartTypeName(variable.type);

  String findGetterTypeName(PropertyAccessorElement getter) {
    assert(getter.isGetter);
    return findReturnTypeName(getter);
  }

  String findParameterTypeName(ParameterElement parameter) =>
      _getDartTypeName(parameter.type);

  String findReturnTypeName(FunctionTypedElement executable) =>
      _getDartTypeName(executable.returnType);

  List<String?> findReturnTypeArgumentTypeNames(ExecutableElement executable) {
    final returnType = executable.returnType;
    return returnType is ParameterizedType
        ? returnType.typeArguments.map(_getDartTypeName).toList()
        : [];
  }

  String? findTypeParameterBoundsTypeName(TypeParameterElement typeParameter) {
    assert(typeParameter.bound != null);
    return _getDartTypeName(typeParameter.bound!);
  }

  /// Calculates a type name, including its type arguments
  ///
  /// The returned string will include import prefixes on all applicable types.
  String _getDartTypeName(DartType type) {
    var typeElement = type.element;
    if (type is FunctionType) {
      // If we're dealing with a typedef, we let it undergo the standard name
      // lookup. Otherwise, we special case the function naming.
      if (type.alias?.element is TypeAliasElement) {
        // ignore: deprecated_member_use
        typeElement = type.alias!.element.aliasedElement?.enclosingElement;
      } else {
        return _getFunctionTypeName(type);
      }
    } else if (
        // Some types don't have associated elements, like void
        typeElement == null ||
            // This is a bare type param, like "T"
            type is TypeParameterType) {
      // ignore: deprecated_member_use
      return type.getDisplayString(withNullability: true);
    }

    return _getNamedElementTypeName(typeElement!, type);
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

  String _getNamedElementTypeName(Element typeElement, DartType type) {
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
