import 'package:mobx_codegen/src/template/store.dart';

class ComputedTemplate {
  ComputedTemplate(
      {required this.storeTemplate,
      required this.computedName,
      required this.type,
      required this.name,
      this.isPrivate = false,
      this.isKeepAlive});

  final StoreTemplate storeTemplate;
  final String computedName;
  final String type;
  final String name;
  final bool isPrivate;
  final bool? isKeepAlive;

  @override
  // ignore: prefer_single_quotes
  String toString() => """
  Computed<$type>? $computedName;

  @override
  $type get $name => ($computedName ??= Computed<$type>(() => super.$name, name: '${storeTemplate.parentTypeName}.$name'${isKeepAlive != null ? ', keepAlive: $isKeepAlive' : ''})).value;""";
}
