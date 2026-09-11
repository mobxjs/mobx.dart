import 'dart:math';
import '../framework_type.dart';
import '../reactive_framework.dart';

class Graph {
  const Graph({required this.sources, required this.layers});

  final List<Signal<int>> sources;
  final List<List<Computed<int>>> layers;
}

class Counter {
  int count = 0;
}

Graph makeGraph(
  ReactiveFramework framework,
  TestConfig config,
  Counter counter,
) {
  final TestConfig(:width, :totalLayers, :staticFraction, :nSources) = config;

  return framework.withBuild(() {
    final sources = List.generate(width, (i) => framework.signal(i));
    final rows = _makeDependentRows(
      sources,
      totalLayers - 1,
      counter,
      staticFraction,
      nSources,
      framework,
    );

    return Graph(sources: sources, layers: rows);
  });
}

int runGraph(
  Graph graph,
  int iterations,
  double readFraction,
  ReactiveFramework framework,
) {
  final random = Random(0);
  final Graph(:sources, :layers) = graph;
  final leaves = layers.last;
  final skipCount = (leaves.length * (1 - readFraction)).round();
  final readLeaves = _removeElems(leaves, skipCount, random);

  late int sum;
  framework.withBatch(() {
    for (int i = 0; i < iterations; i++) {
      final sourceDex = i % sources.length;
      sources[sourceDex].write(i + sourceDex);

      for (final leaf in readLeaves) {
        leaf.read();
      }
    }

    sum = readLeaves.fold(0, (total, leaf) => total + leaf.read());
  });

  return sum;
}

List<T> _removeElems<T>(List<T> src, int rmCount, Random random) {
  final copy = List<T>.from(src);
  for (int i = 0; i < rmCount && copy.isNotEmpty; i++) {
    final rmDex = random.nextInt(copy.length);
    copy.removeAt(rmDex);
  }
  return copy;
}

List<List<Computed<int>>> _makeDependentRows(
  List<ISignal<int>> sources,
  int numRows,
  Counter counter,
  double staticFraction,
  int nSources,
  ReactiveFramework framework,
) {
  var prevRow = sources;
  final random = Random(0);
  final rows = <List<Computed<int>>>[];

  for (int l = 0; l < numRows; l++) {
    final row = _makeRow(
      prevRow,
      counter,
      staticFraction,
      nSources,
      framework,
      l,
      random,
    );
    rows.add(row);
    prevRow = row;
  }

  return rows;
}

List<Computed<int>> _makeRow(
  List<ISignal<int>> sources,
  Counter counter,
  double staticFraction,
  int nSources,
  ReactiveFramework framework,
  int layer,
  Random random,
) {
  return List.generate(sources.length, (myDex) {
    final mySources = List<ISignal<int>>.generate(
      nSources,
      (i) => sources[(myDex + i) % sources.length],
    );

    final staticNode = random.nextDouble() < staticFraction;
    if (staticNode) {
      return framework.computed(() {
        counter.count++;
        var sum = 0;
        for (final src in mySources) {
          sum += src.read();
        }
        return sum;
      });
    } else {
      final first = mySources[0];
      final tail = mySources.sublist(1);
      return framework.computed(() {
        counter.count++;
        var sum = first.read();
        final shouldDrop = sum & 0x1;
        final dropDex = sum % tail.length;

        for (int i = 0; i < tail.length; i++) {
          if (shouldDrop != 0 && i == dropDex) continue;
          sum += tail[i].read();
        }
        return sum;
      });
    }
  });
}
