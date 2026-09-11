import 'package:mobx_examples/gallery/examples/async.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/gallery/app.dart';
import 'package:mobx_examples/gallery/catalog.dart';
import 'package:mobx_examples/gallery/deferred_example.dart';
import 'package:mobx_examples/gallery/examples/dependencies.dart';
import 'package:mobx_examples/gallery/examples/collections.dart';
import 'package:mobx_examples/gallery/examples/stream.dart';
import 'package:mobx_examples/gallery/examples/reactions.dart';
import 'package:mobx_examples/site/stores.dart';

void main() {
  test(
    'reset restores shared example state without changing another example',
    () {
      final stores = DemoStores();
      stores.cart.change(5);
      stores.tasks.toggle(stores.tasks.tasks.first);
      stores.tasks.filter(true);
      stores.reset('/cart');
      expect(stores.cart.quantity.value, 1);
      expect(stores.cart.total.value, 24);
      expect(stores.tasks.onlyPending.value, isTrue);
      stores.reset('/tasks');
      expect(stores.tasks.onlyPending.value, isFalse);
      expect(stores.tasks.completed, {stores.tasks.tasks.first});
      stores.dispose();
    },
  );

  testWidgets('projects match idle, pending, error, and retry copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: OwnedProjectsDemo())),
    );
    expect(find.text('Your next projects are a click away.'), findsOneWidget);
    await tester.tap(find.text('Try an error response'));
    await tester.pump();
    await tester.tap(find.text('Load projects'));
    await tester.pump();
    expect(find.text('Finding your projects…'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    await tester.pump(const Duration(milliseconds: 901));
    await tester.pump();
    expect(find.text('That didn’t go to plan.\nTry again.'), findsOneWidget);
    await tester.tap(find.text('Try an error response'));
    await tester.pump();
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(find.text('Finding your projects…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 901));
    await tester.pump();
    expect(find.text('The little bookshop'), findsOneWidget);
    expect(find.text('Weekend adventures'), findsOneWidget);
    expect(find.text('Something new'), findsOneWidget);
    await tester.tap(find.text('Load projects'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  test('inactive branches do not evaluate an observed computed', () {
    final store = BranchStore();
    final seen = <int>[];
    final stop = autorun((_) => seen.add(store.active.value));
    store.change(true);
    expect(store.evaluations, 1);
    expect(seen, [1]);
    store.select(true);
    expect(seen, [1, 11]);
    store.change(false);
    expect(store.evaluations, 2);
    stop();
  });
  test('bulk inventory removal publishes a consistent state', () {
    final store = InventoryStore();
    store.toggle('Notebook');
    store.toggle('Pencil');
    final seen = <String>[];
    final stop = autorun(
      (_) => seen.add(
        '${store.products.length}/${store.quantities.length}/${store.selected.length}/${store.total.value}',
      ),
    );
    store.removeSelected();
    expect(seen, ['2/2/2/3', '0/0/0/0']);
    stop();
  });
  testWidgets('deferred loading is stable across rebuilds and retryable', (
    tester,
  ) async {
    var attempts = 0;
    var completer = Completer<void>();
    Future<void> load() {
      attempts++;
      return completer.future;
    }

    Widget app() => MaterialApp(
      home: DeferredExample(load: load, builder: (_) => const Text('Loaded')),
    );
    await tester.pumpWidget(app());
    await tester.pumpWidget(app());
    expect(attempts, 1);
    completer.completeError(StateError('offline'));
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);
    completer = Completer<void>();
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(attempts, 2);
    completer.complete();
    await tester.pumpAndSettle();
    expect(find.text('Loaded'), findsOneWidget);
  });
  testWidgets('disposed deferred view does not build when load finishes', (
    tester,
  ) async {
    final completer = Completer<void>();
    var builds = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: DeferredExample(
          load: () => completer.future,
          builder: (_) {
            builds++;
            return const Text('Loaded');
          },
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox());
    completer.complete();
    await tester.pump();
    expect(builds, 0);
    expect(tester.takeException(), isNull);
  });
  for (final example in examples) {
    testWidgets('route ${example.path} loads at narrow width', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final stores = DemoStores();
      await tester.runAsync(() async {
        await tester.pumpWidget(
          GalleryApp(route: '/${example.path}', embedded: true, stores: stores),
        );
        await tester
            .widget<DeferredExample>(find.byType(DeferredExample))
            .load();
      });
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      stores.dispose();
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('stream can recover from error and complete', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StreamExample())),
    );
    await tester.tap(find.text('Send value'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Latest value: 1'), findsOneWidget);
    await tester.tap(find.text('Send error'));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Signal interrupted'), findsOneWidget);
    await tester.tap(find.text('Send value'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Latest value: 2'), findsOneWidget);
    await tester.tap(find.text('Complete stream'));
    await tester.pumpAndSettle();
    expect(find.text('Status: done'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
  testWidgets('disposed reactions stop adding effects', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ReactionsExample())),
    );
    await tester.tap(find.text('Increment'));
    await tester.pump();
    expect(find.text('reaction: 1'), findsOneWidget);
    await tester.tap(find.text('Dispose reactions'));
    await tester.pump();
    await tester.tap(find.text('Increment'));
    await tester.pump();
    expect(find.text('Count: 2'), findsOneWidget);
    expect(find.text('reaction: 2'), findsNothing);
  });
}
