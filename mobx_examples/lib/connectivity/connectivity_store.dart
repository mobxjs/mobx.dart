import 'package:connectivity/connectivity.dart';
import 'package:mobx/mobx.dart';

part 'connectivity_store.g.dart';

class ConnectivityStore = _ConnectivityStore with _$ConnectivityStore;

abstract class _ConnectivityStore with Store {
  _ConnectivityStore() {
    connectivityStream = ObservableStream<ConnectivityResult>(
        Connectivity().onConnectivityChanged);
  }

  @observable
  ObservableStream<ConnectivityResult> connectivityStream;

  void dispose() {}
}
