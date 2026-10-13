import '../reactive_framework.dart';
import '../utils/dep_graph.dart';
import 'utils.dart';

KairoState Function() diamond(ReactiveFramework framework) {
  const width = 5;

  return framework.withBuild(() {
    final head = framework.signal(0);
    final current = <Computed<int>>[];
    for (int i = 0; i < width; i++) {
      current.add(framework.computed(() => head.read() + 1));
    }

    final sum = framework.computed(() {
      return current.fold(0, (prev, x) => prev + x.read());
    });

    final callCounter = Counter();
    framework.effect(() {
      sum.read();
      callCounter.count++;
    });

    return () {
      KairoState state = KairoState.success;
      framework.withBatch(() {
        head.write(1);
      });
      if (sum.read() != 2 * width) {
        state = KairoState.fail;
      }

      callCounter.count = 0;
      for (int i = 0; i < 500; i++) {
        framework.withBatch(() {
          head.write(i);
        });
        assert(sum.read() == (i + 1) * width);
        if (sum.read() != (i + 1) * width) {
          state = KairoState.fail;
        }
      }

      if (callCounter.count != 500) {
        return KairoState.fail;
      }

      return state;
    };
  });
}
