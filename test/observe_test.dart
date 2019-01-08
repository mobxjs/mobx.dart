import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  test('observe', () {
    final x = observable(10);
    var executed = false;

    final dispose = x.observe((change) {
      expect(change.newValue, equals(10));
      expect(change.oldValue, isNull);
      executed = true;
    }, fireImmediately: true);

    expect(executed, isTrue);

    dispose();
  });

  test('observe fires when changed', () {
    final x = observable(10);
    var executed = false;

    final dispose = x.observe((change) {
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
    final x = observable(10);
    var executed = false;

    final dispose = x.observe((change) {
      executed = true;
    }, fireImmediately: true);

    expect(executed, isTrue);

    dispose();

    x.value = 100;
    executed = false;
    expect(executed, isFalse);
  });

  test('observe can have multiple listeners', () {
    final x = observable(10);
    var executionCount = 0;

    final dispose1 = x.observe((change) {
      executionCount++;
    });

    final dispose2 = x.observe((change) {
      executionCount++;
    });

    final dispose3 = x.observe((change) {
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
    final x = observable(10);
    var executionCount = 0;

    final d1 = x.onBecomeObserved(() {
      executionCount++;
    });

    final d2 = x.onBecomeUnobserved(() {
      executionCount++;
    });

    final d3 = autorun((_) {
      x.value;
    });

    expect(executionCount, equals(1));

    d3(); // dispose the autorun
    expect(executionCount, equals(2));

    d1();
    d2();
  });

  test('onBecomeObserved/onBecomeUnobserved works for computeds', () {
    final x = observable(10);
    final x1 = computed(() {
      // ignore: unnecessary_statements
      x.value + 1;
    });
    var executionCount = 0;

    final d1 = x1.onBecomeObserved(() {
      executionCount++;
    });

    final d2 = x1.onBecomeUnobserved(() {
      executionCount++;
    });

    final d3 = autorun((_) {
      x1.value;
    });

    expect(executionCount, equals(1));

    d3(); // dispose the autorun
    expect(executionCount, equals(2));

    d1();
    d2();
  });

  test('onBecomeObserved/onBecomeUnobserved throws if null is passed', () {
    final x = observable(10);

    expect(() {
      x.onBecomeObserved(null);
    }, throwsException);

    expect(() {
      x.onBecomeUnobserved(null);
    }, throwsException);
  });

  test('multiple onBecomeObserved/onBecomeUnobserved can be attached', () {
    final x = observable(10);

    var observedCount = 0;
    var unobservedCount = 0;

    var disposers = <Function>[
      x.onBecomeObserved(() {
        observedCount++;
      }),
      x.onBecomeObserved(() {
        observedCount++;
      }),
      x.onBecomeUnobserved(() {
        unobservedCount++;
      }),
      x.onBecomeUnobserved(() {
        unobservedCount++;
      }),
    ];

    var d = autorun((_) {
      x.value;
    });

    expect(observedCount, equals(2));
    d();
    expect(unobservedCount, equals(2));

    disposers.forEach((f) => f());
  });
}
