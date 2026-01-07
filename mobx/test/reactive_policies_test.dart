import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  group('when reactive-reads are enforced', () {
    setUp(() {
      mainContext.config = ReactiveConfig.main.clone(
        readPolicy: ReactiveReadPolicy.always,
      );
    });

    test('should throw when reads happen OUTSIDE actions or reactions', () {
      expect(doAllReads, throwsA(const TypeMatcher<AssertionError>()));
    });

    test('should NOT throw when reads happen INSIDE reactions', () {
      expect(() {
        final d = autorun((_) {
          doAllReads();
        });

        d();
      }, returnsNormally);
    });

    test('should NOT throw when reads happen INSIDE actions', () {
      expect(() {
        runInAction(doAllReads);
      }, returnsNormally);
    });
  });

  group('when reactive-reads are NOT enforced', () {
    setUp(() {
      mainContext.config = ReactiveConfig.main.clone(
        readPolicy: ReactiveReadPolicy.never,
      );
    });

    test('should NOT throw when reads happen OUTSIDE actions or reactions', () {
      expect(doAllReads, returnsNormally);
    });

    test('should NOT throw when reads happen INSIDE reactions', () {
      expect(() {
        final d = autorun((_) {
          doAllReads();
        });

        d();
      }, returnsNormally);
    });

    test('should NOT throw when reads happen INSIDE actions', () {
      expect(() {
        runInAction(doAllReads);
      }, returnsNormally);
    });
  });
}

void doAllReads() {
  doObservableReads();
  doObservableListReads();
  doObservableMapReads();
  doObservableSetReads();
}

void doObservableReads() {
  final x = Observable(0);
  // ignore: cascade_invocations
  x.value;
}

void doObservableListReads() {
  final list = ObservableList.of([1]);

  // ignore: unnecessary_statements
  list[0];
  list.length;
  // ignore: cascade_invocations
  list.single;
  // ignore: cascade_invocations
  list.lastWhere((_) => true);
  // ignore: cascade_invocations
  list.last;
  // ignore: cascade_invocations
  list.first;
  // ignore: cascade_invocations
  list.lastIndexWhere((_) => true);
  // ignore: cascade_invocations
  list.iterator;
  // ignore: cascade_invocations
  list.sublist(0);
  // ignore: cascade_invocations
  list.toList();
  // ignore: cascade_invocations, unnecessary_statements
  list + [4];
}

void doObservableSetReads() {
  final set = ObservableSet.of([1]);

  // ignore: cascade_invocations
  set.length;
  // ignore: cascade_invocations, unnecessary_statements
  set.single;
  // ignore: cascade_invocations
  set.lastWhere((_) => true);
  // ignore: cascade_invocations
  set.last;
  // ignore: cascade_invocations
  set.first;
  // ignore: cascade_invocations
  set.iterator;
  // ignore: cascade_invocations
  set.toList();
}

void doObservableMapReads() {
  final map = ObservableMap.of({'a': 1, 'b': 2, 'c': 3});

  // ignore: unnecessary_statements
  map['a'];
  // ignore: cascade_invocations
  map.length;
  // ignore: cascade_invocations
  map.isNotEmpty;
  // ignore: cascade_invocations
  map.isEmpty;
  // ignore: cascade_invocations
  map.containsKey('a');
  // ignore: cascade_invocations
  map.containsValue(1);
}
