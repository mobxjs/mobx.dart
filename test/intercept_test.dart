import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

main() {
  test('intercept', () {
    final x = observable(10);
    var executed = false;

    final dispose = x.intercept<int>((change) {
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

  test('intercept prevents a change', () {
    final x = observable(10);

    final dispose = x.intercept<int>((change) {
      return null;
    });

    x.value = 100;
    expect(x.value, equals(10));

    dispose();
  });

  test('intercept can be chained', () {
    final x = observable(10);

    final dispose1 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    final dispose2 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    x.value = 100;
    expect(x.value, equals(120));

    dispose1();
    dispose2();
  });

  test('intercept chain can be short-circuited', () {
    final x = observable(10);

    final dispose1 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    final dispose2 = x.intercept<int>((change) {
      return null;
    });

    final dispose3 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    x.value = 100;
    expect(x.value, equals(10)); // no change as the interceptor-2 has nullified

    dispose1();
    dispose2();
    dispose3();
  });
}
