import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:mobx/src/core/base_types.dart';
import 'package:test/test.dart';

main() {
  test('Computed value', () {
    var x = observable(20);
    var y = observable(10);
    var c = computed(() {
      return x.value + y.value;
    });

    x.value = 30;
    y.value = 20;
    expect(c.value, equals(50));

    expect(global.isComputingDerivation(), isFalse);
  });

  test('Computed value hierarchy', () {
    var x = observable(10, name: 'x');
    var y = observable(20, name: 'y');
    var z = observable(30, name: 'z');

    var c1ComputationCount = 0;
    var c3ComputationCount = 0;

    var c1 = computed(() {
      c1ComputationCount++;
      return x.value + y.value;
    }, name: 'c1');

    var c2 = computed(() {
      return z.value;
    }, name: 'c2');

    var c3 = computed(() {
      c3ComputationCount++;
      return c1.value + c2.value;
    }, name: 'c3');

    var d = autorun(() {
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

    expect(global.isComputingDerivation(), isFalse);

    d();
  });
}
