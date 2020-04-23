import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'shared_mocks.dart';
import 'util.dart';

void main() {
  testSetup();

  group('observable<T>', () {
    test('basics work', () {
      final x = Observable<int>(null);
      expect(x.value, equals(null));

      x.value = 100;
      expect(x.value, equals(100));

      expect(x.name, startsWith('Observable@'));

      final str = Observable('hello', name: 'greeting');
      expect(str is Observable<String>, isTrue);
      expect(str.value, equals('hello'));
      expect(str.name, equals('greeting'));

      str.value = 'mobx';
      expect(str.value, equals('mobx'));
    });

    test('works with current context', () {
      final x = Observable(1000, context: mainContext);
      expect(x is Observable<int>, isTrue);

      expect(x.value, equals(1000));

      final x1 = Observable<int>(null, context: mainContext);
      expect(x1.value, isNull);

      final y = Observable('Hello', name: 'greeting', context: mainContext);
      expect(y.value, equals('Hello'));
      expect(y.name, equals('greeting'));
    });

    test('uses provided context', () {
      final context = MockContext();
      final value = Observable(0, context: context)..value += 1;

      verify(context.startBatch());
      verify(context.propagateChanged(value));
      verify(context.endBatch());
    });
  });

  group('createAtom()', () {
    test('basics works', () {
      var executionCount = 0;
      final a = Atom(
          name: 'test',
          onObserved: () {
            executionCount++;
          },
          onUnobserved: () {
            executionCount++;
          });

      final d = autorun((_) {
        a.reportObserved();
      });

      expect(executionCount, equals(1)); // onBecomeObserved gets called

      d();
      expect(executionCount, equals(2)); // onBecomeUnobserved gets called
    });

    test('provides a default name', () {
      final a = Atom();

      expect(a.name, startsWith('Atom@'));
    });
  });
}
