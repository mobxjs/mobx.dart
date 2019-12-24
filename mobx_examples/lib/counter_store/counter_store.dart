import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
part 'counter_store.g.dart';

class CounterStore = _CounterStore with _$CounterStore;

abstract class _CounterStore extends MobxBase with Store {
  _CounterStore() : _counter = 0;
  @observable
  String _text;

  String get text => _text;

  @observable
  int _counter;
  int get counter => _counter;
  @action
  void increament() {
    _counter++;
  }

  @action
  void decreament() {
    _counter--;
  }

  @action
  Future successAsyncCall() async {
    toLoadingState();
    await Future.delayed(const Duration(seconds: 3));
    _text = 'async call is finished successfully';
    toSuccessState();
  }

  @action
  Future errorAsyncCall() async {
    toLoadingState();
    await Future.delayed(const Duration(seconds: 3));
    _text = 'async call is finished with error';
    toErrorState();
  }

  @override
  void dispose() {}
}
