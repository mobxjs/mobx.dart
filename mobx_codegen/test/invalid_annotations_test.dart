import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  createTests([
    const TestInfo(
        description: 'Errors if @observable is attached to a getter',
        source: './data/invalid_computed_annotation.dart',
        output: './data/invalid_computed_output.txt'),
    const TestInfo(
        description: 'Errors if @computed is attached to a field',
        source: './data/invalid_observable_annotation.dart',
        output: './data/invalid_observable_output.txt'),
  ]);

  test('Errors if @action is attached to a getter, field or class', () {});
}
