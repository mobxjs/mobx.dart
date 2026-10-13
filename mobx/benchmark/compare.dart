import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.length < 2 || args.length > 3) {
    throw ArgumentError(
      'Usage: dart benchmark/compare.dart baseline.json candidate.json [maximum_regression_percent]',
    );
  }
  final baseline =
      jsonDecode(File(args[0]).readAsStringSync()) as Map<String, dynamic>;
  final candidate =
      jsonDecode(File(args[1]).readAsStringSync()) as Map<String, dynamic>;
  final maximum = args.length == 3 ? double.parse(args[2]) : null;
  final changes = compare(baseline, candidate);
  for (final change in changes) {
    stdout.writeln(
      '${change.name}: ${change.speedup.toStringAsFixed(2)}x speedup (${change.percent.toStringAsFixed(1)}% time)',
    );
    if (maximum != null && change.percent > maximum) exitCode = 1;
  }
}

List<({String name, double speedup, double percent})> compare(
  Map<String, dynamic> baseline,
  Map<String, dynamic> candidate,
) {
  for (final key in [
    'schema',
    'suite',
    'upstream_revision',
    'iterations',
    'samples',
    'runtime',
    'browser',
    'case_filter',
    'dart',
    'os',
    'processors',
  ]) {
    if (baseline[key] != candidate[key]) {
      throw ArgumentError('Incompatible $key');
    }
  }
  Map<String, Map<String, dynamic>> cases(Map<String, dynamic> report) {
    final rows = (report['cases'] as List).cast<Map<String, dynamic>>();
    final result = {for (final row in rows) row['name'] as String: row};
    if (rows.isEmpty || result.length != rows.length) {
      throw ArgumentError('Empty or duplicate cases');
    }
    for (final row in rows) {
      if (row['success'] != true || (row['median_us'] as num) <= 0) {
        throw ArgumentError('Failed or invalid case: ${row['name']}');
      }
    }
    return result;
  }

  final before = cases(baseline);
  final after = cases(candidate);
  if (before.length != after.length || !before.keys.every(after.containsKey)) {
    throw ArgumentError('Case sets differ');
  }
  return [
    for (final name in before.keys)
      (
        name: name,
        speedup:
            (before[name]!['median_us'] as num) /
            (after[name]!['median_us'] as num),
        percent:
            ((after[name]!['median_us'] as num) /
                    (before[name]!['median_us'] as num) -
                1) *
            100,
      ),
  ];
}
