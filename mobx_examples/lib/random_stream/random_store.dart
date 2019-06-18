import 'dart:math';

import 'package:mobx/mobx.dart';

part 'random_store.g.dart';

class RandomStore = _RandomStore with _$RandomStore;

abstract class _RandomStore with Store {
  _RandomStore() {
    _stream = Stream<int>.periodic(Duration(seconds: 1))
        .map((x) => _random.nextInt(100));

    randomStream = ObservableStream(_stream, initialValue: 0);
  }

  final _random = Random();

  Stream<int> _stream;

  ObservableStream<int> randomStream;
}
