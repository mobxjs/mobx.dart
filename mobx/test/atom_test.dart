import 'package:mobx/mobx.dart';
import 'package:mobx/src/utils.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  group('Atom', () {
    test('toString', () {
      final object = Atom(name: 'MyName');
      expect(object.toString(), contains('MyName'));
    });

    test('debugCreationStack', () {
      DebugCreationStack.enable = true;
      addTearDown(() => DebugCreationStack.enable = false);
      final object = Atom();
      expect(object.debugCreationStack, isNotNull);
    });

    test('isBeingObserved', () {
      final observable = Observable(1, name: 'MyName');
      expect(observable.isBeingObserved, false);
      final d = autorun((_) => observable.value);
      expect(observable.isBeingObserved, true);
      d();
    });
  });
}
