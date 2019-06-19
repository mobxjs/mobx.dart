import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  group('when reactive-reads are enforced', () {
    Observable<int> x;

    setUp(() {
      mainContext.config =
          ReactiveConfig.main.clone(readPolicy: ReactiveReadPolicy.always);

      x = Observable(0);
    });

    test('should throw when reads happen OUTSIDE actions or reactions', () {
      expect(() {
        final xValue = x.value;
      }, throwsA(const TypeMatcher<MobXException>()));
    });

    test('should NOT throw when reads happen INSIDE reactions', () {
      expect(() {
        final d = autorun((_) {
          final xValue = x.value;
        });

        d();
      }, returnsNormally);
    });

    test('should NOT throw when reads happen INSIDE actions', () {
      expect(() {
        runInAction(() {
          final xValue = x.value;
        });
      }, returnsNormally);
    });
  });

  group('when reactive-reads are NOT enforced', () {
    Observable<int> x;

    setUp(() {
      mainContext.config =
          ReactiveConfig.main.clone(readPolicy: ReactiveReadPolicy.never);

      x = Observable(0);
    });

    test('should NOT throw when reads happen OUTSIDE actions or reactions', () {
      expect(() {
        final xValue = x.value;
      }, returnsNormally);
    });

    test('should NOT throw when reads happen INSIDE reactions', () {
      expect(() {
        final d = autorun((_) {
          final xValue = x.value;
        });

        d();
      }, returnsNormally);
    });

    test('should NOT throw when reads happen INSIDE actions', () {
      expect(() {
        runInAction(() {
          final xValue = x.value;
        });
      }, returnsNormally);
    });
  });
}
