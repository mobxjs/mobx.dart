import 'package:connectivity/connectivity.dart';
import 'package:mobx/mobx.dart';

class ConnectivityStore with Store {
  ConnectivityStore() {
    connectivityStream = ObservableStream<ConnectivityResult>(
        Connectivity().onConnectivityChanged);
  }

  @observable
  ObservableStream<ConnectivityResult> connectivityStream;

  void dispose() {}
}
