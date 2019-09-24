// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

String findVariableTypeName(VariableElement variable) {
  if (!_isTypeDynamic(variable.type)) {
    return variable.type.displayName;
  }

  return _findElementNode<VariableDeclarationList>(variable).type.toSource();
}

String findGetterTypeName(PropertyAccessorElement getter) {
  assert(getter.isGetter);
  return findReturnTypeName(getter);
}

String findSetterTypeName(PropertyAccessorElement setter) {
  assert(setter.isSetter);
  return findParameterTypeName(setter.parameters.first);
}

String findParameterTypeName(ParameterElement parameter) {
  if (!_isTypeDynamic(parameter.type)) {
    return parameter.type.displayName;
  }

  // If we're dealing with a parameter of the format `this.field`, let's look
  // up the corresponding field or property element, and grab its type.
  if (parameter.isInitializingFormal) {
    return _findInitializingParameterTypeName(parameter);
  }

  final node =
      _findElementNode<DefaultFormalParameter>(parameter)?.parameter ??
      _findElementNode<NormalFormalParameter>(parameter);
  if (node is SimpleFormalParameter && node.type != null) {
    return node.type.toString();
  } else {
    return 'dynamic';
  }
}

String _findInitializingParameterTypeName(ParameterElement parameter) {
  final ClassElement classElement = parameter.enclosingElement.enclosingElement;

  final correspondingField = classElement.getField(parameter.name);
  if (correspondingField != null && !correspondingField.isSynthetic) {
    return findVariableTypeName(correspondingField);
  }

  final correspondingSetter = classElement.getSetter(parameter.name);
  if (correspondingSetter != null && !correspondingSetter.isSynthetic) {
    return findSetterTypeName(correspondingSetter);
  }

  return 'dynamic';
}

String findReturnTypeName(ExecutableElement executable) {
  if (!_isTypeDynamic(executable.returnType)) {
    return executable.returnType.displayName;
  }

  return _findReturnType(executable)?.toSource() ?? 'dynamic';
}

List<String> findReturnTypeArgumentTypeNames(ExecutableElement executable) {
  if (!_isTypeDynamic(executable.returnType)) {
    final type = executable.returnType;
    return type is ParameterizedType
        ? type.typeArguments.map((argType) => argType.displayName).toList()
        : [];
  }

  final returnType = _findReturnType(executable);
  if (returnType is NamedType && returnType.typeArguments != null) {
    return returnType.typeArguments.arguments
        .map((arg) => arg.toSource())
        .toList();
  }

  return [];
}

String findTypeParameterBoundsTypeName(TypeParameterElement typeParameter) {
  if (!_isTypeDynamic(typeParameter.bound)) {
    return typeParameter.bound.displayName;
  }

  return _findElementNode<TypeParameter>(typeParameter).bound.toSource();
}

TypeAnnotation _findReturnType(ExecutableElement executable) =>
    _findElementNode<FunctionDeclaration>(executable)?.returnType ??
    _findElementNode<MethodDeclaration>(executable)?.returnType;

/// Returns `true` if [type], or one of [type]'s type arguments, is dynamic.
bool _isTypeDynamic(DartType type) =>
    type.isDynamic ||
    (type is ParameterizedType && type.typeArguments.any(_isTypeDynamic));

/// Returns [element]'s closest matching AST node ancestor of type [T], or
/// `null` if not found.
T _findElementNode<T extends AstNode>(Element element) {
  final parsedLibrary =
      element.session.getParsedLibraryByElement(element.library);
  final elementDeclaration = parsedLibrary.getElementDeclaration(element);

  // For whatever reason, sometimes the element declaration doesn't contain the
  // AST node we're looking for. In this case, we use a NodeLocator to find the
  // node in the element's compilation unit.
  final node = elementDeclaration.node ??
      NodeLocator(element.nameOffset)
          .searchWithin(elementDeclaration.parsedUnit.unit);
  return node.thisOrAncestorOfType<T>();
}
