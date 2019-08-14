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

final String pkgName = 'generator_sample';

Future<String> generate(String source) async {
// Recreate generator for each test because we repeatedly create
// classes with the same name in the same library, which will clash.
  Builder builder = PartBuilder([StoreGenerator()], '.g.dart');

  final srcs = {
    '$pkgName|lib/generator_sample.dart': source,
  };

  String error;
  void captureError(LogRecord logRecord) {
    if (logRecord.level == Level.SEVERE) {
      error = logRecord.message;
    }
  }

  final writer = new InMemoryAssetWriter();
  await testBuilder(builder, srcs,
      rootPackage: pkgName,
      reader: await PackageAssetReader.currentIsolate(),
      writer: writer,
      onLog: captureError);

  return error ??
      new String.fromCharCodes(
          writer.assets[new AssetId(pkgName, 'lib/generator_sample.g.dart')] ??
              []);
}

String getFilePath(String filename) {
  var context = path.Context(
      style: Platform.isWindows ? path.Style.windows : path.Style.posix);
  var baseDir = context.dirname(Platform.script.path);
  var filePath = context.join(baseDir, filename);
  filePath = context.fromUri(context.normalize(filePath));
  filePath = context.fromUri(filePath).split('file:').last;

  return filePath;
}

Future<String> readFile(String filename) {
  var path = getFilePath(filename);

  return File(path).readAsString();
}

void createTests(List<TestInfo> tests) {
  tests.forEach((t) {
    test(t.description, () async {
      var source = await readFile(t.source);
      var generatedOutput = await generate(source);
      var output = await readFile(t.output);

      expect(generatedOutput.trim(), endsWith(output.trim()));
    });
  });
}
