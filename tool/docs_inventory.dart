// Regenerate the reference from resolved public exports, including show/hide.
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';

Future<void> main(List<String> args) async {
  final root = Directory.current.absolute.path;
  final collection = AnalysisContextCollection(includedPaths: [root]);
  final inventory = <Map<String, Object?>>[];
  for (final spec in [
    ('mobx', 'mobx.dart'),
    ('flutter_mobx', 'flutter_mobx.dart'),
    ('mobx_codegen', 'mobx_codegen.dart'),
    ('mobx_codegen', 'builder.dart'),
    ('mobx_lint', 'mobx_lint.dart'),
    ('mobx_lint', 'version.dart'),
  ]) {
    final (package, library) = spec;
    final file = '$root/$package/lib/$library';
    if (!File(file).existsSync()) continue;
    final result =
        await collection
                .contextFor(file)
                .currentSession
                .getResolvedLibrary(file)
            as ResolvedLibraryResult;
    for (final entry in result.element.exportNamespace.definedNames2.entries) {
      final element = entry.value;
      final members = <Element>[];
      if (element is InterfaceElement) {
        members.addAll([
          ...element.constructors,
          ...element.fields,
          ...element.getters,
          ...element.setters,
          ...element.methods,
        ]);
      }
      if (element is ExtensionElement) {
        members.addAll([
          ...element.getters,
          ...element.setters,
          ...element.methods,
        ]);
      }
      inventory.add({
        'package': package,
        'library': library,
        'name': entry.key,
        'kind': element.kind.displayName,
        'signature': element.displayString(),
        'description': element.documentationComment ?? '',
        'members': [
          for (final m in members.where((m) => m.isPublic))
            {
              'name': m.displayName,
              'signature': m.displayString(),
              'description': m.documentationComment ?? '',
            },
        ],
      });
    }
  }
  inventory.sort(
    (a, b) => '${a['package']}/${a['name']}'.compareTo(
      '${b['package']}/${b['name']}',
    ),
  );
  final json = '${const JsonEncoder.withIndent('  ').convert(inventory)}\n';
  final target = File('$root/docs/api-inventory.json');
  if (args.contains('--check')) {
    if (!target.existsSync() || target.readAsStringSync() != json) {
      stderr.writeln(
        'Public API reference is stale. Run dart run tool/docs_inventory.dart',
      );
      exitCode = 1;
    }
  } else {
    target.writeAsStringSync(json);
  }
  print('${inventory.length} exported declarations inspected.');
}
