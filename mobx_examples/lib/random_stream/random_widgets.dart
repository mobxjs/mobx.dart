import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/random_stream/random_store.dart';
import 'package:provider/provider.dart';

class RandomNumberExample extends StatelessWidget {
  const RandomNumberExample();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<RandomStore>(context);

    return Observer(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Random Number Generator'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Random number',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${store.randomStream.value}',
                      style: TextStyle(fontSize: 96),
                    ),
                  ],
                ),
              ),
            ));
  }
}
