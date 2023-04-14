import 'package:flutter/material.dart';
import 'package:flutter_mobx/src/multi_reaction_builder.dart';
import 'package:flutter_mobx/src/reaction_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

class Counter {
  Counter();

  Observable<int> state = Observable(0);

  void increment() => runInAction(() => state.value = state.value + 1);
}

void main() {
  group('MultiReactionBuilder', () {
    testWidgets('calls reactions on state changes', (tester) async {
      final statesA = <int>[];
      const expectedStatesA = [1, 2];
      final counterA = Counter();

      final statesB = <int>[];
      final expectedStatesB = [1];
      final counterB = Counter();

      await tester.pumpWidget(
        MultiReactionBuilder(
          builders: [
            ReactionBuilder(
              builder: (context) => reaction(
                (_) => counterA.state.value,
                (int state) => statesA.add(state),
              ),
            ),
            ReactionBuilder(
              builder: (context) => reaction(
                (_) => counterB.state.value,
                (int state) => statesB.add(state),
              ),
            ),
          ],
          child: const SizedBox(key: Key('multiListener_child')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('multiListener_child')), findsOneWidget);

      counterA.increment();
      await tester.pump();
      counterA.increment();
      await tester.pump();
      counterB.increment();
      await tester.pump();

      expect(statesA, expectedStatesA);
      expect(statesB, expectedStatesB);
    });
  });
}
