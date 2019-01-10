import 'package:fake_async/fake_async.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mobx/mobx.dart' hide when;

import 'shared_mocks.dart';

void main() {
  group('Reaction', () {
    test('basics work', () {
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
      expect(
          executed, isFalse); // reaction has been disposed, so no more effects
    });

    test('works with delay', () {
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
        expect(
            executed, isFalse); // should still be false as 1s has not elapsed

        async.elapse(Duration(milliseconds: 500)); // should now trigger effect
        expect(executed, isTrue);

        d();
      });
    });

    test('that fires immediately', () {
      final x = observable(10);
      var executed = false;

      final d = reaction((_) => x.value > 10, (isGreaterThan10) {
        executed = true;
      }, fireImmediately: true);

      expect(executed, isTrue); // should fire immediately
      d();
    });

    test('that fires immediately with delay', () {
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
        expect(
            executed, isFalse); // should still be false as 1s has not elapsed

        async.elapse(Duration(milliseconds: 500)); // should now trigger effect
        expect(executed, isTrue);

        executed = false;
        // predicate goes from true -> false, but effect should not run for next 1s
        x.value = 9;

        expect(executed, isFalse);
        async.elapse(Duration(milliseconds: 1000)); // should now trigger effect
        expect(executed, isTrue);

        d();
      });
    });

    test('with pre-mature disposal in predicate', () {
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

    test('fires onError on exception inside predicate', () {
      var thrown = false;
      final dispose = reaction(
          (_) {
            throw Exception('FAILED in reaction');
          },
          (_) {},
          onError: (_, _a) {
            thrown = true;
          });

      expect(thrown, isTrue);
      expect(dispose.$mobx.errorValue, isException);
      dispose();
    });

    test('fires onError on exception inside effect', () {
      var thrown = false;
      final x = observable(false);

      final dispose = reaction((_) => x.value, (_) {
        throw Exception('FAILED in reaction');
      }, onError: (_, _a) {
        thrown = true;
      });

      x.value = true; // force a change
      expect(thrown, isTrue);
      expect(dispose.$mobx.errorValue, isException);
      dispose();
    });

    test('uses provided context', () {
      final context = MockContext();
      int trackingFn(Reaction reaction) => 1;
      void onInvalidate(int i) {}
      final dispose = reaction(trackingFn, onInvalidate, context: context);

      verify(context.nameFor('Reaction'));
      verify(context.addPendingReaction(dispose.$mobx));
      verify(context.runReactions());

      dispose();
    });

    test('reaction throws when config.disableErrorBoundaries = true', () {
      final context =
          ReactiveContext(config: ReactiveConfig(disableErrorBoundaries: true));

      expect(() {
        final dispose =
            reaction((_) => throw Exception('FAIL'), (_) {}, context: context);

        dispose();
      }, throwsException);
    });
  });
}
