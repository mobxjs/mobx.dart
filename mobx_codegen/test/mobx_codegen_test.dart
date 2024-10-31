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

    test('generates for a class containing late observables', () async {
      await compareFiles('./data/valid_late_variables_input.dart',
          './data/valid_late_variables_output.dart');
    });

    test(
        'generates for a class mixing Store with annotation @StoreConfig(hasToString: true)',
        () async {
      await compareFiles(
          './data/valid_input_annotation_store_config_has_to_string.dart',
          './data/valid_output_annotation_store_config_has_to_string.dart');
    });

    test(
        'generates for a class containing annotations "@protected", "@visibleForTesting" and "visibleForOverriding"',
        () async {
      await compareFiles('./data/annotations_test_class_input.dart',
          './data/annotations_test_class_output.dart');
    });

    test('generates for a class containing keep alive computed', () async {
      await compareFiles('./data/valid_keep_alive_computed_input.dart',
          './data/valid_keep_alive_computed_output.dart');
    });

    test('generates for a class with extension', () async {
      await compareFiles('./data/with_extension_input.dart',
          './data/with_extension_output.dart');
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
