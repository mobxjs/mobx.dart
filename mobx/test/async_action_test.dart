import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

Future sleep(int ms) => Future.delayed(Duration(milliseconds: ms));

void main() {
  testSetup();

  setUp(() {
    mainContext.config =
        ReactiveConfig(writePolicy: ReactiveWritePolicy.always);
  });

  tearDown(() {
    mainContext.config = ReactiveConfig.main;
  });

  group('AsyncAction', () {
    test(
        'run allows updating observable values in an async function (with flag `AsyncActionBehavior.notifyEachNested`)',
        () async {
      final lastConfig = mainContext.config;

      mainContext.config = mainContext.config.clone(
        asyncActionBehavior: AsyncActionBehavior.notifyEachNested,
      );

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

      mainContext.config = lastConfig;
    });

    test(
        'run allows updating only last observable value in an async function (with flag `AsyncActionBehavior.notifyOnlyLast`)',
        () async {
      final lastConfig = mainContext.config;

      mainContext.config = mainContext.config.clone(
        asyncActionBehavior: AsyncActionBehavior.notifyOnlyLast,
      );

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
      expect(values, equals([0, 3]));

      mainContext.config = lastConfig;
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
