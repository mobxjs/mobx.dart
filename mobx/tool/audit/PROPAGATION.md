# Dependency engine: data structures, housekeeping, and correctness

> Follow-up: all previously failing audit specifications are now fixed. See [resolved correctness audit](RESOLVED.md) for changes and verification.


> Historical baseline audit. Production fixes and native/Wasm comparisons are now recorded in [the implementation report](../../benchmark/results/README.md). Statements below about unchanged source and unexecuted checks describe the original audit snapshot.


Follow-up audit, 2026-09-11. Same production revision and SDK as the [initial audit](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/README.md). Production source remains unchanged.

There are substantial opportunities, but they have different confidence levels. Reducing collection invalidation fanout and fixing quadratic filtering have measured evidence. Replacing dependency bookkeeping could reduce allocations and improve throughput, but this audit has not benchmarked an alternative dependency engine. It would be misleading to promise a general 10× speedup from changing Sets to another container.

**What the engine currently pays for**

Each tracked evaluation builds a fresh `Set<Atom>`. Binding then computes two set differences—old minus new and new minus old—and allocates another empty set after publishing the new dependencies. This happens even when a reaction reads the exact same dependencies in the exact same order. Each atom also owns a Set of observers. A dependency is therefore represented in both directions, with hashing and per-container overhead.

The reaction queue is already deduplicated through `_isScheduled`, and pending unobservations through `_isPendingUnobservation`. Changing these lists to Sets would mostly add hashing rather than remove work. The queue copies its contents on every propagation wave. Unobservation processing has neither a reentrancy guard nor a post-callback subscription check. These are more important issues than the choice of queue container alone.

Owners: [tracking and binding](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:240), [reaction drain](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:352), [unobservation drain](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:164).

**Recommended structural changes, in priority order**

| Change | Expected benefit | Constraints |
|---|---|---|
| Separate map key values, key existence, size, and iteration dependencies | Potentially dramatic reduction in work for large collections. Earlier benchmark: one key write reran 1,000 unrelated key readers. Per-key tracking can avoid the other 999 reaction executions in that workload. | Define which mutations invalidate each category. Reclaim metadata for unobserved/missing keys. Share ownership across cast views. Per-key observers should be allocated lazily. |
| Add membership-level tracking for sets | Avoid rerunning all membership readers on an unrelated insert/remove. | Set iteration still depends on structural changes. Preserve comparator-backed semantics. |
| Treat list tracking separately | Index/length tracking can help sparse reads, but insertion/deletion shifts a suffix. | Do not blindly copy map tracking to lists: it can add enormous invalidation bookkeeping. Start with linear filtering and coherent bulk batching; evaluate indexed tracking with insertion-heavy workloads. |
| Reuse dependency storage for stable graphs | Reduce per-evaluation garbage and repeated hashing. A stable dependency list can have a fast path, with a fallback for changed dependencies. | Duplicate reads, nested computed evaluation, conditional branches, failed evaluation, and disposal must all remain correct. Never use one global per-atom stamp as an unqualified replacement for per-derivation membership. |
| Consider shared dependency-edge records | An edge can hold source, subscriber, observation generation, and links needed for removal from both directions; stable edges can survive repeated evaluations. | Intrusive links cost pointers and can lose CPU locality. Small contiguous arrays may be faster for low-degree nodes. Benchmark memory and speed against existing Sets before choosing a universal representation. |
| First remove difference-set allocations with membership loops | Lower-risk intermediate improvement: iterate old/new dependencies and test membership without allocating the two temporary difference Sets. | Still O(old + new dependencies); it does not eliminate reads or hashing. Preserve ordering of additions/removals and hook delivery. Gain is unmeasured. |
| Reuse two reaction-wave buffers, or a queue with explicit wave boundaries | Avoid list copying/allocation per wave while retaining deterministic scheduling. | Preserve wave-based cycle limits. Reset scheduling flags consistently on errors/cancellation. A simple unbounded drain changes cycle detection behavior. |
| Drain cleanup through one guarded queue | Avoid nested drains and lost work; release graph edges/resources reliably. | Clear/recheck pending flags carefully; callbacks may add observers, dispose others, schedule work, or throw. Recheck actual observer count after user callbacks before suspending a computed. |
| Keep user callbacks outside dependency tracking | Avoid unintended edges, extra reaction work, and potential feedback cycles. | Apply to lifecycle/instrumentation hooks; explicitly tracked application code must stay tracked. Mutation bookkeeping should read internal values rather than observable getters. |
| Cancel timers and release stream buffers according to explicit lifecycle policy | Potentially large retained-memory improvements in long-lived applications. | Timer disposal is a straightforward fix. Stream history retention is an API policy: preserve replay unless the caller opts into latest-value-only behavior. |

The first audit measured an approximately 1,658× native-list/observable-list gap for alternating removals at 100k items, and 10,000-to-one reaction-count reduction from enclosing bulk updates in an action. Those are stronger initial targets than an unmeasured wholesale graph rewrite.

**Seven additional reproduced failures**

The [new propagation suite](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/propagation_test.dart) has **10 tests: 7 fail, 3 pass** on unchanged production code. Results are recorded in [propagation-results.txt](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/propagation-results.txt).

1. **[P1] A newly resubscribed computed can lose its upstream edges during cleanup (G2).** The last subscriber is disposed; `onBecomeUnobserved` creates a replacement autorun reading that computed. Cleanup subsequently calls `_suspend()` despite the replacement observer. Updating the source from 1 to 2 leaves the replacement observing computed value **2 instead of 4**. Recheck subscribers after hooks and avoid reentrant cleanup invalidating fresh subscriptions. [context.dart:164](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:164).

2. **[P1] Cycle recovery strands unrelated pending reactions (G4).** A cyclic reaction queues an independent reaction just before the cycle limit. `_resetState()` discards the context queues but leaves existing reaction objects' `_isScheduled` and dependency-state flags intact. After disposing the cycle and updating the independent source again, its reaction still does not run: **0 instead of 2**. Recovery must reconcile queue membership and per-reaction/per-atom state together. Replacing the context state also resets names and removes spy listeners; those are additional source-level consequences, not independently tested here. [context.dart:363](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:363).

3. **[P2] Lifecycle-hook reads become dependencies of the reaction that triggered the hook (G3).** `onObserved` reads an unrelated observable while `trackingDerivation` is still set. Mutating that unrelated observable reruns the original reaction, although its body never read it. The probe gets **2 executions instead of 1**. Deliver lifecycle hooks under `untracked`, with exception-safe restoration. [context.dart:278](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:278), [atom.dart:86](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/atom.dart:86).

4. **[P2] A write can accidentally subscribe the writer to the old value (G9).** `_prepareNewValue` uses the public `value` getter during default equality comparison. An autorun that only assigns to an observable consequently subscribes to it. An external write causes extra executions: **3 total instead of 1** in the probe. Use `_value` for internal equality bookkeeping. This can create unexpected feedback and wasted propagation. The custom-comparer branch already reads `_value`, making tracking semantics depend on whether a comparer was supplied. [observable.dart:130](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/observable.dart:130).

5. **[P2] A computed equality-comparer error can disappear (G8).** The computed recomputes successfully, marks dependencies up-to-date, then its comparer throws. `_shouldCompute` catches this and decides to rerun the observer; its subsequent read finds the computed up-to-date and returns the previous cached value. The observer's error handler receives **no error**. Treat comparison as part of the computed evaluation outcome: publish success or error coherently, and preserve a valid retry/dirty state after failure. [computed.dart:170](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/computed.dart:170), [context.dart:476](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:476).

6. **[P2] Lifecycle listeners cannot safely unregister themselves during delivery (G10).** Hooks iterate their live Set. Self-unregistration triggers **Concurrent modification during iteration**, and later listeners do not get normal delivery. Use a defined snapshot or mutation-safe dispatch strategy; explicitly decide whether listeners removed mid-dispatch still receive the current event. [atom.dart:86](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/atom.dart:86).

7. **[P2] Reaction error handlers leak across default contexts (G5).** `ReactiveContext()` shares `ReactiveConfig.main`, which contains the mutable `_reactionErrorHandlers` Set. Registering a handler on context A receives an error from unrelated context B. Store handlers on the context, not on a potentially shared configuration. The same concern applies when callers deliberately share one config object. [context.dart:60](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:60), [context.dart:541](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:541).

These failures are distinct from the first audit's missing-context and exception-restoration findings. Several interact: unintended dependencies can increase fanout; a cleanup error can leak edges; inconsistent queue recovery can stop otherwise-correct propagation permanently.

**What passed and what remains uncertain**

- G7 performs **1,000 seeded batched updates** through a conditional diamond of computeds and checks the observed result against direct arithmetic after every update. All steps pass.
- G1 confirms successive distinct computed errors are delivered to the observing reaction in its tested path.
- G6 confirms a later source update can recover from the comparer exception in its tested path. G8 still demonstrates that the failing update itself loses error delivery.
- This is targeted executable probing, not exhaustive model checking. The passing diamond test does not cover every graph topology, disposal order, lifecycle reentrancy, scheduler, or error combination.

There is now enough evidence to prioritize dependency-engine hardening. It does not establish how many undiscovered bugs remain, or justify replacing the propagation algorithm without compatibility tests.

**Verification required before changing graph representation**

Build a deterministic reference evaluator for acyclic graphs and generate chains, diamonds, wide fanout, and dynamic branches. After each batch compare both values and effect counts. Separately inject hooks that subscribe/unsubscribe, exceptions from bodies/comparers/listeners, self-disposal, delayed scheduling, and cycle-limit failures. Verify recovery by updating unrelated nodes afterward.

Assert graph invariants at debug/test boundaries: every retained source-to-subscriber edge has its reverse edge; disposed reactions own no dependencies; queue flags agree with queue membership; pending cleanup cannot suspend an observed computed; and batch/tracking/computation state returns to its prior value after exceptions. Test retained-memory behavior through repeated create/observe/dispose cycles.

Benchmark stable dependencies and 1%/50%/100% dependency churn separately, for tiny nodes and large fan-in. Measure allocation volume, retained memory, notification counts, and latency distributions in native AOT and release JS/Wasm. A synthetic win for stable 1,000-edge reactions must not impose a regression on the far more common one-to-five-edge nodes.

Recommended order: fix the graph invariants and accidental dependencies; remove obvious allocations; implement finer collection tracking; then compare a stable-edge representation against the existing engine. Preserve the current two-phase computed invalidation, which already skips downstream execution when recomputed values compare equal.
