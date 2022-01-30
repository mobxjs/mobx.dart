import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/connectivity/connectivity_store.dart';

class ConnectivityExample extends StatelessWidget {
  const ConnectivityExample(this.store, {Key? key}) : super(key: key);

  final ConnectivityStore store;

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        child: ReactionBuilder(
            builder: (context) {
              return reaction((_) => store.connectivityStream.value, (result) {
                final messenger = ScaffoldMessenger.of(context);

                messenger.showSnackBar(SnackBar(
                    content: Text(result == ConnectivityResult.none
                        ? 'You\'re offline'
                        : 'You\'re online')));
              }, delay: 4000);
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Settings'),
              ),
              body: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    'Turn your connection on/off for approximately 4 seconds to see the app respond to changes in your connection status.'),
              ),
            )),
      );
}
