import 'package:mobx_codegen/mobx_codegen.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  test('Should expose the library\'s version', () {
    expect(version, isNotNull);
  });

  group('generator', () {
    test('ignores empty library', () async {
      expect(await generate(''), isEmpty);
    });

    test("ignores class that doesn't implement Store", () async {
      const source = """
        class MyClass {
          void foobar() => 'Hello';
        }
      """;

      expect(await generate(source), isEmpty);
    });

    test('ignores when there is no class other than the abstract Store',
        () async {
      final source = await readFile('./data/only_abstract_store.dart');

      expect(await generate(source), isEmpty);
    });

    test('generates for a class mixing Store', () async {
      await compareFiles('./data/valid_input.dart', './data/valid_output.dart');
    });

    createTests([
      const TestInfo(
          description: 'invalid output is handled',
          source: './data/invalid_input.dart',
          output: './data/invalid_output.txt'),
      const TestInfo(
          description: 'generates for a generic class mixing Store',
          source: './data/valid_generic_store_input.dart',
          output: './data/valid_generic_store_output.dart'),
      const TestInfo(
          description: 'generates types with import prefixes correctly',
          source: './data/valid_import_prefixed_input.dart',
          output: './data/valid_import_prefixed_output.dart'),
    ]);
  });
}
