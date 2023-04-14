import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/src/reaction_builder.dart';
import 'package:provider/provider.dart';

/// {@template multi_reaction_builder}
/// Merges multiple [ReactionBuilder] widgets into one widget tree.
///
/// [MultiReactionBuilder] improves the readability and eliminates the need
/// to nest multiple [ReactionBuilder]s.
///
/// By using [MultiReactionBuilder] we can go from:
///
/// ```dart
/// ReactionBuilder(
///   builder: (context) {},
///   child: ReactionBuilder(
///     builder: (context) {},
///     child: ReactionBuilder(
///       builder: (context) {},
///       child: ChildA(),
///     ),
///   ),
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiReactionBuilder(
///   builders: [
///     ReactionBuilder(
///       builder: (context) {},
///     ),
///     ReactionBuilder(
///       builder: (context) {},
///     ),
///     ReactionBuilder(
///       builder: (context) {},
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiReactionBuilder] converts the [ReactionBuilder] list into a tree of nested
/// [ReactionBuilder] widgets.
/// As a result, the only advantage of using [MultiReactionBuilder] is improved
/// readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiReactionBuilder extends MultiProvider {
  /// {@macro multi_reaction_builder}
  MultiReactionBuilder({
    Key? key,
    required List<ReactionBuilder> builders,
    required Widget child,
  }) : super(key: key, providers: builders, child: child);
}
