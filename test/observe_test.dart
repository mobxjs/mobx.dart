import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

main() {
  test('observe', () {
    var x = observable(10);
    var executed = false;

    var dispose = x.observe<int>((change) {
      expect(change.newValue, equals(10));
      expect(change.oldValue, isNull);
      executed = true;
    }, fireImmediately: true);

    expect(executed, isTrue);

    dispose();
  });

  test('observe fires when changed', () {
    var x = observable(10);
    var executed = false;

    var dispose = x.observe<int>((change) {
      expect(change.newValue, equals(100));
      expect(change.oldValue, 10);
      executed = true;
    });

    expect(executed, isFalse);

    x.value = 100;
    expect(executed, isTrue);

    dispose();
  });

  test('observe can be disposed', () {
    var x = observable(10);
    var executed = false;

    var dispose = x.observe<int>((change) {
      executed = true;
    }, fireImmediately: true);

    expect(executed, isTrue);

    dispose();

    x.value = 100;
    executed = false;
    expect(executed, isFalse);
  });

  test('observe can have multiple listeners', () {
    var x = observable(10);
    var executionCount = 0;

    var dispose1 = x.observe<int>((change) {
      executionCount++;
    });

    var dispose2 = x.observe<int>((change) {
      executionCount++;
    });

    var dispose3 = x.observe<int>((change) {
      executionCount++;
    });

    x.value = 100;
    expect(executionCount, 3);

    dispose1();
    dispose2();
    dispose3();

    x.value = 200;
    expect(executionCount, 3); // no change here
  });

  test('onBecomeObserved/onBecomeUnobserved works for observables', () {
    var x = observable(10);
    var executionCount = 0;

    var d1 = x.onBecomeObserved(() {
      executionCount++;
    });

    var d2 = x.onBecomeUnobserved(() {
      executionCount++;
    });

    var d3 = autorun((_) {
      x.value;
    });

    expect(executionCount, equals(1));

    d3(); // dispose the autorun
    expect(executionCount, equals(2));

    d1();
    d2();
  });

  test('onBecomeObserved/onBecomeUnobserved works for computeds', () {
    var x = observable(10);
    var x1 = computed(() {
      x.value + 1;
    });
    var executionCount = 0;

    var d1 = x1.onBecomeObserved(() {
      executionCount++;
    });

    var d2 = x1.onBecomeUnobserved(() {
      executionCount++;
    });

    var d3 = autorun((_) {
      x1.value;
    });

    expect(executionCount, equals(1));

    d3(); // dispose the autorun
    expect(executionCount, equals(2));

    d1();
    d2();
  });

  test('onBecomeObserved/onBecomeUnobserved throws if null is passed', () {
    var x = observable(10);

    expect(() {
      x.onBecomeObserved(null);
    }, throwsException);

    expect(() {
      x.onBecomeUnobserved(null);
    }, throwsException);
  });
}
