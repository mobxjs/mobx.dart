import 'package:mobx_codegen/src/template/store.dart';

class ComputedTemplate {
  StoreTemplate storeTemplate;
  String computedName;
  String type;
  String name;
  bool isPrivate;

  @override
  // ignore: prefer_single_quotes
  String toString() => """
  Computed<$type> $computedName;

  @override
  $type get $name => ($computedName ??= Computed<$type>(() => super.$name, name: '${storeTemplate.parentTypeName}.$name')).value;""";
}
