import '../reactive_framework.dart';
import '../utils/dep_graph.dart';
import 'utils.dart';

KairoState Function() repeatedObservers(ReactiveFramework framework) {
  const size = 30;

  return framework.withBuild(() {
    final head = framework.signal(0);
    final current = framework.computed(() {
      int result = 0;
      for (int i = 0; i < size; i++) {
        result += head.read();
      }
      return result;
    });

    final callCounter = Counter();
    framework.effect(() {
      current.read();
      callCounter.count++;
    });

    return () {
      framework.withBatch(() {
        head.write(1);
      });

      KairoState state =
          current.read() == size ? KairoState.success : KairoState.fail;

      callCounter.count = 0;
      for (int i = 0; i < 100; i++) {
        framework.withBatch(() {
          head.write(i);
        });

        if (current.read() != i * size) {
          state = KairoState.fail;
        }
      }

      if (callCounter.count != 100) {
        return KairoState.fail;
      }

      return state;
    };
  });
}
