import 'package:mobx_codegen/src/utils/non_private_name_extension.dart';
import 'package:test/test.dart';

void main() {
  test('NonPrivateNameExtension should remove only leading underscores', () {
    expect('__foo_bar__'.nonPrivateName, equals('foo_bar__'));
  });
}
