import 'package:mobx_codegen/src/template/store.dart';

class ObservableTemplate {
  ObservableTemplate(
      {required this.storeTemplate,
      required this.atomName,
      required this.type,
      required this.name,
      this.isPrivate = false});

  final StoreTemplate storeTemplate;
  final String atomName;
  final String type;
  final String name;
  final bool isPrivate;

  @override
  String toString() => """
  final $atomName = Atom(name: '${storeTemplate.parentTypeName}.$name');

  @override
  $type get $name {
    $atomName.reportRead();
    return super.$name;
  }

  @override
  set $name($type value) {
    $atomName.reportWrite(value, super.$name, () {
      super.$name = value;
    });
  }""";
}
