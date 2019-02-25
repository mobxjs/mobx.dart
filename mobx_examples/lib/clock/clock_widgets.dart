import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/clock/clock.dart';

class ClockExample extends StatefulWidget {
  const ClockExample();

  @override
  State<StatefulWidget> createState() => _ClockState();
}

class _ClockState extends State<ClockExample> {
  final Clock clock = Clock();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
      ),
      body: Center(
        child: Observer(builder: (_) {
          // The simple dereferencing of clock.now is enough to keep triggering it every second
          final time = clock.now;
          final formattedTime = [time.hour, time.minute, time.second].join(':');

          return Text(formattedTime,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ));
        }),
      ));
}
