import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';
import '../gallery/app.dart';
import 'stores.dart';

@JS('mobxResetExample')
external set resetExample(JSFunction callback);

extension type ViewOptions._(JSObject _) implements JSObject {
  external String get route;
  external bool get dark;
  external bool get embedded;
}
void main() {
  WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  runWidget(const EmbeddedExamples());
}

class EmbeddedExamples extends StatefulWidget {
  const EmbeddedExamples({super.key});
  @override
  State<EmbeddedExamples> createState() => _EmbeddedExamplesState();
}

class _EmbeddedExamplesState extends State<EmbeddedExamples>
    with WidgetsBindingObserver {
  final stores = DemoStores();
  @override
  void initState() {
    super.initState();
    resetExample = ((String route) => stores.reset(route)).toJS;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    if (WidgetsBinding.instance.platformDispatcher.views.isEmpty) {
      stores.projects.cancel();
    }
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stores.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ViewCollection(
    views: [
      for (final view in WidgetsBinding.instance.platformDispatcher.views)
        View(
          key: ValueKey(view.viewId),
          view: view,
          child: Builder(
            builder: (context) {
              final data =
                  ui_web.views.getInitialData(view.viewId) as ViewOptions;
              return GalleryApp(
                route: data.route,
                dark: data.dark,
                embedded: data.embedded,
                stores: stores,
              );
            },
          ),
        ),
    ],
  );
}
