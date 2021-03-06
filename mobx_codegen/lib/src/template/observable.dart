import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/utils/non_private_name_extension.dart';

class ObservableTemplate {
  StoreTemplate storeTemplate;
  String atomName;
  String type;
  String name;
  bool isPrivate;
  bool isReadOnly;

  String get _getterName {
    if (isReadOnly) {
      return name.nonPrivateName;
    }
    return name;
  }

  @override
  String toString() => """
  final $atomName = Atom(name: '${storeTemplate.parentTypeName}.$name');

  ${isReadOnly ? '' : '@override'}
  $type get $_getterName {
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
