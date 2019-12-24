import 'package:mobx/mobx.dart';
part 'mobx_base.g.dart';

//indicates the state of the store (view model)
enum StoreState { loading, succuess, error, idle }

///this class is the base class you should inheret from when creating your [stores (viewmodels)]
///it contains some helper functions for changing the state of the [stores (viewmodels)]
abstract class MobxBase = _MobxBase with _$MobxBase;

abstract class _MobxBase with Store {
  _MobxBase() : _state = StoreState.idle;
  @observable
  StoreState _state;
  @computed
  StoreState get state => _state;

  bool get isLoading => _state == StoreState.loading;
  bool get isError => _state == StoreState.error;
  bool get isSucceeded => _state == StoreState.succuess;
  bool get isIdle => _state == StoreState.idle;

  @action
  void changeState(StoreState state) => _state = state;
  @action
  void toLoadingState() => _state = StoreState.loading;
  @action
  void toErrorState() => _state = StoreState.error;
  @action
  void toSuccessState() => _state = StoreState.succuess;

  void dispose();
}
