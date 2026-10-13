import 'package:mobx/mobx.dart';

const tasks = ['Design', 'Connect', 'Ship'];

// #region snippet
final done = ObservableSet<String>();
final onlyPending = Observable(false);
final visible = Computed(
  () => tasks
      .where((task) => !onlyPending.value || !done.contains(task))
      .toList(),
);

void complete(String task) => runInAction(() => done.add(task));
// #endregion snippet
