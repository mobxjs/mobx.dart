import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/connectivity/connectivity_store.dart';

class ConnectivityExample extends StatefulWidget {
  const ConnectivityExample(this.store, {Key? key}) : super(key: key);

  final ConnectivityStore store;

  @override
  _ConnectivityExampleState createState() => _ConnectivityExampleState();
}

class _ConnectivityExampleState extends State<ConnectivityExample> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  ReactionDisposer? _disposer;

  @override
  void initState() {
    super.initState();
    // a delay is used to avoid showing the snackbar too much when the connection drops in and out repeatedly
    _disposer = reaction(
        (_) => widget.store.connectivityStream.value,
        (result) => _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
            content: Text(result == ConnectivityResult.none
                ? 'You\'re offline'
                : 'You\'re online'))),
        delay: 4000);
  }

  @override
  void dispose() {
    _disposer!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'Turn your connection on/off for approximately 4 seconds to see the app respond to changes in your connection status.'),
          ),
        ),
      );
}
