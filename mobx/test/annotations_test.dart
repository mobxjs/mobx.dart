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
    expect(readonly, isNotNull);
  });

  test('observableAlwaysNotEqual should return false', () {
    expect(observableAlwaysNotEqual(1, 2), isFalse);
    expect(observableAlwaysNotEqual(1, 1), isFalse);
    expect(observableAlwaysNotEqual('a', 'a'), isFalse);
    expect(observableAlwaysNotEqual(true, true), isFalse);
    expect(observableAlwaysNotEqual(false, false), isFalse);
  });
}
