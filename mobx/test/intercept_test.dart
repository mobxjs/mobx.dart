import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

void main() {
  testSetup();

  group('intercept', () {
    test('basics work', () {
      final x = Observable(10);
      var executed = false;

      final dispose = x.intercept((change) {
        // prevent a change
        change.newValue = 33;
        executed = true;
        return change;
      });

      x.value = 100;
      expect(x.value, equals(33));
      expect(executed, isTrue);

      dispose();
    });

    test('prevents a change', () {
      final x = Observable(10);

      final dispose = x.intercept((change) => null);

      x.value = 100;
      expect(x.value, equals(10));

      dispose();
    });

    test('can be chained', () {
      final x = Observable(10);

      final dispose1 = x.intercept((change) {
        change.newValue = change.newValue + 10;
        return change;
      });

      final dispose2 = x.intercept((change) {
        change.newValue = change.newValue + 10;
        return change;
      });

      x.value = 100;
      expect(x.value, equals(120));

      dispose1();
      dispose2();
    });

    test('chain can be short-circuited', () {
      final x = Observable(10);

      final dispose1 = x.intercept((change) {
        change.newValue = change.newValue + 10;
        return change;
      });

      final dispose2 = x.intercept((change) => null);

      final dispose3 = x.intercept((change) {
        change.newValue = change.newValue + 10;
        return change;
      });

      x.value = 100;
      expect(
          x.value, equals(10)); // no change as the interceptor-2 has nullified

      dispose1();
      dispose2();
      dispose3();
    });

    test('uses provided context', () {
      final context = MockContext();
      Interceptors(context)
        // ignore: missing_return
        ..add((_) {})
        ..interceptChange(WillChangeNotification());

      verify(context.untracked(any));
    });

    test('asserts for null notifications', () {
      final handlers = Interceptors(MockContext())
        // ignore: missing_return
        ..add((_) {});

      expect(() {
        handlers.interceptChange(null);
      }, throwsA(const TypeMatcher<AssertionError>()));
    });
  });
}
