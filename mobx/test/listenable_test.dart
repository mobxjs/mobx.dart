import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

void main() {
  testSetup();

  group('Listenable', () {
    test('dispose function removes added listener', () {
      void listener(ChangeNotification<int> change) {}

      final listeners = Listeners<ChangeNotification<int>>(mainContext);
      expect(listeners.hasHandlers, isFalse);

      final dispose = listeners.add(listener);
      expect(listeners.hasHandlers, isTrue);

      dispose();
      expect(listeners.hasHandlers, isFalse);
    });

    test('uses provided context', () {
      final context = MockContext();
      Listeners(context)
        ..add((_) {})
        ..notifyListeners(ChangeNotification());
      verify(context.untracked(any));
    });

    test('asserts for null notifications', () {
      final handlers = Listeners(MockContext())
        // ignore: missing_return
        ..add((_) {});

      expect(() {
        handlers.notifyListeners(null);
      }, throwsA(const TypeMatcher<AssertionError>()));
    });
  });
}
