import 'package:mobx/src/api/context.dart';
import 'package:mockito/mockito.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:test/test.dart';

import 'shared_mocks.dart';

void main() {
  group('computed()', () {
    test('basics work', () {
      final x = observable(20);
      final y = observable(10);
      final c = computed(() => x.value + y.value);

      x.value = 30;
      y.value = 20;
      expect(c.value, equals(50));

      expect(currentContext.isComputingDerivation(), isFalse);
    });

    test('value hierarchy', () {
      final x = observable(10, name: 'x');
      final y = observable(20, name: 'y');
      final z = observable(30, name: 'z');

      var c1ComputationCount = 0;
      var c3ComputationCount = 0;

      final c1 = computed(() {
        c1ComputationCount++;
        return x.value + y.value;
      }, name: 'c1');

      final c2 = computed(() => z.value, name: 'c2');

      final c3 = computed(() {
        c3ComputationCount++;
        return c1.value + c2.value;
      }, name: 'c3');

      final d = autorun((_) {
        c3.value;
      });

      expect(c3.value, equals(60));
      expect(c1ComputationCount, equals(1));
      expect(c3ComputationCount, equals(1));

      action(() {
        // Setting values such that c3 need not be computed again
        x.value = 20;
        y.value = 10;
      })();

      // Should not change as value is same as before
      expect(c3ComputationCount, equals(1));

      // should be recomputed as both x and y have changed
      expect(c1ComputationCount, equals(2));

      action(() {
        x.value = 30;
      })();

      expect(c1ComputationCount, equals(3));
      expect(c3ComputationCount, equals(2));

      expect(currentContext.isComputingDerivation(), isFalse);

      d();
    });

    test('can be observed', () {
      final x = observable(10);
      final y = observable(20);

      var executionCount = 0;

      final total = computed(() {
        executionCount++;
        return x.value + y.value;
      });

      final dispose1 = total.observe((change) {
        expect(change.newValue, equals(30));
        expect(executionCount, equals(1));
      });

      dispose1(); // no more observations

      x.value = 100; // should not invoke observe

      expect(executionCount, equals(1));
    });

    test('uses provided context', () {
      final context = MockContext();
      int fn() => 1;

      final value = computed(fn, context: context)..computeValue(track: true);

      verify(context.nameFor('Computed'));
      verify(context.trackDerivation(value, fn));
    });

    test('catches exception in evaluation', () {
      var shouldThrow = true;

      final x = computed(() {
        if (shouldThrow) {
          shouldThrow = false;
          throw Exception('FAIL');
        }
      });

      expect(() {
        x.value;
      }, throwsException);
      expect(x.errorValue, isException);

      x.value;
      expect(x.errorValue, isNull);
    });

    test('throws on finding a cycle', () {
      ComputedValue<int> c1;
      c1 = computed(() => c1.value);

      expect(() {
        c1.value;
      }, throwsException);

      // ignore: avoid_as
      expect((c1.errorValue.exception as MobXException).message.toLowerCase(),
          contains('cycle'));
    });
  });
}
