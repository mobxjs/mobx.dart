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
    final buffer = StringBuffer()..writeln();
    if (!isReadOnly) {
      buffer.writeln('  @override');
    }
    buffer.writeln('''
  $type get $getterName {
    $atomName.reportRead();
    return super.$name;
  }''');
    if (isReadOnly) {
      buffer
        ..writeln()
        ..writeln('  @override')
        ..write('  $type get $name => $getterName;')
        ..writeln();
    }
    return buffer.toString();
  }

  @override
  String toString() => """
  final $atomName = Atom(name: '${storeTemplate.parentTypeName}.$name');
${_buildGetters()}
  @override
  set $name($type value) {
    $atomName.reportWrite(value, super.$name, () {
      super.$name = value;
    });
  }""";
}
