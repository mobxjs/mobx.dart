---
title: Follow a live signal
---

# Follow a live signal

Async: **ObservableStream + lifecycle**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/stream" :height="520" />

## Try it

Send values, then an error, then another value. Complete the stream and see the controls become unavailable.

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/stream.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
