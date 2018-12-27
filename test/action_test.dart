import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

main() {
  test('Action', () {
    var a = action((String name, String value) {
      expect(name, equals('name'));
      expect(value, equals('MobX'));
    });

    a(['name', 'MobX']);
    expect(a.name, startsWith('Action'));
  });

  test('Action modifications are picked up', () {
    var x = observable(10);

    var total = 0;
    var a = action(() {
      x.value = x.value +
          1; // No reaction-infinite-loop as we are not tracking the observables
    });

    var dispose = autorun(() {
      total = x.value * 10;
    });

    expect(total, equals(100));

    a();
    expect(total, equals(110));

    dispose();
  });

  test('Action modifications are batched', () {
    var x = observable(10);
    var y = observable(20);
    var z = observable(30);

    var total = 0;
    var autorunExecutionCount = 0;

    var dispose = autorun(() {
      total = x.value + y.value + z.value;
      autorunExecutionCount++;
    });

    expect(total, equals(60));
    expect(autorunExecutionCount, equals(1));

    var a = action(() {
      x.value++;
      y.value++;
      z.value++;
    });

    a();
    expect(total, equals(63));
    expect(autorunExecutionCount, equals(2));

    a();
    expect(total, equals(66));
    expect(autorunExecutionCount, equals(3));

    dispose();
  });
}
