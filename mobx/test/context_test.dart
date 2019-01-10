import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

main() {
  group('ReactiveContext', () {
    test('comes with default config', () {
      final ctx = ReactiveContext();

      expect(ctx.config, equals(ReactiveConfig.main));
    });
  });
}
