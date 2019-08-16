import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('invalid annotations', () {
    createTests([
      const TestInfo(
          description: 'Errors when there is an invalid store declaration',
          source: './data/invalid_store_declaration.dart',
          output: './data/invalid_store_declaration_output.txt'),
      const TestInfo(
          description:
              'Errors when there is a single invalid @computed annotation',
          source: './data/invalid_computed_single.dart',
          output: './data/invalid_computed_single_output.txt'),
      const TestInfo(
          description:
              'Errors when there are multiple invalid @computed annotations',
          source: './data/invalid_computed_multiple.dart',
          output: './data/invalid_computed_multiple_output.txt'),
      const TestInfo(
          description:
              'Errors when there is a single invalid @observable annotation',
          source: './data/invalid_observable_single.dart',
          output: './data/invalid_observable_single_output.txt'),
      const TestInfo(
          description:
              'Errors when there are multiple invalid @observable annotations',
          source: './data/invalid_observable_multiple.dart',
          output: './data/invalid_observable_multiple_output.txt'),
      const TestInfo(
          description:
              'Errors when there are multiple invalid @action annotations',
          source: './data/invalid_action_multiple.dart',
          output: './data/invalid_action_multiple_output.txt'),
    ]);
  });
}
