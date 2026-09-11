---
title: Start with a counter
---

# Start with a counter

Fundamentals: **Observable + Action + Observer**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/counter" :height="520" />

## Try it

Increment and reset. The observable drives one small Observer.

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/counter.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
