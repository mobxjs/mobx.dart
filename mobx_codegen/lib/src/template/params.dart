class ParamTemplate {
  ParamTemplate(
      {required this.name,
      required this.type,
      this.defaultValue,
      this.hasRequiredKeyword = false});

  final String name;
  final String type;
  final String? defaultValue;

  final bool hasRequiredKeyword;

  String get asArgument => name;

  NamedArgTemplate get asNamedArgument => NamedArgTemplate(name: name);

  String get metadata => hasRequiredKeyword ? 'required ' : '';

  @override
  String toString() => defaultValue == null
      ? '$metadata$type $name'
      : '$type $name = $defaultValue';
}

class TypeParamTemplate {
  TypeParamTemplate({required this.name, this.bound});

  final String name;

  final String? bound;

  String get asArgument => name;

  @override
  String toString() => bound == null ? name : '$name extends $bound';
}

class NamedArgTemplate {
  NamedArgTemplate({required this.name});

  final String name;

  @override
  String toString() => '$name: $name';
}
