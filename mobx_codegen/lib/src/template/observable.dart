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
    $atomName.context.enforceReadPolicy($atomName);
    $atomName.reportObserved();
    return super.$name;
  }

  @override
  set $name($type value) {
    $atomName.context.conditionallyRunInAction(() {
      super.$name = value;
      $atomName.reportChanged();
    }, $atomName, name: '\${$atomName.name}_set');
  }""";
}
