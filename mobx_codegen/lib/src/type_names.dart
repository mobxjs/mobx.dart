// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/element/element.dart';

String findVariableTypeName(VariableElement variable) =>
    _findElementNode<VariableDeclarationList>(variable).type.toSource();

String findGetterTypeName(PropertyAccessorElement getter) {
  assert(getter.isGetter);
  return findReturnTypeName(getter);
}

String findSetterTypeName(PropertyAccessorElement setter) {
  assert(setter.isSetter);
  return findParameterTypeName(setter.parameters.first);
}

String findParameterTypeName(ParameterElement parameter) {
  // If we're dealing with a parameter of the format `this.field`, let's look
  // up the corresponding field or property element, and grab its type.
  if (parameter.isInitializingFormal) {
    return _findInitializingParameterTypeName(parameter);
  }

  final node = _findElementNode<DefaultFormalParameter>(parameter)?.parameter ??
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

String findReturnTypeName(ExecutableElement executable) =>
    _findReturnType(executable)?.toSource() ?? 'dynamic';

List<String> findReturnTypeArgumentTypeNames(ExecutableElement executable) {
  final returnType = _findReturnType(executable);
  if (returnType is NamedType && returnType.typeArguments != null) {
    return returnType.typeArguments.arguments
        .map((arg) => arg.toSource())
        .toList();
  }

  return [];
}

String findTypeParameterBoundsTypeName(TypeParameterElement typeParameter) =>
    _findElementNode<TypeParameter>(typeParameter).bound.toSource();

TypeAnnotation _findReturnType(ExecutableElement executable) =>
    _findElementNode<FunctionDeclaration>(executable)?.returnType ??
    _findElementNode<MethodDeclaration>(executable)?.returnType;

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
