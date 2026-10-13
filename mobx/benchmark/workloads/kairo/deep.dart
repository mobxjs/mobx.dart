import '../reactive_framework.dart';
import '../utils/dep_graph.dart';
import 'utils.dart';

KairoState Function() deepPropagation(ReactiveFramework framework) {
  const len = 50;

  return framework.withBuild(() {
    final head = framework.signal(0);
    var current = head as ISignal<int>;

    for (int i = 0; i < len; i++) {
      final c = current;
      current = framework.computed(() => c.read() + 1);
    }

    final callCounter = Counter();
    framework.effect(() {
      current.read();
      callCounter.count++;
    });

    const iter = 50;
    return () {
      framework.withBatch(() {
        head.write(1);
      });

      KairoState state = KairoState.success;

      callCounter.count = 0;
      for (int i = 0; i < iter; i++) {
        framework.withBatch(() {
          head.write(i);
        });
        if (current.read() != len + i) {
          state = KairoState.fail;
        }
      }

      if (callCounter.count != iter) {
        return KairoState.fail;
      }

      return state;
    };
  });
}
