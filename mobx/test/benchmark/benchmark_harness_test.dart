import 'package:test/test.dart';
import '../../benchmark/compare.dart' as harness;

Map<String, dynamic> report(int time, {bool success = true}) => {
  'schema': 1,
  'suite': 'propagation',
  'iterations': 1000,
  'samples': 3,
  'cases': [
    {'name': 'diamond', 'median_us': time, 'success': success},
  ],
};

void main() {
  test('compares a complete successful report', () {
    final change = harness.compare(report(100), report(50)).single;
    expect(change.speedup, 2);
    expect(change.percent, -50);
  });
  test('refuses incompatible workload sizes', () {
    expect(
      () => harness.compare(report(100), report(50)..['iterations'] = 5),
      throwsArgumentError,
    );
  });
  test('refuses a fast but incorrect result', () {
    expect(
      () => harness.compare(report(100), report(1, success: false)),
      throwsArgumentError,
    );
  });
  test('refuses missing cases and zero duration', () {
    expect(
      () => harness.compare(report(100), report(1)..['cases'] = []),
      throwsArgumentError,
    );
    expect(() => harness.compare(report(100), report(0)), throwsArgumentError);
  });
}
