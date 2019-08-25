import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
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

    test('ignores public classes annotated with @store', () async {
      const source = """
        @store
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

    createTests([
      const TestInfo(
          description: 'generates for a class mixing Store',
          source: './data/valid_input.dart',
          output: './data/valid_output.dart'),
      const TestInfo(
          description: 'invalid output is handled',
          source: './data/invalid_input.dart',
          output: './data/invalid_output.txt'),
      const TestInfo(
          description: 'generates for a generic class mixing Store',
          source: './data/valid_generic_store_input.dart',
          output: './data/valid_generic_store_output.dart'),
      const TestInfo(
          description: 'generates for a class annotated with @store',
          source: './data/valid_annotated_store_input.dart',
          output: './data/valid_annotated_store_output.dart'),
      const TestInfo(
          description: 'generates for a generic class annotated with @store',
          source: './data/valid_generic_annotated_store_input.dart',
          output: './data/valid_generic_annotated_store_output.dart'),
      const TestInfo(
          description: 'generates correct types for a @store referencing another @store',
          source: './data/valid_annotated_store_referencing_store_input.dart',
          output: './data/valid_annotated_store_referencing_store_output.dart'),
      const TestInfo(
          description: 'generates dart:ui types correctly',
          source: './data/valid_store_with_ui_types_input.dart',
          output: './data/valid_store_with_ui_types_output.dart'),
    ]);
  });
}
