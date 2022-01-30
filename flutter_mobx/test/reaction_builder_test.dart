import 'package:flutter/material.dart';
import 'package:flutter_mobx/src/reaction_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

class _TestWrapper extends StatefulWidget {
  final Observable<int> counter;

  const _TestWrapper({Key? key, required this.counter}) : super(key: key);

  @override
  State<_TestWrapper> createState() => _TestWrapperState();
}

class _TestWrapperState extends State<_TestWrapper> {
  bool showChild = true;

  @override
  Widget build(BuildContext context) {
    return showChild
        ? ReactionBuilder(
            builder: (context) {
              return reaction((_) => widget.counter.value, (value) {
                // ignore
              });
            },
            child: Container())
        : Container();
  }

  void remove() {
    setState(() {
      showChild = false;
    });
  }
}

void main() {
  group("ReactionBuilder", () {
    setUp(() {
      mainContext.config =
          ReactiveConfig.main.clone(writePolicy: ReactiveWritePolicy.never);
    });

    tearDown(() {
      mainContext.config = ReactiveConfig.main;
    });

    testWidgets('ReactionBuilder is behaving correctly', (tester) async {
      final message = Observable(0);

      await tester.pumpWidget(_TestWrapper(counter: message));

      final builderState = tester.firstState(find.byType(ReactionBuilder))
          as ReactionBuilderState;

      final wrapperState =
          tester.firstState(find.byType(_TestWrapper)) as _TestWrapperState;
      wrapperState.remove();

      await tester.pump();

      expect(builderState.isDisposed, true);
    });

    testWidgets('Reaction inside the builder is invoked correctly',
        (tester) async {
      final message = Observable(0);
      int count = 0;

      await tester.pumpWidget(ReactionBuilder(
          builder: (context) {
            return reaction((_) => message.value, (int value) {
              count = value;
            });
          },
          child: Container()));

      message.value += 1;
      expect(count, 1);

      message.value += 1;
      expect(count, 2);
    });
  });
}
