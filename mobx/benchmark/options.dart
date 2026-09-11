/// Shared validation for native and browser benchmark entry points.
final class BenchmarkOptions {
  BenchmarkOptions._(this.values);

  factory BenchmarkOptions.parse(List<String> args, {bool wasm = false}) {
    final values = <String, String>{};
    final allowed = {
      'suite',
      'samples',
      'iterations',
      'output',
      'case',
      if (wasm) 'build',
    };
    for (final arg in args) {
      final separator = arg.indexOf('=');
      if (!arg.startsWith('--') || separator < 3) {
        throw ArgumentError('Expected --key=value');
      }
      final key = arg.substring(2, separator);
      final value = arg.substring(separator + 1);
      if (!allowed.contains(key) || values.containsKey(key) || value.isEmpty) {
        throw ArgumentError('Unknown, duplicate, or empty option: $key');
      }
      values[key] = value;
    }
    final options = BenchmarkOptions._(Map.unmodifiable(values));
    if (!{
      'propagation',
      'upstream',
      'primitives',
      'collections',
      'all',
    }.contains(options.suite)) {
      throw ArgumentError('Unknown suite: ${options.suite}');
    }
    if (options.samples < 1 || options.iterations < 1) {
      throw ArgumentError('Counts must be positive');
    }
    if (options.caseName != null && options.suite != 'primitives') {
      throw ArgumentError('--case requires primitives');
    }
    if (values.containsKey('iterations') && options.suite != 'propagation') {
      throw ArgumentError('--iterations requires propagation');
    }
    return options;
  }

  final Map<String, String> values;
  String get suite => values['suite'] ?? 'propagation';
  int get samples => int.parse(values['samples'] ?? '3');
  int get iterations => int.parse(values['iterations'] ?? '1000');
  String? get caseName => values['case'];
  String? operator [](String key) => values[key];
}
