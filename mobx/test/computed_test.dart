import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mobx/src/api/context.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

void main() {
  testSetup();

  group('Computed', () {
    test('basics work', () {
      final x = Observable(20);
      final y = Observable(10);
      final c = Computed(() => x.value + y.value);

      x.value = 30;
      y.value = 20;
      expect(c.value, equals(50));

      expect(mainContext.isComputingDerivation(), isFalse);
    });

    test('value hierarchy', () {
      final x = Observable(10, name: 'x');
      final y = Observable(20, name: 'y');
      final z = Observable(30, name: 'z');

      var c1ComputationCount = 0;
      var c3ComputationCount = 0;

      final c1 = Computed(() {
        c1ComputationCount++;
        return x.value + y.value;
      }, name: 'c1');

      final c2 = Computed(() => z.value, name: 'c2');

      final c3 = Computed(() {
        c3ComputationCount++;
        return c1.value + c2.value;
      }, name: 'c3');

      final d = autorun((_) {
        c3.value;
      });

      expect(c3.value, equals(60));
      expect(c1ComputationCount, equals(1));
      expect(c3ComputationCount, equals(1));

      Action(() {
        // Setting values such that c3 need not be computed again
        x.value = 20;
        y.value = 10;
      })();

      // Should not change as value is same as before
      expect(c3ComputationCount, equals(1));

      // should be recomputed as both x and y have changed
      expect(c1ComputationCount, equals(2));

      Action(() {
        x.value = 30;
      })();

      expect(c1ComputationCount, equals(3));
      expect(c3ComputationCount, equals(2));

      expect(mainContext.isComputingDerivation(), isFalse);

      d();
    });

    test('can be observed', () {
      final x = Observable(10);
      final y = Observable(20);

      var executionCount = 0;

      final total = Computed(() {
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

    test('only notifies observers when computed value changed', () {
      final x = Observable(10);
      final y = Observable(20);

      var observationCount = 0;

      final total = Computed(() => x.value + y.value);

      final dispose = total.observe((change) {
        observationCount++;
      });

      expect(observationCount, equals(1));

      // shouldn't notify because the total is the same
      Action(() {
        x.value = x.value + 10;
        y.value = y.value - 10;
      })();

      expect(observationCount, equals(1));

      dispose();
    });

    test('can use a custom equality', () {
      final list = ObservableList<int>.of([1, 2, 4]);

      var observationCount = 0;

      final evens = Computed(
          () => list.where((element) => element.isEven).toList(),
          equals: const ListEquality().equals);

      final dispose = evens.observe((change) {
        observationCount++;
      });

      expect(observationCount, equals(1));

      // evens didn't change, so should not invoke observe
      list.add(5);
      expect(observationCount, equals(1));

      // evens changed, so should invoke observe
      list.add(6);
      expect(observationCount, equals(2));

      dispose();
    });

    test('uses provided context', () {
      final context = MockContext();
      when(() => context.nameFor(any())).thenReturn('Test-Computed');

      int fn() => 1;

      final c = Computed(fn, context: context)..computeValue(track: true);

      verify(() => context.nameFor('Computed'));
      verify(() => context.trackDerivation(c, fn));
    });

    test('catches exception in evaluation', () {
      var shouldThrow = true;

      final x = Computed(() {
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
      late Computed<int> c1;
      c1 = Computed(() => c1.value);

      expect(() {
        c1.value;
      }, throwsException);

      // ignore: avoid_as
      expect((c1.errorValue?.exception as MobXException).message.toLowerCase(),
          contains('cycle'));
    });

    test('with disableErrorBoundaries = true, exception is thrown', () {
      final c = Computed(() => throw Exception('FAIL'),
          context: createContext(
              config: ReactiveConfig(disableErrorBoundaries: true)));

      expect(() => c.value, throwsException);
    });
  });
}
