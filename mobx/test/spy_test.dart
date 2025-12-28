import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup(throwReactionErrors: false);

  group('Spy', () {
    setUp(() {
      mainContext.config = ReactiveConfig.main.clone(
        isSpyEnabled: true,
        writePolicy: ReactiveWritePolicy.never,
      );
    });

    tearDown(() {
      mainContext.config = ReactiveConfig.main;
    });

    test('spies are disabled by default', () {
      final context = ReactiveContext();
      expect(context.isSpyEnabled, isFalse);
    });

    test('spies can be added and removed', () {
      final dispose = mainContext.spy((event) {});

      expect(mainContext.isSpyEnabled, isTrue);
      dispose();

      expect(mainContext.isSpyEnabled, isFalse);
    });

    test('spy-event is raised when an Observable is created', () {
      final d = mainContext.spy((event) {
        expect(event, isA<ObservableValueSpyEvent>());

        final obj = event as ObservableValueSpyEvent;
        expect(obj.newValue, equals(0));
        expect(obj.toString(), equals('observable test=0, previously=null'));
      });

      Observable(0, name: 'test');

      d();
    });

    test('spy-event is raised when an Observable is updated', () {
      final o = Observable(0, name: 'test');

      var eventRaised = false;
      var endEventRaised = false;

      final d = mainContext.spy((event) {
        if (event is ObservableValueSpyEvent) {
          eventRaised = true;

          expect(
            event.toString(),
            equals('observable(START) test=1, previously=0'),
          );
        }

        if (event is EndedSpyEvent && event.type == 'observable') {
          endEventRaised = true;

          expect(event.toString(), equals('observable(END) test'));
        }
      });

      o.value++;

      expect(eventRaised, isTrue);
      expect(endEventRaised, isTrue);

      d();
    });

    test('spy-event is raised when a Computed is evaluated', () {
      final x = Observable(0);
      final y = Computed(() => x.value + 1, name: 'test');

      // Create a reaction so as to force the computed value to be read
      // ComputedSpyEvent is not raised outside of a reaction (aka batch)
      final d1 = reaction((_) => y.value, (_) {});

      var wasComputedSpyEventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ComputedValueSpyEvent) {
          wasComputedSpyEventRaised = true;

          expect(event.toString(), equals('computed test'));
        }
      });

      x.value++;

      expect(wasComputedSpyEventRaised, isTrue);

      d();
      d1();
    });

    test('spy-event is raised when an Action is executed', () {
      var eventRaised = false;
      var endEventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ActionSpyEvent) {
          eventRaised = true;

          expect(event.toString(), equals('action(START) test'));
        }

        if (event is EndedSpyEvent && event.type == 'action') {
          endEventRaised = true;

          expect(
            event.toString(),
            matches(RegExp(r'action\(END [^\)]*\) test')),
          );
        }
      });

      runInAction(() {}, name: 'test');

      expect(eventRaised, isTrue);
      expect(endEventRaised, isTrue);

      d();
    });

    // TODO: https://github.com/mobxjs/mobx.dart/issues/734
    test(
      'spy-event is raised only once when an AsyncAction is executed',
      () async {
        var eventCount = 0;
        var endEventCount = 0;
        final d = mainContext.spy((event) {
          if (event is ActionSpyEvent) {
            eventCount += 1;
          }

          if (event is EndedSpyEvent && event.type == 'action') {
            endEventCount += 1;
          }
        });

        final actionCompleter = Completer();
        final microtaskCompleter = Completer();
        AsyncAction('test').run(() async {
          scheduleMicrotask(() {
            microtaskCompleter.complete();
          });
          actionCompleter.complete();
        });
        await actionCompleter.future;
        await microtaskCompleter.future;

        // This is needed to ensure that all spy callbacks are executed
        // before moving on to `expect`s.
        await Future.value();

        expect(eventCount, 1);
        expect(endEventCount, 1);

        d();
      },
      skip: true,
    );

    test('spy-event is raised when a Reaction is executed', () {
      final o = Observable(0);
      final d1 = reaction((_) => o.value, (_) {}, name: 'test');

      var eventRaised = false;
      var endEventRaised = false;

      final d = mainContext.spy((event) {
        if (event is ReactionSpyEvent) {
          eventRaised = true;

          expect(event.toString(), equals('reaction(START) test'));
        }

        if (event is EndedSpyEvent && event.type == 'reaction') {
          endEventRaised = true;

          expect(
            event.toString(),
            matches(RegExp(r'reaction\(END [^\)]*\) test')),
          );
        }
      });

      o.value++; // force the reaction to run

      expect(eventRaised, isTrue);
      expect(endEventRaised, isTrue);

      d();
      d1();
    });

    test('spy-event is raised when a Reaction errors', () {
      final o = Observable(0);
      final d1 = reaction(
        (_) {
          if (o.value == 1) {
            throw Exception('test failure');
          }
        },
        (_) {},
        name: 'test',
      );

      var eventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ReactionErrorSpyEvent) {
          eventRaised = true;

          expect(event.toString(), startsWith('reaction-error test'));
        }
      });

      o.value++; // force the reaction to run

      expect(eventRaised, isTrue);

      d();
      d1();
    });

    test('spy-event is raised when a Reaction disposes', () {
      final o = Observable(0);
      final d1 = reaction((_) => o.value, (_) {}, name: 'test');

      var eventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ReactionDisposedSpyEvent) {
          eventRaised = true;

          expect(event.toString(), equals('reaction-dispose test'));
        }
      });

      o.value++; // force the reaction to run

      d1();
      expect(eventRaised, isTrue);

      d();
    });

    test('calling atom read/write raises a spy event', () {
      final atom = Atom(name: 'test');
      var eventRaised = false;

      final d = mainContext.spy((event) {
        if (event is EndedSpyEvent && event.type == 'observable') {
          eventRaised = true;

          expect(event.toString(), equals('observable(END) test'));
        }
      });

      atom.reportRead();

      // ignore: cascade_invocations
      atom.reportWrite('test', null, () {});

      expect(eventRaised, isTrue);

      d();
    });
  });
}
