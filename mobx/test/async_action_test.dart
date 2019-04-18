import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

Future sleep(int ms) => Future.delayed(Duration(milliseconds: ms));

void main() {
  setUp(() {
    mainContext.config = ReactiveConfig(enforceActions: EnforceActions.always);
  });

  tearDown(() {
    mainContext.config = ReactiveConfig.main;
  });

  group('AsyncAction', () {
    test('null name throws', () {
      expect(() => AsyncAction(null), throwsA(anything));
    });

    test('run allows updating observable values in an async function',
        () async {
      final action = AsyncAction('testAction');

      final counter = Observable<int>(0);

      final values = <int>[];
      autorun((_) {
        values.add(counter.value);
      });

      await action.run(() async {
        await sleep(10);
        counter
          ..value = 1
          ..value = 2;
        await sleep(10);
        counter.value = 3;
      });

      expect(counter.value, equals(3));
      expect(values, equals([0, 2, 3]));
    });

    test('run allows updating observable values in a Future returning function',
        () async {
      final action = AsyncAction('testAction');

      final counter = Observable<int>(0);

      final values = <int>[];
      autorun((_) {
        values.add(counter.value);
      });

      await action.run(() => sleep(10)
          .then((_) {
            counter
              ..value = 1
              ..value = 2;
          })
          .then((_) => sleep(10))
          .then((_) => counter.value = 3));

      expect(counter.value, equals(3));
      expect(values, equals([0, 2, 3]));
    });

    test('nested runs with different actions work', () async {
      final action1 = AsyncAction('testAction1');
      final action2 = AsyncAction('testAction2');

      final counter1 = Observable<int>(0);
      final counter2 = Observable<int>(0);

      Future run2() async {
        counter2.value++;
        await sleep(10);
        counter2.value++;
        counter2.value++;
      }

      Future run1() async {
        counter1.value++;
        await action2.run(run2);
        counter1.value++;
        await action2.run(run2);
        counter1.value++;
      }

      final values1 = <int>[];
      autorun((_) {
        values1.add(counter1.value);
      });

      final values2 = <int>[];
      autorun((_) {
        values2.add(counter2.value);
      });

      await action1.run(run1);

      expect(counter1.value, equals(3));
      expect(values1, equals([0, 1, 2, 3]));

      expect(counter2.value, equals(6));
      expect(values2, equals([0, 1, 3, 4, 6]));
    });
  });
}
