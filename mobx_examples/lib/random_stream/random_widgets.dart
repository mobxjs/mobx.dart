import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:mobx_examples/random_stream/random_store.dart';

class RandomNumberExample extends StatefulWidget {
  const RandomNumberExample();

  @override
  _RandomNumberExampleState createState() => _RandomNumberExampleState();
}

class _RandomNumberExampleState extends State<RandomNumberExample> {
  final RandomStore store = RandomStore();

  @override
  Widget build(BuildContext context) => Scaffold(
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
            Observer(
              builder: (_) {
                final value = store.randomStream.value;

                return Text(
                  '${value == null ? '---' : value}',
                  style: const TextStyle(fontSize: 96),
                );
              },
            ),
          ],
        ),
      ));

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }
}
