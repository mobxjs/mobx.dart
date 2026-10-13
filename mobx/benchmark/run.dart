import 'dart:convert';
import 'dart:io';
import 'suite.dart';
import 'options.dart';

Future<void> main(List<String> args) async {
  final options = BenchmarkOptions.parse(args);
  final suite = options.suite;
  final samples = options.samples;
  final iterations = options.iterations;
  final caseName = options.caseName;
  final rows = await runSuite(
    suite: suite,
    samples: samples,
    iterations: iterations,
    caseName: caseName,
    onProgress: stderr.writeln,
  );
  final report = {
    'schema': 1,
    'suite': suite,
    'upstream_revision': '03663d64413a84c3449b932dac10f576b6314dd0',
    'dart': Platform.version,
    'os': Platform.operatingSystem,
    'processors': Platform.numberOfProcessors,
    'samples': samples,
    if (caseName != null) 'case_filter': caseName,
    if (suite == 'propagation') 'iterations': iterations,
    'cases': rows,
  };
  final json = const JsonEncoder.withIndent('  ').convert(report);
  if (options['output'] case final String path) {
    File(path).writeAsStringSync('$json\n');
  } else {
    stdout.writeln(json);
  }
  if (rows.any((row) => row['success'] != true)) exitCode = 1;
}
