import 'package:mobx/src/core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

class MockDerivation extends Mock implements Derivation {}

void main() {
  testSetup();

  group('ActionController', () {
    test('can be created with both null context and name', () {
      ActionController();
    });
    test(
        'startAction calls startUntracked, startBatch and startAllowStateChanges',
        () {
      final context = MockContext();
      ActionController(context: context).startAction();

      verifyInOrder([
        context.startUntracked(),
        context.startBatch(),
        context.startAllowStateChanges(allow: true),
      ]);
    });

    test('endAction calls endAllowStateChanges, endBatch and endUntracked', () {
      final context = MockContext();
      final prevDerivation = MockDerivation();

      when(context.startUntracked()).thenReturn(prevDerivation);

      final runInfo = ActionRunInfo(
          name: 'test',
          prevDerivation: prevDerivation,
          prevAllowStateChanges: false,
          startTime: DateTime.now());

      ActionController(context: context)
        ..startAction()
        ..endAction(runInfo);

      verifyInOrder([
        context.endAllowStateChanges(allow: false),
        context.endBatch(),
        context.endUntracked(prevDerivation),
      ]);
    });
  });
}
