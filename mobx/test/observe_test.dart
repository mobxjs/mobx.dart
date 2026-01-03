import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  group('observe', () {
    test('works', () {
      final x = Observable(10);
      var executed = false;

      final dispose = x.observe((change) {
        expect(change.newValue, equals(10));
        expect(change.oldValue, isNull);
        executed = true;
      }, fireImmediately: true);

      expect(executed, isTrue);

      dispose();
    });

    test('fires when changed', () {
      final x = Observable(10);
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

    group('equality override', () {
      test('yields a new value', () {
        final x = Observable(10, equals: (_, __) => false);

        var executed = false;

        final dispose = x.observe((change) {
          expect(change.newValue, equals(10));
          executed = true;
        }, fireImmediately: true);

        expect(executed, isTrue);
        executed = false;

        x.value = 10;
        expect(executed, isTrue);
        executed = false;

        x.value = 10;
        expect(executed, isTrue);
        executed = false;

        dispose();
      });

      test('does not yield a new value', () {
        final x = Observable(10, equals: (_, __) => true);

        var executed = false;

        final dispose = x.observe((change) {
          expect(change.newValue, equals(10));
          executed = true;
        }, fireImmediately: true);

        expect(executed, isTrue);
        executed = false;

        x.value = 10;
        expect(executed, isFalse);

        x.value = 11;
        expect(executed, isFalse);

        dispose();
      });
    });

    test('can be disposed', () {
      final x = Observable(10);
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

    test('can have multiple listeners', () {
      final x = Observable(10);
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
  });

  group('onBecomeObserved / onBecomeUnobserved', () {
    test('works for observables', () {
      final x = Observable(10);
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

    test('works for computeds', () {
      final x = Observable(10);
      final x1 = Computed(() {
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

    test('multiple can be attached', () {
      final x = Observable(10);

      var observedCount = 0;
      var unobservedCount = 0;

      final disposers = <Function>[
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

      final d = autorun((_) {
        x.value;
      });

      expect(observedCount, equals(2));
      d();
      expect(unobservedCount, equals(2));

      // ignore: avoid_function_literals_in_foreach_calls
      disposers.forEach((f) => f());
    });
  });
}
