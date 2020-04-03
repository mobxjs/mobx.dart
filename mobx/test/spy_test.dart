import 'package:test/test.dart';
import 'package:mobx/mobx.dart';

void main() {
  group('Spy', () {
    test('spies can be added', () {});
    test('when a spy unsubscribes, it is removed from the list', () {});
    test('spies are enabled', () {
      final context = ReactiveContext();
      expect(context.isSpyEnabled, isFalse);
    });
  });
}
