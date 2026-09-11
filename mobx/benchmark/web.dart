import 'dart:convert';
import 'dart:js_interop';

import 'suite.dart';

@JS('mobxBenchmarkConfig')
external JSString get configuration;
@JS('mobxBenchmarkDone')
external void complete(JSString report);
@JS('mobxBenchmarkFailed')
external void fail(JSString error);
@JS('mobxBenchmarkProgress')
external void progress(JSString message);

Future<void> main() async {
  try {
    final config = jsonDecode(configuration.toDart) as Map<String, dynamic>;
    final suite = config['suite'] as String;
    final samples = config['samples'] as int;
    final iterations = config['iterations'] as int;
    final rows = await runSuite(
      suite: suite,
      samples: samples,
      iterations: iterations,
      caseName: config['case'] as String?,
      onProgress: (message) => progress(message.toJS),
    );
    complete(
      jsonEncode({
        'schema': 1,
        'suite': suite,
        'runtime': 'wasm-release',
        'upstream_revision': '03663d64413a84c3449b932dac10f576b6314dd0',
        'dart': config['dart'],
        'os': config['os'],
        'browser': config['browser'],
        'processors': config['processors'],
        'samples': samples,
        if (suite == 'propagation') 'iterations': iterations,
        if (config['case'] != null) 'case_filter': config['case'],
        'cases': rows,
      }).toJS,
    );
  } catch (error, stack) {
    fail('$error\n$stack'.toJS);
  }
}
