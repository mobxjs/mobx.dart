class ComputedTemplate {
  String computedName;
  String type;
  String name;

  String toString() => """
  Computed<$type> $computedName;

  @override
  $type get $name => ($computedName ??= Computed<$type>(() => super.$name)).value;""";
}
