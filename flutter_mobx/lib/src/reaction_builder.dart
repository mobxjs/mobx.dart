import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

/// A builder function that creates a reaction
typedef ReactionBuilderFunction = ReactionDisposer Function(
    BuildContext context);

/// ReactionBuilder is useful for triggering reactions via a builder function rather
/// than creating a custom StatefulWidget for handling the same.
/// Without a [ReactionBuilder] you would normally have to create a StatefulWidget
/// where the `initState()` would be used to setup the reaction and then dispose it off
/// in the `dispose()` method.
///
/// Although simple, this little helper Widget eliminates the need to create such a
/// widget and handles the lifetime of the reaction correctly. To use it, pass a
/// [builder] that takes in a [BuildContext] and prepares the reaction. It should
/// end up returning a [ReactionDisposer]. This will be disposed when the [ReactionBuilder]
/// is disposed. The [child] Widget gets rendered as part of the build process.
class ReactionBuilder extends StatefulWidget {
  final ReactionBuilderFunction builder;
  final Widget child;

  const ReactionBuilder({Key? key, required this.child, required this.builder})
      : super(key: key);

  @override
  ReactionBuilderState createState() => ReactionBuilderState();
}

@visibleForTesting
class ReactionBuilderState extends State<ReactionBuilder> {
  late ReactionDisposer _disposeReaction;

  bool get isDisposed => _disposeReaction.reaction.isDisposed;

  @override
  void initState() {
    super.initState();

    _disposeReaction = widget.builder(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _disposeReaction();
    super.dispose();
  }
}
