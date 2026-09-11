---
title: Respond once, or often
---

# Respond once, or often

Architecture: **autorun + reaction + when**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/reactions" :height="520" />

## Try it

Increment to three. Compare the log entries, then dispose the effects and increment again.

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/reactions.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
