import 'package:mobx/mobx.dart';

part 'hitimer_stores.g.dart';

/////////// Exercise ////////////////
class Exercise = _Exercise with _$Exercise;

abstract class _Exercise implements Store {
  _Exercise({this.name, this.description, this.seconds});

  @observable
  String name;

  @observable
  String description;

  @observable
  int seconds;
}

/////////// Routine //////////////
class Routine = _Routine with _$Routine;

abstract class _Routine implements Store {
  @observable
  String name;

  @observable
  String description;

  @observable
  int exerciseRestingSeconds;

  @observable
  int repetitionRestingSeconds;

  final ObservableList<Exercise> exercises = ObservableList<Exercise>();
}

class Workout = _Workout with _$Workout;

abstract class _Workout implements Store {}
