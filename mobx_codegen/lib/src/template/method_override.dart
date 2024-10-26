import 'package:analyzer/dart/element/element.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';
import 'package:mobx_codegen/src/template/params.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mobx_codegen/src/type_names.dart';

/// Stores templating information about constructors and methods.
class MethodOverrideTemplate {
  MethodOverrideTemplate();

  MethodOverrideTemplate.fromElement(
    ExecutableElement method,
    LibraryScopedNameFinder typeNameFinder,
  ) {
    // ignore: prefer_function_declarations_over_variables
    final param = (ParameterElement element) => ParamTemplate(
        name: element.name,
        type: typeNameFinder.findParameterTypeName(element),
        defaultValue: element.defaultValueCode,
        hasRequiredKeyword: element.isRequiredNamed);

    final positionalParams = method.parameters
        .where((param) => param.isPositional && !param.isOptionalPositional)
        .toList();

    final optionalParams =
        method.parameters.where((param) => param.isOptionalPositional).toList();

    final namedParams =
        method.parameters.where((param) => param.isNamed).toList();

    this
      ..name = method.name
      ..returnType = typeNameFinder.findReturnTypeName(method)
      ..setTypeParams(method.typeParameters
          .map((type) => typeParamTemplate(type, typeNameFinder)))
      ..positionalParams = positionalParams.map(param)
      ..optionalParams = optionalParams.map(param)
      ..namedParams = namedParams.map(param)
      ..returnTypeArgs = SurroundedCommaList(
          '<', '>', typeNameFinder.findReturnTypeArgumentTypeNames(method));
  }

  late String name;
  late String returnType;
  late SurroundedCommaList<String?> returnTypeArgs;

  late SurroundedCommaList<TypeParamTemplate> _typeParams;
  late SurroundedCommaList<String> _typeArgs;

  late CommaList<ParamTemplate> _positionalParams;
  late SurroundedCommaList<ParamTemplate> _optionalParams;
  late SurroundedCommaList<ParamTemplate> _namedParams;

  late CommaList<String> _positionalArgs;
  late CommaList<String> _optionalArgs;
  late CommaList<NamedArgTemplate> _namedArgs;

  // ignore: always_declare_return_types, type_annotate_public_apis
  setTypeParams(Iterable<TypeParamTemplate> params) {
    _typeParams = SurroundedCommaList('<', '>', params.toList());
    _typeArgs =
        SurroundedCommaList('<', '>', params.map((p) => p.asArgument).toList());
  }

  // ignore: avoid_setters_without_getters
  set positionalParams(Iterable<ParamTemplate> params) {
    _positionalParams = CommaList(params.toList());
    _positionalArgs = CommaList(params.map((p) => p.asArgument).toList());
  }

  // ignore: avoid_setters_without_getters
  set optionalParams(Iterable<ParamTemplate> params) {
    _optionalParams = SurroundedCommaList('[', ']', params.toList());
    _optionalArgs = CommaList(params.map((p) => p.asArgument).toList());
  }

  // ignore: avoid_setters_without_getters
  set namedParams(Iterable<ParamTemplate> params) {
    _namedParams = SurroundedCommaList('{', '}', params.toList());
    _namedArgs = CommaList(params.map((p) => p.asNamedArgument).toList());
  }

  CommaList get params =>
      CommaList([_positionalParams, _optionalParams, _namedParams]);

  CommaList get args => CommaList([_positionalArgs, _optionalArgs, _namedArgs]);

  SurroundedCommaList<TypeParamTemplate> get typeParams => _typeParams;

  SurroundedCommaList<String> get typeArgs => _typeArgs;
}
