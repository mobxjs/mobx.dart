import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  test('annotations are defined', () {
    expect(observable, isNotNull);
    expect(computed, isNotNull);
    expect(action, isNotNull);
    expect(StoreConfig, isNotNull);
  });
}
