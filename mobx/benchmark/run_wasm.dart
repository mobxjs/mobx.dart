import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'options.dart';

/// Serves a release-Wasm build and runs it in a fresh headless Chrome profile.
/// Uses only the Dart SDK; no Node, Playwright, or browser extension is needed.
Future<void> main(List<String> args) async {
  final options = BenchmarkOptions.parse(args, wasm: true);
  final build = Directory(options['build'] ?? '.dart_tool/mobx-wasm').absolute;
  if (!File('${build.path}/run.wasm').existsSync() ||
      !File('${build.path}/run.mjs').existsSync()) {
    throw ArgumentError(
      'Compile benchmark/web.dart to ${build.path}/run.wasm first',
    );
  }
  final suite = options.suite;
  final samples = options.samples;
  final iterations = options.iterations;
  final config = {
    'suite': suite,
    'samples': samples,
    'iterations': iterations,
    'dart': Platform.version,
    'os': Platform.operatingSystem,
    if (options.caseName != null) 'case': options['case'],
  };
  final completed = Completer<Map<String, dynamic>>();
  final profile = await Directory.systemTemp.createTemp('mobx-wasm-chrome-');
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  Process? chrome;
  final diagnostics = StringBuffer();
  try {
    server.listen((request) async {
      try {
        final path = request.uri.path;
        if (request.method == 'POST' && path == '/result') {
          final body = await utf8.decoder.bind(request).join();
          if (!completed.isCompleted) {
            completed.complete(jsonDecode(body) as Map<String, dynamic>);
          }
          request.response.write('ok');
        } else if (path == '/') {
          request.response.headers.contentType = ContentType.html;
          request.response.write(
            '''<!doctype html><meta charset="utf-8"><title>MobX Wasm benchmark</title>
<pre id="result">Running…</pre><script type="module">
const config = ${jsonEncode(config)};
config.browser = navigator.userAgent;
config.processors = navigator.hardwareConcurrency;
globalThis.mobxBenchmarkConfig = JSON.stringify(config);
globalThis.mobxBenchmarkProgress = message => console.log(message);
globalThis.mobxBenchmarkDone = async report => {
  document.querySelector('#result').textContent = report;
  await fetch('/result', {method: 'POST', body: report});
};
globalThis.mobxBenchmarkFailed = error => mobxBenchmarkDone(JSON.stringify({error: String(error)}));
try {
  const dart = await import('/run.mjs');
  const app = await dart.compileStreaming(fetch('/run.wasm'));
  const instance = await app.instantiate({});
  instance.invokeMain();
} catch (error) { mobxBenchmarkFailed(error.stack || error); }
</script>''',
          );
        } else if (path == '/run.mjs' ||
            path == '/run.wasm' ||
            path == '/run.wasm.map') {
          request.response.headers.contentType = ContentType(
            'application',
            path.endsWith('.mjs')
                ? 'javascript'
                : path.endsWith('.map')
                ? 'json'
                : 'wasm',
          );
          await request.response.addStream(
            File('${build.path}$path').openRead(),
          );
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }
      } catch (error, stack) {
        if (!completed.isCompleted) completed.completeError(error, stack);
        request.response.statusCode = HttpStatus.internalServerError;
      } finally {
        await request.response.close();
      }
    });
    final executable =
        Platform.environment['CHROME_EXECUTABLE'] ??
        (Platform.isMacOS
            ? '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
            : 'google-chrome');
    chrome = await Process.start(executable, [
      '--headless',
      '--disable-gpu',
      '--no-first-run',
      '--no-default-browser-check',
      '--disable-background-timer-throttling',
      '--disable-renderer-backgrounding',
      '--user-data-dir=${profile.path}',
      'http://127.0.0.1:${server.port}/',
    ]);
    chrome.stdout.drain<void>();
    chrome.stderr.transform(utf8.decoder).listen(diagnostics.write);
    chrome.exitCode.then((code) {
      if (!completed.isCompleted) {
        completed.completeError(
          StateError('Chrome exited ($code): $diagnostics'),
        );
      }
    });
    final report = await completed.future.timeout(const Duration(minutes: 15));
    if (report['error'] != null) throw StateError(report['error'].toString());
    final output = const JsonEncoder.withIndent('  ').convert(report);
    if (options['output'] case final String path) {
      await File(path).writeAsString('$output\n');
    } else {
      stdout.writeln(output);
    }
    if ((report['cases'] as List).any(
      (row) => (row as Map)['success'] != true,
    )) {
      exitCode = 1;
    }
  } finally {
    await server.close(force: true);
    if (chrome != null) {
      chrome.kill();
      await chrome.exitCode.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          chrome!.kill(ProcessSignal.sigkill);
          return -1;
        },
      );
    }
    await profile.delete(recursive: true);
  }
}
