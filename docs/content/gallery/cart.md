---
title: Connect a shopping bag
---

# Connect a shopping bag

Fundamentals: **Computed + shared state**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/cart" :height="520" />

## Try it

Add notebooks. Watch the bag, subtotal, and free-shipping progress update together.

## The store

These are the observable facts and computed relationships used by the running widgets.

<<< ../../../mobx_examples/lib/site/stores.dart#cart

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/cart.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
