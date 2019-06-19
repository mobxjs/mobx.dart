import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void turnOffWritePolicy() {
  setUp(() => mainContext.config =
      ReactiveConfig(writePolicy: ReactiveWritePolicy.never));

  tearDown(() => mainContext.config = ReactiveConfig.main);
}
