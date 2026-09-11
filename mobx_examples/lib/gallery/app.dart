import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../site/stores.dart';
import 'catalog.dart';
import 'deferred_example.dart';
import 'examples/counter.dart' deferred as counter;
import 'examples/cart.dart' deferred as cart;
import 'examples/tasks.dart' deferred as tasks;
import 'examples/collections.dart' deferred as collections;
import 'examples/async.dart' deferred as projects;
import 'examples/stream.dart' deferred as stream;
import 'examples/reactions.dart' deferred as reactions;
import 'examples/dependencies.dart' deferred as dependencies;

class GalleryApp extends StatefulWidget {
  const GalleryApp({
    super.key,
    this.route = '/',
    this.dark = false,
    this.embedded = false,
    required this.stores,
  });
  final String route;
  final bool dark, embedded;
  final DemoStores stores;
  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  late final router = GoRouter(
    initialLocation: widget.route,
    overridePlatformDefaultLocation: widget.embedded,
    routerNeglect: widget.embedded,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _Index()),
      _route(
        'counter',
        counter.loadLibrary,
        () => counter.buildExample(widget.stores),
      ),
      _route('cart', cart.loadLibrary, () => cart.buildExample(widget.stores)),
      _route(
        'tasks',
        tasks.loadLibrary,
        () => tasks.buildExample(widget.stores),
      ),
      _route(
        'collections',
        collections.loadLibrary,
        () => collections.buildExample(widget.stores),
      ),
      _route(
        'async',
        projects.loadLibrary,
        () => projects.buildExample(widget.stores),
      ),
      _route(
        'stream',
        stream.loadLibrary,
        () => stream.buildExample(widget.stores),
      ),
      _route(
        'reactions',
        reactions.loadLibrary,
        () => reactions.buildExample(widget.stores),
      ),
      _route(
        'dependencies',
        dependencies.loadLibrary,
        () => dependencies.buildExample(widget.stores),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => context.go('/'),
          child: const Text('Example not found. Open the gallery'),
        ),
      ),
    ),
  );
  GoRoute _route(
    String path,
    Future<void> Function() load,
    Widget Function() build,
  ) => GoRoute(
    path: '/$path',
    builder: (context, state) => Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(examples.firstWhere((e) => e.path == path).title),
              leading: IconButton(
                tooltip: 'Gallery',
                icon: const Icon(LucideIcons.arrowLeft),
                onPressed: () => context.go('/'),
              ),
            ),
      body: DeferredExample(
        key: ValueKey(path),
        load: load,
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: build(),
        ),
      ),
    ),
  );
  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: router,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff1974c7),
        brightness: widget.dark ? Brightness.dark : Brightness.light,
        surface: widget.dark ? const Color(0xff14273b) : Colors.white,
      ),
    ),
  );
}

class _Index extends StatelessWidget {
  const _Index();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('MobX in action')),
    body: ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Start small. Follow the connections.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ),
        for (final e in examples)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            title: Text(e.title),
            subtitle: Text('${e.level} · ${e.description}'),
            trailing: const Icon(LucideIcons.arrowRight),
            onTap: () => context.go('/${e.path}'),
          ),
      ],
    ),
  );
}
