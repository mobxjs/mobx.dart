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
    $atomName.context.enforceReadPolicy($atomName);
    $atomName.reportObserved();
    return super.$name;
  }

  @override
  set $name($type value) {
    // Since we are conditionally wrapping within an Action, there is no need to enforceWritePolicy
    if ($atomName.context.isWithinBatch) {
      super.$name = value;
      $atomName.reportChanged();
    } else {
      runInAction(() {
        super.$name = value;
        $atomName.reportChanged();
      });
    }
  }""";
}
