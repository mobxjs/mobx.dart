---
title: Plan a small inventory
---

# Plan a small inventory

Collections: **ObservableList + Map + Set**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/collections" :height="520" />

## Try it

Select products and remove them in one action. Add new products after emptying the list.

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/collections.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
