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
