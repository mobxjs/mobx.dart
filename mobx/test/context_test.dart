import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  group('ReactiveContext', () {
    test('comes with default config', () {
      final ctx = ReactiveContext();

      expect(ctx.config, equals(ReactiveConfig.main));
    });

    test('global onReactionError is invoked for reaction errors', () {});
  });
}
