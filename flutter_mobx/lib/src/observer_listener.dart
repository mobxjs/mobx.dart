import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart' show ReactionImpl;

class ObserverListener extends StatefulWidget {
  final Widget child;
  final String name;
  final void Function(Reaction) listener;

  const ObserverListener(
      {Key key, @required this.child, @required this.listener, this.name})
      : super(key: key);

  @override
  _ObserverListenerState createState() => _ObserverListenerState();
}

class _ObserverListenerState extends State<ObserverListener> {
  ReactionDisposer _reactionDisposerForListener;

  ReactionImpl get reactionListener =>
      _reactionDisposerForListener.reaction as ReactionImpl;

  @override
  void dispose() {
    _reactionDisposerForListener();
    super.dispose();
  }

  _initAutorun() async {
    if (_reactionDisposerForListener != null) {
      _reactionDisposerForListener();
    }
    _reactionDisposerForListener = autorun(widget.listener,
        delay: 300, name: widget.name ?? 'ObserverListener');
    await Future.delayed(Duration(milliseconds: 301));

    if (!reactionListener.hasObservables) {
      debugPrint(
        'No observables detected in the listener method of ${reactionListener.name}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initAutorun();
    return widget.child;
  }
}
