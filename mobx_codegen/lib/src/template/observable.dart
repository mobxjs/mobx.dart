import 'package:meta/meta.dart';
import 'package:mobx_codegen/src/template/store.dart';
import 'package:mobx_codegen/src/utils/non_private_name_extension.dart';

class ObservableTemplate {
  ObservableTemplate({
    required this.storeTemplate,
    required this.atomName,
    required this.type,
    required this.name,
    this.isReadOnly = false,
    this.isPrivate = false,
  });

  final StoreTemplate storeTemplate;
  final String atomName;
  final String type;
  final String name;
  final bool isPrivate;
  final bool isReadOnly;

  /// Formats the `name` from `_foo_bar` to `foo_bar`
  /// such that the getter gets public
  @visibleForTesting
  String get getterName {
    if (isReadOnly) {
      return name.nonPrivateName;
    }
    return name;
  }

  String _buildGetters() {
    if (isReadOnly) {
      return '''
  $type get $getterName {
    $atomName.reportRead();
    return super.$name;
  }

  @override
  $type get $name => $getterName;''';
    }
    return '''
  @override
  $type get $getterName {
    $atomName.reportRead();
    return super.$name;
  }''';
  }

  @override
  String toString() => """
  late final $atomName = Atom(name: '${storeTemplate.parentTypeName}.$name', context: context);

${_buildGetters()}

  @override
  set $name($type value) {
    $atomName.reportWrite(value, super.$name, () {
      super.$name = value;
    });
  }""";
}
