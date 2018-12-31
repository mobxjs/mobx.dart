import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

main() {
  test('Action basics work', () {
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

  test('action inside autorun should be untracked', () {
    var x = observable(10);
    var y = observable(20);

    var total = 0;
    var a = action(() {
      return y.value;
    });

    var d = autorun(() {
      total = x.value + a();
    });

    expect(total, equals(30));

    // This should not trigger the autorun as y.value is accessed inside the action(),
    // which by design should be untracked
    y.value = 30;

    expect(total, equals(30)); // total should still be 10 + 20
    x.value = 11;
    expect(total, equals(41)); // total should still be 11 + 30

    d();
  });

  test('Action can be invoked with named args', () {
    String message;

    var a = action(({String name, String value}) {
      message = '${name}: ${value}';
    });

    a([], {'name': 'Hello', 'value': 'MobX'});
    expect(message, equals('Hello: MobX'));
  });
}
