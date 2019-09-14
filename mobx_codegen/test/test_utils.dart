import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mobx_codegen/mobx_codegen.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

class TestInfo {
  const TestInfo({this.description, this.source, this.output});

  final String description;
  final String output;
  final String source;
}

const String pkgName = 'generator_sample';

Future<String> generate(String source) async {
// Recreate generator for each test because we repeatedly create
// classes with the same name in the same library, which will clash.
  final Builder builder = PartBuilder([StoreGenerator()], '.g.dart');

  final srcs = {
    '$pkgName|lib/generator_sample.dart': source,
  };

  final errors = <String>[];
  void captureError(LogRecord logRecord) {
    if (logRecord.level == Level.SEVERE) {
      errors.add(logRecord.message);
    }
  }

  final writer = InMemoryAssetWriter();
  await testBuilder(builder, srcs,
      rootPackage: pkgName,
      reader: await PackageAssetReader.currentIsolate(),
      writer: writer,
      onLog: captureError);

  return errors.isNotEmpty
      ? errors.join('\n')
      : String.fromCharCodes(
          writer.assets[AssetId(pkgName, 'lib/generator_sample.g.dart')] ?? []);
}

String getFilePath(String filename) {
  final context = path.Context(
      style: Platform.isWindows ? path.Style.windows : path.Style.posix);
  final baseDir = context.dirname(Platform.script.path);
  var filePath = context.join(baseDir, filename);
  filePath = context.fromUri(context.normalize(filePath));
  filePath = context.fromUri(filePath).split('file:').last;

  return filePath;
}

Future<String> readFile(String filename) {
  final path = getFilePath(filename);

  return File(path).readAsString();
}

void createTests(List<TestInfo> tests) {
  // ignore: avoid_function_literals_in_foreach_calls
  tests.forEach((t) {
    test(t.description, () async {
      final source = await readFile(t.source);
      final generatedOutput = await generate(source);
      final output = await readFile(t.output);

      expect(generatedOutput.trim(), endsWith(output.trim()));
    });
  });
}
