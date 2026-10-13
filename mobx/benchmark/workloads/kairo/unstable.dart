import '../reactive_framework.dart';
import '../utils/dep_graph.dart';
import 'utils.dart';

KairoState Function() unstable(ReactiveFramework framework) {
  return framework.withBuild(() {
    final head = framework.signal(0);
    final double = framework.computed(() => head.read() * 2);
    final inverse = framework.computed(() => -head.read());
    final current = framework.computed(() {
      var result = 0;
      for (int i = 0; i < 20; i++) {
        result += head.read() % 2 == 1 ? double.read() : inverse.read();
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
          current.read() == 40 ? KairoState.success : KairoState.fail;
      callCounter.count = 0;

      for (int i = 0; i < 100; i++) {
        framework.withBatch(() {
          head.write(i);
        });

        if (current.read() != (i % 2 == 1 ? i * 2 : -i) * 20) {
          return KairoState.fail;
        }
      }

      if (callCounter.count != 100) {
        return KairoState.fail;
      }

      return state;
    };
  });
}
