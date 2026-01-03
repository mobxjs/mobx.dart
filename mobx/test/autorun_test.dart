import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart' as mock;
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

// ignore_for_file: unnecessary_lambdas

void main() {
  testSetup();

  group('autorun()', () {
    test('basics work', () {
      final c = Observable(0);
      late int nextValue;

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
      late String message;

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
      int? value;

      final dispose = autorun((_) {
        value = (value == null) ? x.value : y.value;
      });

      expect(value, equals(10));
      x.value = 30;

      expect(value, equals(20)); // Should use y now

      dispose();
    });

    test('with delayed scheduler', () {
      late Function dispose;
      const delayMs = 5000;

      final x = Observable(10);
      var value = 0;

      fakeAsync((async) {
        dispose =
            autorun((_) {
              value = x.value + 1;
            }, delay: delayMs).call;

        async.elapse(const Duration(milliseconds: 2500));

        expect(value, 0); // autorun() should not have executed at this time

        async.elapse(const Duration(milliseconds: 2500));

        expect(value, 11); // autorun() should have executed

        x.value = 100;

        expect(value, 11); // should still retain the last value
        async.elapse(const Duration(milliseconds: delayMs));
        expect(value, 101); // should change now
      });

      dispose();
    });

    test('with custom scheduler', () {
      late Function dispose;
      const delayMs = 5000;

      final x = Observable(10);
      var value = 0;

      fakeAsync((async) {
        dispose =
            autorun(
              (_) {
                value = x.value + 1;
              },
              scheduler: (f) {
                return Timer(const Duration(milliseconds: delayMs), f);
              },
            ).call;

        async.elapse(const Duration(milliseconds: 2500));

        expect(value, 0); // autorun() should not have executed at this time

        async.elapse(const Duration(milliseconds: 2500));

        expect(value, 11); // autorun() should have executed

        x.value = 100;

        expect(value, 11); // should still retain the last value
        async.elapse(const Duration(milliseconds: delayMs));
        expect(value, 101); // should change now
      });

      dispose();
    });

    test('with pre-mature disposal in tracking function', () {
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
      final dispose = autorun(
        (_) {
          throw Exception('FAILED in autorun');
        },
        onError: (_, a) {
          thrown = true;
        },
      );

      expect(thrown, isTrue);
      expect(dispose.reaction.errorValue, isException);
      dispose();
    });

    test('uses provided context', () {
      final context = MockContext();
      mock.when(() => context.nameFor(mock.any())).thenReturn('Test-Reaction');

      autorun((_) {}, context: context);
      mock.verify(() => context.runReactions());
    });

    test('can be disposed inside the tracking function', () {
      final dispose = autorun((rxn) {
        rxn.dispose();
      });

      expect(dispose.reaction.isDisposed, isTrue);
    });

    test('can be disposed inside the tracking function with delay', () {
      final x = Observable(10);
      ReactionDisposer dispose;

      fakeAsync((async) {
        dispose = autorun((rxn) {
          final value = x.value + 1;
          if (value > 10) {
            rxn.dispose();
          }
        }, delay: 1000);

        async.elapse(const Duration(milliseconds: 1000));

        x.value = 11;

        async.elapse(const Duration(milliseconds: 1000));

        expect(dispose.reaction.isDisposed, isTrue);
      });
    });
  });
}
