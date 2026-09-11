---
title: Switch dependencies
---

# Switch dependencies

Architecture: **Conditional tracking + caching**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/dependencies" :height="520" />

## Try it

Change the inactive branch and check the computed run count. Switch branches and repeat.

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/dependencies.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
