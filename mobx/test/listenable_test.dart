import 'package:mobx/mobx.dart';
import 'package:mobx/src/listenable.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';

void main() {
  group('Listenable', () {
    test('dispose function removes added listener', () {
      void listener(ChangeNotification<int> change) {}

      final listeners = Listeners<int>(currentContext);
      expect(listeners.hasListeners, isFalse);

      final dispose = listeners.registerListener(listener);
      expect(listeners.hasListeners, isTrue);

      dispose();
      expect(listeners.hasListeners, isFalse);
    });

    test('uses provided context', () {
      final context = MockContext();
      Listeners(context)
        ..registerListener((_) {})
        ..notifyListeners(ChangeNotification());
      verify(context.untracked(any));
    });
  });
}
