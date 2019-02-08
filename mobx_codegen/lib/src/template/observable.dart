import 'package:mobx_codegen/src/template/store.dart';

class ObservableTemplate {
  StoreTemplate storeTemplate;
  String atomName;
  String type;
  String name;

  @override
  String toString() => """
  final $atomName = Atom(name: '${storeTemplate.parentName}.$name');

  @override
  $type get $name {
    $atomName.reportObserved();
    return super.$name;
  }

  @override
  set $name($type value) {
    mainContext.checkIfStateModificationsAreAllowed($atomName);
    super.$name = value;
    $atomName.reportChanged();
  }""";
}
