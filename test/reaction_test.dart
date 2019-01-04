import 'package:fake_async/fake_async.dart';
import 'package:mobx/src/api/observable.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:test/test.dart';

void main() {
  test('Reaction basics', () {
    var executed = false;
    final x = observable(10);
    final d = reaction((_) => x.value > 10, (isGreaterThan10) {
      executed = true;
    }, name: 'Basic Reaction');

    expect(executed, isFalse);

    x.value = 11; // false -> true, should invoke effect
    expect(executed, isTrue);
    executed = false;

    x.value = 9; // true -> false, should invoke effect
    expect(executed, isTrue);

    executed = false;
    d();

    x.value = 11;
    expect(executed, isFalse); // reaction has been disposed, so no more effects
  });

  test('Reaction with delay', () {
    final x = observable(10);
    var executed = false;

    final d = reaction((_) => x.value > 10, (isGreaterThan10) {
      executed = true;
    }, delay: 1000);

    fakeAsync((async) {
      x.value = 11;

      // Even though predicate has changed, effect should not be executed
      expect(executed, isFalse);
      async.elapse(Duration(milliseconds: 500));
      expect(executed, isFalse); // should still be false as 1s has not elapsed

      async.elapse(Duration(milliseconds: 500)); // should now trigger effect
      expect(executed, isTrue);
    });
    d();
  });

  test('Reaction that fires immediately', () {
    final x = observable(10);
    var executed = false;

    final d = reaction((_) => x.value > 10, (isGreaterThan10) {
      executed = true;
    }, fireImmediately: true);

    expect(executed, isTrue); // should fire immediately
    d();
  });

  test('Reaction that fires immediately with delay', () {
    final x = observable(10);
    var executed = false;

    final d = reaction((_) => x.value > 10, (isGreaterThan10) {
      executed = true;
    }, delay: 1000, fireImmediately: true);

    fakeAsync((async) {
      // Effect should be executed, as we are forcing an immediate change even though there is a delay
      expect(executed, isTrue);

      x.value = 11; // predicate goes from false -> true

      executed = false;
      async.elapse(Duration(milliseconds: 500));
      expect(executed, isFalse); // should still be false as 1s has not elapsed

      async.elapse(Duration(milliseconds: 500)); // should now trigger effect
      expect(executed, isTrue);

      executed = false;
      // predicate goes from true -> false, but effect should not run for next 1s
      x.value = 9;

      expect(executed, isFalse);
      async.elapse(Duration(milliseconds: 1000)); // should now trigger effect
      expect(executed, isTrue);
    });

    d();
  });

  test('reaction with pre-mature disposal in predicate', () {
    final x = observable(10);
    var executed = false;

    final d = reaction((reaction) {
      final isGreaterThan10 = x.value > 10;

      if (isGreaterThan10) {
        reaction.dispose();
      }

      return isGreaterThan10;
    }, (_) {
      executed = true;
    });

    expect(d.$mobx.isDisposed, isFalse);

    x.value = 11;
    expect(executed, isTrue);
    expect(d.$mobx.isDisposed, isTrue);
    d();
  });
}
