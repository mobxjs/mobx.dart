import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void turnOffEnforceActions() {
  setUp(() => mainContext.config =
      ReactiveConfig(enforceActions: EnforceActions.never));

  tearDown(() => mainContext.config = ReactiveConfig.main);
}
