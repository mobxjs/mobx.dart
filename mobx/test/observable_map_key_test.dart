import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

// ignore_for_file: unnecessary_lambdas

void main() {
  testSetup();

  group('observeKey extension', () {
    test('returns the correct value for an existing key', () {
      final map = ObservableMap.of({'a': 1, 'b': 2, 'c': 3});

      final keyObservable = map.observeKey('b');

      expect(keyObservable.value, equals(2));
    });

    test('returns null for a non-existing key', () {
      final map = ObservableMap<String, int>.of({'a': 1});

      final keyObservable = map.observeKey('x');

      expect(keyObservable.value, isNull);
    });

    test('triggers reaction when observed key is updated', () {
      final map = ObservableMap.of({'a': 1, 'b': 2});
      final keyObservable = map.observeKey('a');

      var reactionCount = 0;
      int? lastValue;

      autorun((_) {
        lastValue = keyObservable.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));
      expect(lastValue, equals(1));

      // Update the observed key
      map['a'] = 100;

      expect(reactionCount, equals(2));
      expect(lastValue, equals(100));
    });

    test('does NOT trigger reaction when OTHER key is updated', () {
      final map = ObservableMap.of({'a': 1, 'b': 2, 'c': 3});
      final keyObservable = map.observeKey('a');

      var reactionCount = 0;

      autorun((_) {
        keyObservable.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));

      // Update a different key - should NOT trigger reaction
      map['b'] = 200;

      expect(reactionCount, equals(1));

      // Update another different key - should NOT trigger reaction
      map['c'] = 300;

      expect(reactionCount, equals(1));
    });

    test('triggers reaction when observed key is added', () {
      final map = ObservableMap<String, int>.of({'a': 1});
      final keyObservable = map.observeKey('b');

      var reactionCount = 0;
      int? lastValue;

      autorun((_) {
        lastValue = keyObservable.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));
      expect(lastValue, isNull);

      // Add the observed key
      map['b'] = 42;

      expect(reactionCount, equals(2));
      expect(lastValue, equals(42));
    });

    test('triggers reaction when observed key is removed', () {
      final map = ObservableMap.of({'a': 1, 'b': 2});
      final keyObservable = map.observeKey('a');

      var reactionCount = 0;
      int? lastValue;

      autorun((_) {
        lastValue = keyObservable.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));
      expect(lastValue, equals(1));

      // Remove the observed key
      map.remove('a');

      expect(reactionCount, equals(2));
      expect(lastValue, isNull);
    });

    test('triggers reaction when map is cleared', () {
      final map = ObservableMap.of({'a': 1, 'b': 2});
      final keyObservable = map.observeKey('a');

      var reactionCount = 0;
      int? lastValue;

      autorun((_) {
        lastValue = keyObservable.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));
      expect(lastValue, equals(1));

      // Clear the map
      map.clear();

      expect(reactionCount, equals(2));
      expect(lastValue, isNull);
    });

    test('multiple observeKey calls for different keys are independent', () {
      final map = ObservableMap.of({'a': 1, 'b': 2, 'c': 3});
      final keyA = map.observeKey('a');
      final keyB = map.observeKey('b');

      var reactionCountA = 0;
      var reactionCountB = 0;

      autorun((_) {
        keyA.value;
        reactionCountA++;
      });

      autorun((_) {
        keyB.value;
        reactionCountB++;
      });

      expect(reactionCountA, equals(1));
      expect(reactionCountB, equals(1));

      // Update key 'a' - only reaction A should fire
      map['a'] = 100;

      expect(reactionCountA, equals(2));
      expect(reactionCountB, equals(1));

      // Update key 'b' - only reaction B should fire
      map['b'] = 200;

      expect(reactionCountA, equals(2));
      expect(reactionCountB, equals(2));

      // Update key 'c' - neither should fire
      map['c'] = 300;

      expect(reactionCountA, equals(2));
      expect(reactionCountB, equals(2));
    });

    test('works inside a Computed', () {
      final map = ObservableMap.of({'a': 1, 'b': 2});
      final keyObservable = map.observeKey('a');

      final doubled = Computed(() => (keyObservable.value ?? 0) * 2);

      var reactionCount = 0;
      int? lastValue;

      autorun((_) {
        lastValue = doubled.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));
      expect(lastValue, equals(2));

      // Update the observed key
      map['a'] = 10;

      expect(reactionCount, equals(2));
      expect(lastValue, equals(20));

      // Update a different key - should NOT trigger reaction
      map['b'] = 200;

      expect(reactionCount, equals(2));
    });

    test('disposes listener when reaction is disposed', () {
      final map = ObservableMap.of({'a': 1, 'b': 2});
      final keyObservable = map.observeKey('a');

      var reactionCount = 0;

      final dispose = autorun((_) {
        keyObservable.value;
        reactionCount++;
      });

      expect(reactionCount, equals(1));

      // Update should trigger
      map['a'] = 100;
      expect(reactionCount, equals(2));

      // Dispose the reaction
      dispose();

      // Updates should no longer trigger (reaction is disposed)
      map['a'] = 200;
      expect(reactionCount, equals(2));
    });

    test('uses custom name when provided', () {
      final map = ObservableMap.of({'a': 1});
      final keyObservable = map.observeKey('a', name: 'MyCustomName');

      // The name property should be accessible (implementation detail test)
      // This mainly ensures the name parameter is properly passed through
      expect(keyObservable, isNotNull);
    });

    test('comparing observeKey vs direct map access - rebuild behavior', () {
      final map = ObservableMap.of({'a': 1, 'b': 2, 'c': 3});

      // Using observeKey - granular observation
      final keyObservable = map.observeKey('a');
      var granularReactionCount = 0;
      autorun((_) {
        keyObservable.value;
        granularReactionCount++;
      });

      // Using direct map access - observes entire map
      var directReactionCount = 0;
      autorun((_) {
        map['a'];
        directReactionCount++;
      });

      expect(granularReactionCount, equals(1));
      expect(directReactionCount, equals(1));

      // Update the observed key 'a' - both should react
      map['a'] = 100;
      expect(granularReactionCount, equals(2));
      expect(directReactionCount, equals(2));

      // Update a different key 'b' - only direct access reacts
      map['b'] = 200;
      expect(granularReactionCount, equals(2)); // NOT triggered
      expect(directReactionCount, equals(3)); // triggered

      // Update another key 'c' - only direct access reacts
      map['c'] = 300;
      expect(granularReactionCount, equals(2)); // NOT triggered
      expect(directReactionCount, equals(4)); // triggered
    });
  });
}
