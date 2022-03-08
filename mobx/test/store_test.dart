import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

class TestStore with Store {}

void main() {
  group('Store', () {
    test('can get context', () {
      expect(TestStore().context, mainContext) ;
    });
  });
}