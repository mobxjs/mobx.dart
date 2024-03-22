import 'package:mobx/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Utils', () {
    test('equatable', () {
      final a = 1;
      final b = 1;
      expect(equatable(a, b), isTrue);
    });

    test('equatable iterable', () {
      final a = [1];
      final b = [1];
      expect(equatable(a, b, useDeepEquality: false), false);
    });

    test('equatable with deep equality', () {
      final a = [1];
      final b = [1];
      expect(equatable(a, b, useDeepEquality: true), isTrue);
    });
  });
}
