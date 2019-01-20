import 'package:mobx_codegen/src/template/comma_list.dart';
import 'package:mobx_codegen/src/template/store.dart';

class ActionTemplate {
  StoreTemplate storeTemplate;
  String name;
  String returnType;

  SurroundedCommaList<TypeParamTemplate> _typeParams;
  SurroundedCommaList<String> _typeArgs;

  CommaList<ParamTemplate> _positionalParams;
  SurroundedCommaList<ParamTemplate> _optionalParams;
  SurroundedCommaList<ParamTemplate> _namedParams;

  CommaList<String> _positionalArgs;
  CommaList<String> _optionalArgs;
  CommaList<NamedArgTemplate> _namedArgs;

  set typeParams(Iterable<TypeParamTemplate> params) {
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

  CommaList get _params =>
      CommaList([_positionalParams, _optionalParams, _namedParams]);

  CommaList get _args =>
      CommaList([_positionalArgs, _optionalArgs, _namedArgs]);

  @override
  String toString() => """
    @override
    $returnType $name$_typeParams($_params) {
      final _\$prevDerivation = ${storeTemplate.actionControllerName}.startAction();
      try {
        return super.$name$_typeArgs($_args);
      } finally {
        ${storeTemplate.actionControllerName}.endAction(_\$prevDerivation);
      }
    }""";
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
