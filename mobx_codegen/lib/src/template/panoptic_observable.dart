import 'package:mobx_codegen/src/template/store.dart';

class PanopticObservableTemplate {
  StoreTemplate storeTemplate;
  String observableName;
  String type;
  String sourceName;

  @override
  String toString() => '''
    final $observableName =
        Observable(name: '${storeTemplate.parentTypeName}.$sourceName');

    @override
    $type get $sourceName {
      $observableName.context.enforceReadPolicy($observableName);
      $observableName.reportObserved();
      return super.$sourceName;
    }

    @override
    set $sourceName($type value) {
      $observableName.context.conditionallyRunInAction(() {
        super.$sourceName = value;
        $observableName.reportChanged();
      }, $observableName, name: '\${$observableName.name}_set');
    }
  ''';
}
