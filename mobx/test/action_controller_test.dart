import 'package:mobx/src/core.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

class MockDerivation extends Mock implements Derivation {}

void main() {
  group('ActionController', () {
    test('startAction calls context.untrackedStart and startBatch', () {
      final context = MockContext();
      ActionController(context: context).startAction();

      verifyInOrder([
        context.untrackedStart(),
        context.startBatch(),
      ]);
    });

    test('endAction calls context.endBatch and untrackedEnd', () {
      final context = MockContext();
      final prevDerivation = MockDerivation();

      when(context.untrackedStart()).thenReturn(prevDerivation);

      ActionController(context: context)
        ..startAction()
        ..endAction(prevDerivation);

      verifyInOrder([
        context.endBatch(),
        context.untrackedEnd(prevDerivation),
      ]);
    });
  });
}
