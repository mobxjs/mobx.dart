import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

class TestStore with Store {}

void main() {
  group('Store', () {
    // ignore: unnecessary_lambdas
    test('can call dispose', () {
      TestStore().dispose();
    });
  });
}
