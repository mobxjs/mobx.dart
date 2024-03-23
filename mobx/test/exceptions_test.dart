import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  testSetup();

  test('MobXException has the right toString()', () {
    final ex = MobXException('Test Exception');

    expect(ex.toString(), equals('Test Exception'));
  });

  test('MobXCyclicReactionException has the right toString()', () {
    final ex = MobXCyclicReactionException('Test Exception');

    expect(ex.toString(), equals('Test Exception'));
  });

  test('MobXCaughtException contains the stacktrace', () {
    try {
      throw Exception('test');
    } on Object catch (e, s) {
      final ex = MobXCaughtException(e, stackTrace: s);
      expect(ex.stackTrace, isNotNull);
    }
  });

  test('should preserve stacktrace', () async {
    late StackTrace stackTrace;
    try {
      Computed(() {
        try {
          throw Exception();
        } on Exception catch (e, st) {
          stackTrace = st;
          rethrow;
        }
      }).value;
    } on MobXCaughtException catch (e, st) {
      expect(st, stackTrace);
      expect(st, e.stackTrace);
    }
  });
}
