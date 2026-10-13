import 'utils/perf_tests.dart';

class TestConfig {
  const TestConfig({
    this.name,
    required this.width,
    required this.totalLayers,
    required this.staticFraction,
    required this.nSources,
    required this.readFraction,
    required this.iterations,
    required this.expected,
  });

  final String? name;

  final int width;
  final int totalLayers;
  final double staticFraction;
  final int nSources;
  final double readFraction;
  final int iterations;
  final TestResult expected;
}
