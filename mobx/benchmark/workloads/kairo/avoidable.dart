import '../reactive_framework.dart';
import '../utils/dep_graph.dart';
import 'utils.dart';

KairoState Function() avoidablePropagation(ReactiveFramework f) {
  final head = f.signal(0);
  final c1 = f.computed(() => head.read());
  final c2 = f.computed(() {
    c1.read();
    return 0;
  });
  final c3 = f.computed(() {
    busy();
    return c2.read() + 1;
  });
  final c4 = f.computed(() => c3.read() + 2);
  final c5 = f.computed(() => c4.read() + 3);

  final counter = Counter();
  f.effect(() {
    counter.count++;
    c5.read();
    busy();
  });

  return () {
    KairoState state = KairoState.success;
    f.withBatch(() => head.write(1));
    if (c5.read() != 6) {
      state = KairoState.fail;
    }

    for (int i = 0; i < 1000; i++) {
      f.withBatch(() => head.write(i));
      if (c5.read() != 6) {
        state = KairoState.fail;
      }
    }

    if (counter.count != 1) {
      return KairoState.fail;
    }

    return state;
  };
}
