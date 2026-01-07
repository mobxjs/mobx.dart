import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

/// Run boilerplate test setups, with options.
///
/// [throwReactionErrors] is true by default, meaning that you will see errors in reactions,
/// including failed expectations. You may need to turn this off to test other error handlers for
/// reactions, as any added after this call won't be used, since the handlers are evaluated in
/// order and the error will already have been rethrown.
/// If you choose to set [throwReactionErrors] to false, failed expectations in observers will
/// appear to pass!
///
/// [turnOffWritePolicy] is true by default.
void testSetup({
  bool throwReactionErrors = true,
  bool turnOffWritePolicy = true,
}) {
  if (throwReactionErrors) {
    setupThrowReactionErrors();
  }

  if (turnOffWritePolicy) {
    setupTurnOffWritePolicy();
  }
}

void setupTurnOffWritePolicy() {
  setUp(
    () =>
        mainContext.config = ReactiveConfig(
          writePolicy: ReactiveWritePolicy.never,
        ),
  );

  tearDown(() => mainContext.config = ReactiveConfig.main);
}

// Without invoking this setup, errors in reactions, *including expectation failures*, are ignored.
void setupThrowReactionErrors() {
  late Dispose disposeReactionError;

  setUp(
    () =>
        disposeReactionError = mainContext.onReactionError((_, rxn) {
          throw Exception(rxn.errorValue);
        }),
  );

  tearDown(() => disposeReactionError());
}
