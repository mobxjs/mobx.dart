import 'package:test/test.dart';
import '../../benchmark/options.dart';

void main() {
  test('native and Wasm share defaults and workload configuration', () {
    for (final wasm in [false, true]) {
      final defaults = BenchmarkOptions.parse([], wasm: wasm);
      expect(defaults.suite, 'propagation');
      expect(defaults.samples, 3);
      expect(defaults.iterations, 1000);
      final options = BenchmarkOptions.parse([
        '--suite=primitives',
        '--case=chain',
        '--samples=2',
      ], wasm: wasm);
      expect(options.caseName, 'chain');
      expect(options.samples, 2);
    }
  });
  test('both runners reject ambiguous and invalid configuration', () {
    for (final wasm in [false, true]) {
      for (final args in [
        ['samples=2'],
        ['--bogus=2'],
        ['--samples=0'],
        ['--samples=-2'],
        ['--suite=missing'],
        ['--case=chain'],
        ['--suite=all', '--iterations=2'],
        ['--output='],
        ['--samples=2', '--samples=3'],
      ]) {
        expect(
          () => BenchmarkOptions.parse(args, wasm: wasm),
          throwsArgumentError,
          reason: '$args, wasm=$wasm',
        );
      }
      expect(
        () => BenchmarkOptions.parse(['--samples=nope'], wasm: wasm),
        throwsFormatException,
      );
    }
  });
  test('only Wasm accepts a build directory', () {
    expect(() => BenchmarkOptions.parse(['--build=dist']), throwsArgumentError);
    expect(
      BenchmarkOptions.parse(['--build=dist'], wasm: true)['build'],
      'dist',
    );
  });
}
