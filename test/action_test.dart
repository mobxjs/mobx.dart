import 'package:mobx/src/api/action.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:mobx/src/core/action.dart';
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

    var dispose = autorun((_) {
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

    var dispose = autorun((_) {
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

    var d = autorun((_) {
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

  test('nested actions work', () {
    var x = observable(10);
    var y = observable(20);

    var executionCount = 0;

    var d = autorun((_) {
      x.value + y.value;
      executionCount++;
    });

    action(() {
      x.value = 100;

      expect(executionCount, equals(1)); // No notifications are fired
      action(() {
        y.value = 200;
        expect(executionCount, equals(1)); // No notifications are fired
      })();
    })();

    // Notifications are fired now
    expect(executionCount, equals(2));

    d();
  });

  test('runInAction works', () {
    var x = observable(10);
    var y = observable(20);

    var executionCount = 0;
    var total = 0;

    var d = autorun((_) {
      total = x.value + y.value;
      executionCount++;
    });

    runInAction(() {
      x.value = 100;
      y.value = 200;

      expect(executionCount, equals(1)); // No notifications are fired
    });

    // Notifications are fired now
    expect(executionCount, equals(2));
    expect(total, equals(300));

    d();
  });

  test('transaction works', () {
    var x = observable(10);
    var y = observable(20);

    var total = 0;

    var d = autorun((_) {
      total = x.value + y.value;
    });

    transaction(() {
      x.value = 100;
      y.value = 200;

      // within a transaction(), there are no notifications fired, so the total should not change
      expect(total, equals(30));
    });

    // Notifications fire now, causing autorun() to execute
    expect(total, equals(300));

    d();
  });
}
