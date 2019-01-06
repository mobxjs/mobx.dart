import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/api/context.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

void main() {
  test('Computed value', () {
    final x = observable(20);
    final y = observable(10);
    final c = computed(() => x.value + y.value);

    x.value = 30;
    y.value = 20;
    expect(c.value, equals(50));

    expect(currentContext.isComputingDerivation(), isFalse);
  });

  test('Computed value hierarchy', () {
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

  test('computed can be observed', () {
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
}
