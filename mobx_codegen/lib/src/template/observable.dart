import 'package:mobx_codegen/src/template/store.dart';

class ObservableTemplate {
  StoreTemplate storeTemplate;
  String atomName;
  String type;
  String name;
  bool isPrivate;

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
    final oldValue = super.$name;
    if (_reportOnEqualSet || value != oldValue) {
      $atomName.reportWrite(value, super.$name, () {
        super.$name = value;
      });
    }
  }""";
}
