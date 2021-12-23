import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mobx_codegen/mobx_codegen.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

class TestInfo {
  const TestInfo(
      {required this.description, required this.source, required this.output});

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
      // If we've encountered an exception, print to stderr for easier debugging
      if (logRecord.error != null) {
        stderr.writeln(
            '${logRecord.message}\n${logRecord.error}${logRecord.stackTrace}');
      }

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
  final baseDir = context.dirname(Directory.current.path);
  var filePath = context.join(baseDir, 'mobx_codegen/test/', filename);
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
      await compareFiles(t.source, t.output);
    });
  });
}

Future<void> compareFiles(String sourceFile, String outputFile) async {
  final source = await readFile(sourceFile);
  final generatedOutput = await generate(source);
  final output = await readFile(outputFile);

  expect(removeIndent(generatedOutput), endsWith(removeIndent(output)));
}

String removeIndent(String text) {
  final lines = text.trim().split('\n');
  return lines.map((line) => line.trim()).join('\n');
}
