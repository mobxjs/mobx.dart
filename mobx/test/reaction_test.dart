import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mobx/src/core.dart';
import 'package:mobx/src/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

// ignore_for_file: unnecessary_lambdas

void main() {
  testSetup();

  group('Reaction', () {
    test('toString', () {
      final object = ReactionImpl(mainContext, () => null, name: 'MyName');
      expect(object.toString(), contains('MyName'));
    });

    test('debugCreationStack', () {
      DebugCreationStack.enable = true;
      addTearDown(() => DebugCreationStack.enable = false);
      final object = ReactionImpl(mainContext, () => null, name: 'MyName');
      expect(object.debugCreationStack, isNotNull);
    });

    test('basics work', () {
      var executed = false;
      final x = Observable(10);
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
        executed,
        isFalse,
      ); // reaction has been disposed, so no more effects
    });

    group('equals override', () {
      test('basics work', () {
        var executed = false;

        bool equals(_, __) => false;

        final x = Observable(10, equals: equals);
        final d = reaction(
          (_) => x.value,
          (_) {
            executed = true;
          },
          name: 'Basic Reaction',
          equals: equals,
        );

        expect(executed, isFalse);

        x.value = 11;
        expect(executed, isTrue);
        executed = false;

        x.value = 11;
        expect(executed, isTrue);
        executed = false;

        d();

        x.value = 11;
        expect(
          executed,
          isFalse,
        ); // reaction has been disposed, so no more effects
      });
    });

    test('works with delay', () {
      final x = Observable(10);
      var executed = false;

      final d = reaction((_) => x.value > 10, (isGreaterThan10) {
        executed = true;
      }, delay: 1000);

      fakeAsync((async) {
        x.value = 11;

        // Even though tracking function has changed, effect should not be executed
        expect(executed, isFalse);
        async.elapse(const Duration(milliseconds: 500));
        expect(
          executed,
          isFalse,
        ); // should still be false as 1s has not elapsed

        async.elapse(
          const Duration(milliseconds: 500),
        ); // should now trigger effect
        expect(executed, isTrue);

        d();
      });
    });

    test('works with scheduler', () {
      final x = Observable(10);
      var executed = false;

      final d = reaction(
        (_) => x.value > 10,
        (isGreaterThan10) {
          executed = true;
        },
        scheduler: (fn) => Timer(const Duration(milliseconds: 1000), fn),
      );

      fakeAsync((async) {
        x.value = 11;

        // Even though tracking function has changed, effect should not be executed
        expect(executed, isFalse);
        async.elapse(const Duration(milliseconds: 500));
        expect(
          executed,
          isFalse,
        ); // should still be false as 1s has not elapsed

        async.elapse(
          const Duration(milliseconds: 500),
        ); // should now trigger effect
        expect(executed, isTrue);

        d();
      });
    });

    test('that fires immediately', () {
      final x = Observable(10);
      var executed = false;

      final d = reaction((_) => x.value > 10, (isGreaterThan10) {
        executed = true;
      }, fireImmediately: true);

      expect(executed, isTrue); // should fire immediately
      d();
    });

    test('that fires immediately with delay', () {
      final x = Observable(10);
      var executed = false;

      final d = reaction(
        (_) => x.value > 10,
        (isGreaterThan10) {
          executed = true;
        },
        delay: 1000,
        fireImmediately: true,
      );

      fakeAsync((async) {
        // Effect should be executed, as we are forcing an immediate change even though there is a delay
        expect(executed, isTrue);

        x.value = 11; // tracking function goes from false -> true

        executed = false;
        async.elapse(const Duration(milliseconds: 500));
        expect(
          executed,
          isFalse,
        ); // should still be false as 1s has not elapsed

        async.elapse(
          const Duration(milliseconds: 500),
        ); // should now trigger effect
        expect(executed, isTrue);

        executed = false;
        // tracking function goes from true -> false, but effect should not run for next 1s
        x.value = 9;

        expect(executed, isFalse);
        async.elapse(
          const Duration(milliseconds: 1000),
        ); // should now trigger effect
        expect(executed, isTrue);

        d();
      });
    });

    test('with pre-mature disposal in tracking function', () {
      final x = Observable(10);
      var executed = false;

      final d = reaction(
        (reaction) {
          final isGreaterThan10 = x.value > 10;

          if (isGreaterThan10) {
            reaction.dispose();
          }

          return isGreaterThan10;
        },
        (_) {
          executed = true;
        },
      );

      expect(d.reaction.isDisposed, isFalse);

      x.value = 11;
      expect(executed, isTrue);
      expect(d.reaction.isDisposed, isTrue);
      d();
    });

    test('fires onError on exception inside tracking function', () {
      var thrown = false;
      final dispose = reaction(
        (_) {
          throw Exception('FAILED in reaction');
        },
        (_) {},
        onError: (_, a) {
          thrown = true;
        },
      );

      expect(thrown, isTrue);
      expect(dispose.reaction.errorValue, isException);
      dispose();
    });

    test('fires onError on exception inside effect', () {
      var thrown = false;
      final x = Observable(false);

      final dispose = reaction(
        (_) => x.value,
        (_) {
          throw Exception('FAILED in reaction');
        },
        onError: (_, a) {
          thrown = true;
        },
      );

      x.value = true; // force a change
      expect(thrown, isTrue);
      expect(dispose.reaction.errorValue, isException);
      expect(
        dispose.reaction.errorValue.toString(),
        contains('MobXCaughtException'),
      );
      dispose();
    });

    test('uses provided context', () {
      final context = MockContext();
      when(() => context.nameFor(any())).thenReturn('Test-Reaction');

      int trackingFn(Reaction reaction) => 1;
      void onInvalidate(int i) {}
      final dispose = reaction(trackingFn, onInvalidate, context: context);

      verifyInOrder([
        () => context.nameFor('Reaction'),
        () => context.addPendingReaction(dispose.reaction),
        () => context.runReactions(),
      ]);

      dispose();
    });

    test('reaction throws when config.disableErrorBoundaries = true', () {
      final context = ReactiveContext(
        config: ReactiveConfig(disableErrorBoundaries: true),
      );

      expect(() {
        final dispose = reaction(
          (_) => throw Exception('FAIL'),
          (_) {},
          context: context,
        );

        dispose();
      }, throwsException);
    });

    group('start/endTracking', () {
      test('reacts to changes to reactive values between begin and end', () {
        var i = 0;

        final reaction = ReactionImpl(mainContext, () {
          i++;
        }, name: 'test_reaction');

        final var1 = Observable(0);
        final var2 = Observable(0);

        final prevDerivation = reaction.startTracking();
        final var3 = Observable(0);
        var1.value;
        reaction.endTracking(prevDerivation);

        // No changes, no calls to onInvalidate
        expect(i, equals(0));

        // Change outside tracking, no onInvalidate call
        var2.value += 1;
        expect(i, equals(0));

        // Change outside tracking to an observable created inside tracking
        // no onInvalidate call
        var3.value += 1;
        expect(i, equals(0));

        // Changing a value that was read when tracking was active
        // calls onInvalidate
        var1.value += 1;
        expect(i, equals(1));

        // No calls to onInvalidate after first change
        var1.value += 1;
        expect(i, equals(1));
      });

      test("when disposed, doesn't call onInvalidate", () {
        var i = 0;
        final reaction = ReactionImpl(mainContext, () {
          i++;
        }, name: 'test_reaction');
        final var1 = Observable(0);

        final prevDerivation = reaction.startTracking();
        var1.value;
        reaction
          ..endTracking(prevDerivation)
          ..dispose();

        var1.value += 1;
        expect(i, equals(0));
      });

      test('autorun works inside tracking', () {
        var i = 0;
        var autoVar = 0;
        final reaction = ReactionImpl(mainContext, () {
          i++;
        }, name: 'test_reaction');
        final var1 = Observable(0);

        final prevDerivation = reaction.startTracking();
        var1.value;
        autorun((_) {
          autoVar += var1.value;
        });
        reaction.endTracking(prevDerivation);

        var1.value = 1;

        expect(i, equals(1));
        expect(autoVar, equals(1));
      });

      test('ReactionImpl tracks observables', () {
        final reaction = ReactionImpl(
          mainContext,
          () {},
          name: 'test_reaction_1',
        )..track(() {});

        expect(reaction.hasObservables, isFalse);

        final x = Observable(0);
        final reaction1 = ReactionImpl(
          mainContext,
          () {},
          name: 'test_reaction_2',
        )..track(() => x.value + 1);

        expect(reaction1.hasObservables, isTrue);
      });

      test('when disposed, clearObservables', () {
        final x = Observable(0);

        final reaction = ReactionImpl(
          mainContext,
          () {},
          name: 'test_reaction_1',
        )..track(() => x.value + 1);
        expect(reaction.hasObservables, isTrue);

        reaction.dispose();
        final prevDerivation = reaction.startTracking();
        reaction.endTracking(prevDerivation);

        expect(reaction.hasObservables, isFalse);
      });
    });
  });
}
