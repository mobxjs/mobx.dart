class ComputedTemplate {
  String computedName;
  String type;
  String name;

  String toString() => """
  Computed<$type> $computedName;

  @override
  $type get $name => $computedName.value;""";
}

class ComputedInitTemplate {
  String computedName;
  String type;
  String name;

  @override
  String toString() => "$computedName = Computed<$type>(() => super.$name);";
}
