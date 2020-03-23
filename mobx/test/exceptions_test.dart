import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
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
}
