import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void turnOffWritePolicy() {
  setUp(() => mainContext.config =
      ReactiveConfig(writePolicy: ReactiveWritePolicy.never));

  tearDown(() => mainContext.config = ReactiveConfig.main);
}

// Without invoking this setup, errors in reactions, *including expectation failures*, are ignored.
void throwReactionErrors() {
  Dispose disposeReactionError;

  setUp(() => disposeReactionError = mainContext.onReactionError((_, rxn) {
    throw Exception(rxn.errorValue);
  }));

  tearDown(() => disposeReactionError());
}
