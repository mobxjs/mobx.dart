import 'package:fake_async/fake_async.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:mobx/src/core/reaction.dart';
import "package:test/test.dart";

void main() {
  test('autorun', () {
    var c = observable(0);
    int nextValue;

    var dispose = autorun(() {
      nextValue = c.value + 1;
    });

    expect(dispose.$mobx.name, startsWith('Autorun@'));
    expect(nextValue, equals(1));

    c.value = 10;
    expect(nextValue, equals(11));

    dispose(); // reaction should not run after this, even as dependent observables change

    c.value = 100;
    expect(nextValue, isNot(equals(101))); // Should not change
    expect(nextValue, equals(11)); // Remains the same as last value
  });

  test('autorun with 2 observables', () {
    var x = observable('Hello');
    var y = observable('Pavan');
    String message;

    var dispose = autorun(() {
      message = "${x.value} ${y.value}";
    }, name: 'Message Effect');

    expect(message, equals("Hello Pavan"));
    expect(dispose.$mobx.name, equals("Message Effect"));

    x.value = "Hey";
    expect(message, equals("Hey Pavan"));
    y.value = "MobX";
    expect(message, equals("Hey MobX"));

    dispose();
  });

  test('autorun with changing observables', () {
    var x = observable(10);
    var y = observable(20);
    int value;

    var dispose = autorun(() {
      value = (value == null) ? x.value : y.value;
    });

    expect(value, equals(10));
    x.value = 30;

    expect(value, equals(20)); // Should use y now

    dispose();
  });

  test('with delayed scheduler', () {
    Function dispose;
    const delayMs = 5000;

    var x = observable(10);
    var value = 0;

    fakeAsync((async) {
      dispose = autorun(() {
        value = x.value + 1;
      }, delay: delayMs);

      async.elapse(Duration(milliseconds: 2500));

      expect(value, 0); // autorun() should not have executed at this time

      async.elapse(Duration(milliseconds: 2500));

      expect(value, 11); // autorun() should have executed

      x.value = 100;

      expect(value, 11); // should still retain the last value
      async.elapse(Duration(milliseconds: delayMs));
      expect(value, 101); // should change now
    });

    dispose();
  });

  test('autorun with pre-mature disposal in predicate', () {
    var x = observable(10);

    var d = autorun((Reaction r) {
      var isGreaterThan10 = x.value > 10;

      if (isGreaterThan10) {
        r.dispose();
      }
    });

    expect(d.$mobx.isDisposed, isFalse);

    x.value = 11;
    expect(d.$mobx.isDisposed, isTrue);
    d();
  });
}
