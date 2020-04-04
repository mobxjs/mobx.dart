import 'package:test/test.dart';
import 'package:mobx/mobx.dart';

import 'util.dart';

void main() {
  turnOffWritePolicy();

  group('Spy', () {
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
        expect((event as ObservableValueSpyEvent).newValue, equals(0));
      });

      Observable(0);

      d();
    });

    test('spy-event is raised when a Computed is evaluated', () {
      final x = Observable(0);
      final y = Computed(() => x.value + 1);

      // Create a reaction so as to force the computed value to be read
      // ComputedSpyEvent is not raised outside of a reaction (aka batch)
      final d1 = reaction((_) => y.value, (_) {});

      var wasComputedSpyEventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ComputedValueSpyEvent) {
          wasComputedSpyEventRaised = true;
        }
      });

      x.value++;

      expect(wasComputedSpyEventRaised, isTrue);

      d();
      d1();
    });

    test('spy-event is raised when an Action is executed', () {
      var eventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ActionSpyEvent) {
          eventRaised = true;
        }
      });

      runInAction(() {});

      expect(eventRaised, isTrue);

      d();
    });

    test('spy-event is raised when a Reaction is executed', () {
      final o = Observable(0);
      final d1 = reaction((_) => o.value, (_) {});

      var eventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ReactionSpyEvent) {
          eventRaised = true;
        }
      });

      o.value++; // force the reaction to run

      expect(eventRaised, isTrue);

      d();
      d1();
    });

    test('spy-event is raised when a Reaction errors', () {
      final o = Observable(0);
      final d1 = reaction((_) {
        if (o.value == 1) {
          throw Exception('test failure');
        }
      }, (_) {});

      var eventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ReactionErrorSpyEvent) {
          eventRaised = true;
        }
      });

      o.value++; // force the reaction to run

      expect(eventRaised, isTrue);

      d();
      d1();
    });

    test('spy-event is raised when a Reaction disposes', () {
      final o = Observable(0);
      final d1 = reaction((_) => o.value, (_) {});

      var eventRaised = false;
      final d = mainContext.spy((event) {
        if (event is ReactionDisposedSpyEvent) {
          eventRaised = true;
        }
      });

      o.value++; // force the reaction to run

      d1();
      expect(eventRaised, isTrue);

      d();
    });
  });
}
