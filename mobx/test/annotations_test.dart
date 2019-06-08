import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  test('annotations are defined', () {
    expect(observable, isNotNull);
    expect(computed, isNotNull);
    expect(action, isNotNull);
  });
}
