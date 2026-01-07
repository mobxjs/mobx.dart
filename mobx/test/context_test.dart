import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart' as mock;
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

// ignore_for_file: unnecessary_lambdas

void main() {
  testSetup(throwReactionErrors: false);

  group('ReactiveContext', () {
    test('comes with default config', () {
      final ctx = ReactiveContext();

      expect(ctx.config, equals(ReactiveConfig.main));
    });

    test('global onReactionError is invoked for reaction errors', () {
      var caught = false;

      final dispose = mainContext.onReactionError((_, rxn) {
        caught = true;
        expect(rxn.errorValue, isNotNull);
      });
      final dispose1 = autorun((_) => throw Exception('autorun FAIL'));

      expect(caught, isTrue);

      dispose();
      dispose1();
    });

    test(
      'can change observables inside computed if there are no observers',
      () {
        final x = Observable(0);

        final c = Computed(() => x.value++);

        expect(() => c.value, returnsNormally);
      },
    );

    test(
      'cannot change observables inside computed if they have observers',
      () {
        final x = Observable(0);

        final c = Computed<int>(() => x.value++);

        expect(() {
          final d = autorun((_) => x.value);
          // Fetch the value which is in turn mutating the observable (x.value).
          // This is not allowed because there is an observer: autorun.
          c.value;
          d();
        }, throwsException);
      },
    );

    test('throws Exception for reactions that do not converge', () {
      var firstTime = true;
      final a = Observable(0);
      final d = autorun((_) {
        a.value;
        if (firstTime) {
          firstTime = false;
          return;
        }

        // cyclic-dependency!!!
        // this autorun() will keep on getting triggered as a.value keeps changing
        // every time it's invoked
        runInAction(() {
          a.value = a.value + 1;
        });
      }, name: 'Cyclic Reaction');

      expect(
        () => runInAction(() => a.value = 1),
        throwsA(const TypeMatcher<MobXCyclicReactionException>()),
      );
      d();
    });

    group('conditionallyRunInAction', () {
      setUpAll(() {
        mock.registerFallbackValue(FakeActionRunInfo());
      });

      test(
        'when running OUTSIDE an Action, it should USE the ActionController',
        () {
          final controller = MockActionController();
          mock
              .when(() => controller.startAction(name: mock.any(named: 'name')))
              .thenReturn(MockActionRunInfo());

          final context = createContext();
          var hasRun = false;
          final o = Observable(0);

          context.conditionallyRunInAction(
            () {
              hasRun = true;
            },
            o,
            actionController: controller,
          );

          mock.verifyInOrder([
            () => controller.startAction(),
            () => controller.endAction(mock.any()),
          ]);
          expect(hasRun, isTrue);
        },
      );

      test(
        'when no ActionController is provided, it should create an ad-hoc ActionController',
        () {
          final context = createContext();
          var hasRun = false;
          final o = Observable(0);

          context.conditionallyRunInAction(() {
            hasRun = true;
          }, o);

          expect(hasRun, isTrue);
        },
      );

      test(
        'when running INSIDE an Action, it should NOT USE the ActionController',
        () {
          final controller = MockActionController();
          final context = createContext();
          final o = Observable(0);

          var hasRun = false;

          runInAction(() {
            context.conditionallyRunInAction(
              () {
                hasRun = true;
              },
              o,
              actionController: controller,
            );
          }, context: context);

          mock.verifyNever(() => controller.startAction());
          mock.verifyNever(() => controller.endAction(mock.any()));
          expect(hasRun, isTrue);
        },
      );
    });
  });

  group('ReactiveConfig', () {
    test('clone works', () {
      final config = ReactiveConfig.main;
      final clone = config.clone(maxIterations: 10);

      expect(clone.maxIterations, equals(10));
      expect(clone.maxIterations != config.maxIterations, isTrue);
      expect(
        clone.disableErrorBoundaries == config.disableErrorBoundaries,
        isTrue,
      );
      expect(clone.writePolicy == config.writePolicy, isTrue);
      expect(clone.readPolicy == config.readPolicy, isTrue);
    });

    test('when no overrides are provided the clone reuses source values', () {
      final config = ReactiveConfig.main;
      final clone = config.clone(); // No change

      expect(clone.maxIterations, equals(config.maxIterations));
      expect(
        clone.disableErrorBoundaries,
        equals(config.disableErrorBoundaries),
      );
      expect(clone.writePolicy, equals(config.writePolicy));
      expect(clone.readPolicy, equals(config.readPolicy));
    });
  });
}
