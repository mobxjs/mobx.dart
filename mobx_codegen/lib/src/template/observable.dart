import 'package:mobx_codegen/src/template/store.dart';

class ObservableTemplate {
  StoreTemplate storeTemplate;
  String atomName;
  String type;
  String name;
  bool isPrivate;
  bool isReadOnly;

  /// Formats the `name` from `_foo_bar` to `foo_bar`
  /// such that the getter gets public
  String get _getterName {
    if (isReadOnly) {
      final nameWithoutUnderline = name.replaceAll(RegExp(r'^_*'), '');
      return nameWithoutUnderline;
    }
    return name;
  }

  @override
  String toString() => """
  final $atomName = Atom(name: '${storeTemplate.parentTypeName}.$name');

  @override
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
