import 'package:mobx/mobx.dart';

/// The `Store` mixin is primarily meant for code-generation and used as part of the
/// `mobx_codegen` package.
///
/// A class using this mixin is considered a MobX store and `mobx_codegen`
/// weaves the code needed to simplify the usage of MobX. It will detect annotations like
/// `@observables`, `@computed` and `@action` and generate the code needed to support these behaviors.
mixin Store {
  /// Override this method to use a custom context.
  ReactiveContext get context => mainContext;
}
