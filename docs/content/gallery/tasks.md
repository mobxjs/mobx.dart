---
title: Filter a task list
---

# Filter a task list

Collections: **ObservableSet + Computed**. Run this example to see the dependency relationships change in real Flutter widgets.

<FlutterExample route="/tasks" :height="520" />

## Try it

Complete tasks, then show only unfinished work. The visible list and remaining count share one source of truth.

## The store

These are the observable facts and computed relationships used by the running widgets.

<<< ../../../mobx_examples/lib/site/stores.dart#tasks

## How it works

The source below is the code compiled into the live example. Each route owns its widget state; leaving a route disposes its effects and subscriptions. Cart and task state are shared by the gallery engine for cross-view demonstrations.

<<< ../../../mobx_examples/lib/gallery/examples/tasks.dart

[Browse all examples](/gallery/) · [Application architecture](/learn/architecture) · [API families](/api/)
