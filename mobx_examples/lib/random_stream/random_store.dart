import 'dart:async';
import 'dart:math';

import 'package:mobx/mobx.dart';

class RandomStore with Store {
  RandomStore() {
    _streamController = StreamController<int>();

    _timer = Timer.periodic(const Duration(seconds: 1),
        (_) => _streamController.add(_random.nextInt(100)));

    randomStream = ObservableStream(_streamController.stream);
  }

  Timer _timer;

  final _random = Random();

  StreamController<int> _streamController;

  ObservableStream<int> randomStream;

  // ignore: avoid_void_async
  void dispose() async {
    _timer.cancel();
    await _streamController.close();
  }
}
