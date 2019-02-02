import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mobx_codegen/src/template/comma_list.dart';

class MethodOverrideTemplate {
  MethodOverrideTemplate();

  MethodOverrideTemplate.fromElement(MethodElement method) {
    final typeParam = (TypeParameterElement elem) => TypeParamTemplate()
      ..name = elem.name
      ..bound = elem.bound?.displayName;

    final param = (ParameterElement elem) => ParamTemplate()
      ..name = elem.name
      ..type = elem.type.displayName
      ..defaultValue = elem.defaultValueCode;

    final positionalParams = method.parameters
        .where((param) => param.isPositional && !param.isOptionalPositional)
        .toList();

    final optionalParams =
        method.parameters.where((param) => param.isOptionalPositional).toList();

    final namedParams =
        method.parameters.where((param) => param.isNamed).toList();

    final returnType = method.returnType;
    final returnTypeArgs = returnType is ParameterizedType
        ? returnType.typeArguments.map((p) => p.displayName).toList()
        : <String>[];

    this
      ..name = method.name
      ..returnType = method.returnType.displayName
      ..setTypeParams(method.typeParameters.map(typeParam))
      ..positionalParams = positionalParams.map(param)
      ..optionalParams = optionalParams.map(param)
      ..namedParams = namedParams.map(param)
      ..returnTypeArgs = SurroundedCommaList('<', '>', returnTypeArgs);
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

  setTypeParams(Iterable<TypeParamTemplate> params) {
    _typeParams = SurroundedCommaList('<', '>', params.toList());
    _typeArgs =
        SurroundedCommaList('<', '>', params.map((p) => p.asArgument).toList());
  }

  set positionalParams(Iterable<ParamTemplate> params) {
    _positionalParams = CommaList(params.toList());
    _positionalArgs = CommaList(params.map((p) => p.asArgument).toList());
  }

  set optionalParams(Iterable<ParamTemplate> params) {
    _optionalParams = SurroundedCommaList('[', ']', params.toList());
    _optionalArgs = CommaList(params.map((p) => p.asArgument).toList());
  }

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

class ParamTemplate {
  String name;
  String type;
  String defaultValue;

  String get asArgument => name;

  NamedArgTemplate get asNamedArgument => NamedArgTemplate()..name = name;

  @override
  String toString() =>
      defaultValue == null ? '$type $name' : '$type $name = $defaultValue';
}

class TypeParamTemplate {
  String name;
  String bound;

  String get asArgument => name;

  @override
  String toString() => bound == null ? name : '$name extends $bound';
}

class NamedArgTemplate {
  String name;

  @override
  String toString() => '$name: $name';
}
