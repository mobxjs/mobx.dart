# MobX.dart documentation

MobX.dart provides documentation and learning material for MobX in Dart and Flutter. The site helps developers read the concepts and API, understand application structure, and experience reactive behavior in working examples. VitePress owns the website and normal documentation navigation.

The approved product experience combines reading with hands-on examples. The homepage has no sidebar; articles retain the normal sidebar. The visual identity is white/light backgrounds, blue text, Chakra Petch headings, Poppins body copy, the actual MobX SVG, and optional dark mode. See DESIGN.md for the implemented visual system.

The gallery contains eight examples progressing from fundamentals through collections and asynchronous data to architecture: counter, shopping bag, tasks, inventory collections, asynchronous projects, stream, reactions, and conditional dependencies. Each article explains a concrete interaction, embeds the real Flutter example, and includes the local source that powers it. There is no live source editor.

Run example loads Flutter on demand. GoRouter provides individual routes with deferred Dart imports. Flutter multi-view shares one engine across mounted views, and the complete app can also run independently. These are implementation contracts, not measured loading-speed claims. Code inclusion and runtime behavior must stay aligned as examples evolve.

Use evidence-backed descriptions of MobX behavior. Do not invent adoption figures, performance metrics, customer claims, or benchmark guarantees. An implementation or successful build alone does not prove a production deployment or every browser interaction.

Implementation references: .vitepress/theme/custom.css, .vitepress/theme/home.css, .vitepress/theme/components/ExampleGallery.vue, .vitepress/theme/components/FlutterExample.vue, .vitepress/theme/data/gallery.json, content/gallery/, and ../mobx_examples/lib/gallery/app.dart.
