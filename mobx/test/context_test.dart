import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  group('ReactiveContext', () {
    test('comes with default config', () {
      final ctx = ReactiveContext();

      expect(ctx.config, equals(ReactiveConfig.main));
    });

    test('global onReactionError is invoked for reaction errors', () {
      var caught = false;

      final dispose = mainContext.onReactionError((_) => caught = true);
      final dispose1 = autorun((_) => throw Exception('autorun FAIL'));

      expect(caught, isTrue);

      dispose();
      dispose1();
    });
  });
}
