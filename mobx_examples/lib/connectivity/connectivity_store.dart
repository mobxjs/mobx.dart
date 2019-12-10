import 'package:mobx/mobx.dart';
import 'package:connectivity/connectivity.dart';

part 'connectivity_store.g.dart';

class ConnectivityStore = _ConnectivityStore with _$ConnectivityStore;

abstract class _ConnectivityStore with Store {
  _ConnectivityStore() {
    connectivityStream = ObservableStream<ConnectivityResult>(
        Connectivity().onConnectivityChanged);
  }

  @observable
  ObservableStream<ConnectivityResult> connectivityStream;
}
