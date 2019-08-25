import 'package:analyzer/dart/element/element.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';
import 'package:mobx_codegen/src/template/params.dart';
import 'package:mobx_codegen/src/template/util.dart';
import 'package:mobx_codegen/src/type_names.dart';

/// Stores templating information about constructors and methods.
class MethodOverrideTemplate {
  MethodOverrideTemplate();

  MethodOverrideTemplate.fromElement(ExecutableElement method) {
    // ignore: prefer_function_declarations_over_variables
    final param = (ParameterElement elem) => ParamTemplate()
      ..name = elem.name
      ..type = findParameterTypeName(elem)
      ..defaultValue = elem.defaultValueCode;

    final positionalParams = method.parameters
        .where((param) => param.isPositional && !param.isOptionalPositional)
        .toList();

    final optionalParams =
        method.parameters.where((param) => param.isOptionalPositional).toList();

    final namedParams =
        method.parameters.where((param) => param.isNamed).toList();

    this
      ..name = method.name
      ..returnType = findReturnTypeName(method)
      ..setTypeParams(method.typeParameters.map(typeParamTemplate))
      ..positionalParams = positionalParams.map(param)
      ..optionalParams = optionalParams.map(param)
      ..namedParams = namedParams.map(param)
      ..returnTypeArgs = SurroundedCommaList(
          '<', '>', findReturnTypeArgumentTypeNames(method));
  }

  String name;
  String returnType;
  SurroundedCommaList<String> returnTypeArgs;

  SurroundedCommaList<TypeParamTemplate> _typeParams;
  SurroundedCommaList<String> _typeArgs;

  CommaList<ParamTemplate> _positionalParams;
  SurroundedCommaList<ParamTemplate> _optionalParams;
  SurroundedCommaList<ParamTemplate> _namedParams;

  CommaList<String> _positionalArgs;
  CommaList<String> _optionalArgs;
  CommaList<NamedArgTemplate> _namedArgs;

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
