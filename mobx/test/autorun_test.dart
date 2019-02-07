import 'package:fake_async/fake_async.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/api/reaction.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';

void main() {
  setUp(() => mainContext.config =
      ReactiveConfig(enforceActions: EnforceActions.never));

  tearDown(() => mainContext.config = ReactiveConfig.main);

  group('autorun()', () {
    test('basics work', () {
      final c = Observable(0);
      int nextValue;

      final dispose = autorun((_) {
        nextValue = c.value + 1;
      });

      expect(dispose.reaction.name, startsWith('Autorun@'));
      expect(nextValue, equals(1));

      c.value = 10;
      expect(nextValue, equals(11));

      dispose(); // reaction should not run after this, even as dependent observables change

      c.value = 100;
      expect(nextValue, isNot(equals(101))); // Should not change
      expect(nextValue, equals(11)); // Remains the same as last value
    });

    test('with 2 observables', () {
      final x = Observable('Hello');
      final y = Observable('Pavan');
      String message;

      final dispose = autorun((_) {
        message = '${x.value} ${y.value}';
      }, name: 'Message Effect');

      expect(message, equals('Hello Pavan'));
      expect(dispose.reaction.name, equals('Message Effect'));

      x.value = 'Hey';
      expect(message, equals('Hey Pavan'));
      y.value = 'MobX';
      expect(message, equals('Hey MobX'));

      dispose();
    });

    test('with changing observables', () {
      final x = Observable(10);
      final y = Observable(20);
      int value;

      final dispose = autorun((_) {
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

      final x = Observable(10);
      var value = 0;

      fakeAsync((async) {
        dispose = autorun((_) {
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

    test('with pre-mature disposal in predicate', () {
      final x = Observable(10);

      final d = autorun((reaction) {
        final isGreaterThan10 = x.value > 10;

        if (isGreaterThan10) {
          reaction.dispose();
        }
      });

      expect(d.reaction.isDisposed, isFalse);

      x.value = 11;
      expect(d.reaction.isDisposed, isTrue);
      d();
    });

    test('fires onError on exception', () {
      var thrown = false;
      final dispose = autorun((_) {
        throw Exception('FAILED in autorun');
      }, onError: (_, _a) {
        thrown = true;
      });

      expect(thrown, isTrue);
      expect(dispose.reaction.errorValue, isException);
      dispose();
    });

    test('uses provided context', () {
      final context = MockContext();
      autorun((_) {}, context: context);
      verify(context.runReactions());
    });

    test('can be disposed inside the tracking function', () {
      final dispose = autorun((_) {
        _.dispose();
      });

      expect(dispose.reaction.isDisposed, isTrue);
    });

    test('can be disposed inside the tracking function with delay', () {
      final x = Observable(10);
      ReactionDisposer dispose;

      fakeAsync((async) {
        dispose = autorun((_) {
          final value = x.value + 1;
          if (value > 10) {
            _.dispose();
          }
        }, delay: 1000);

        async.elapse(Duration(milliseconds: 1000));

        x.value = 11;

        async.elapse(Duration(milliseconds: 1000));

        expect(dispose.reaction.isDisposed, isTrue);
      });
    });
  });
}
