import '../reactive_framework.dart';
import 'utils.dart';

KairoState Function() mux(ReactiveFramework framework) {
  return framework.withBuild(() {
    final heads = List.generate(100, (_) => framework.signal(0));
    final mux = framework.computed(() {
      return Map.fromEntries(
        heads.map((h) => h.read()).toList().asMap().entries,
      );
    });

    final splited =
        heads
            .asMap()
            .entries
            .map((e) => framework.computed(() => mux.read()[e.key]!))
            .map((x) => framework.computed(() => x.read() + 1))
            .toList();

    int sum = 0;
    for (final x in splited) {
      framework.effect(() => sum += x.read());
    }

    return () {
      KairoState state = KairoState.success;
      sum = 0;

      for (int i = 0; i < 10; i++) {
        framework.withBatch(() {
          heads[i].write(i);
        });
        if (splited[i].read() != i + 1) {
          state = KairoState.fail;
        }
      }

      state = sum != 54 ? KairoState.fail : state;
      sum = 0;

      for (int i = 0; i < 10; i++) {
        framework.withBatch(() {
          heads[i].write(i * 2);
        });

        if (splited[i].read() != i * 2 + 1) {
          state = KairoState.fail;
        }
      }

      if (sum != 99) {
        return KairoState.fail;
      }

      return state;
    };
  });
}
