import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';

void main() {
  group('Listenable', () {
    test('dispose function removes added listener', () {
      void listener(ChangeNotification<int> change) {}

      final listeners = Listeners<ChangeNotification<int>>(mainContext);
      expect(listeners.hasHandlers, isFalse);

      final dispose = listeners.registerListener(listener);
      expect(listeners.hasHandlers, isTrue);

      dispose();
      expect(listeners.hasHandlers, isFalse);
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
