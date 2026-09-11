import 'dart:async';
import 'dart:math' as math;
import 'package:mobx/mobx.dart';

// #region cart
class CartStore {
  final quantity = Observable(1);
  late final total = Computed(() => quantity.value * 24);
  late final shippingRemaining = Computed(() => math.max(0, 72 - total.value));
  void change(int delta) =>
      runInAction(() => quantity.value = (quantity.value + delta).clamp(0, 99));
}

// #endregion cart

// #region tasks
class TaskStore {
  final tasks = [
    'Design the first screen',
    'Connect the data',
    'Ship something lovely',
  ];
  final completed = ObservableSet<String>.of({'Design the first screen'});
  final onlyPending = Observable(false);
  late final visible = Computed(
    () => tasks
        .where((t) => !onlyPending.value || !completed.contains(t))
        .toList(),
  );
  late final remaining = Computed(() => tasks.length - completed.length);
  void toggle(String task) {
    if (!tasks.contains(task)) return;
    runInAction(
      () => completed.contains(task)
          ? completed.remove(task)
          : completed.add(task),
    );
  }

  void filter(bool value) => runInAction(() => onlyPending.value = value);
}

// #endregion tasks

// #region async
class ProjectsStore {
  final request = Observable<ObservableFuture<List<String>>?>(null);
  final fail = Observable(false);
  Timer? _timer;
  void load({Duration delay = const Duration(milliseconds: 900)}) {
    if (request.value?.status == FutureStatus.pending) return;
    final result = Completer<List<String>>();
    final shouldFail = fail.value;
    runInAction(() => request.value = ObservableFuture(result.future));
    _timer = Timer(
      delay,
      () => shouldFail
          ? result.completeError(StateError('Try again'))
          : result.complete([
              'The little bookshop',
              'Weekend adventures',
              'Something new',
            ]),
    );
  }

  void setFailure(bool value) => runInAction(() => fail.value = value);
  void cancel() {
    _timer?.cancel();
    _timer = null;
    runInAction(() => request.value = null);
  }
}

// #endregion async

class DemoStores {
  final cart = CartStore();
  final tasks = TaskStore();
  final projects = ProjectsStore();
  void reset(String route) => runInAction(() {
    if (route == '/cart') cart.quantity.value = 1;
    if (route == '/tasks') {
      tasks.completed
        ..clear()
        ..add(tasks.tasks.first);
      tasks.onlyPending.value = false;
    }
  });
  void dispose() => projects.cancel();
}
