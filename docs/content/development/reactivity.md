# Follow a change through MobX

This guide is for contributors who need to reason about propagation, caching, and cleanup. Read the [consumer fundamentals](/learn/) first: the runtime implements the same observable → computed → reaction relationships.

## A tracked read records an edge

`Atom.reportObserved` delegates to its `ReactiveContext`. During a tracked derivation, the context records that atom as a dependency. Each tracking pass builds the dependencies that were actually read; a conditional branch can add or remove edges.

The current implementation keeps an ordered dependency list and a tracking cursor for the common stable-read case. It avoids constructing a set for every unchanged run. When reads diverge, it reconciles the new dependencies and removes unused observer relationships. Correctness requires duplicates, reordered reads, exceptions, and subscription changes to leave one coherent graph.

## A write marks downstream work

An observable compares the proposed value, processes interception where supported, stores the committed value, and reports change. Atoms notify their observers. Computeds propagate invalidation; reactions enter the context's pending queue. Equality can prevent propagation when a derived value remains equivalent.

A computed can be up-to-date, possibly stale, stale, or untracked. Possibly-stale propagation permits checking an intermediate computed before rerunning all consumers. These states are private runtime details; consumers use `Computed.value`.

## The outer batch defines publication

Nested actions increase batch depth. The outermost completion drains pending reactions until stable, subject to the configured iteration limit. Queuing must handle reactions added during a flush and disposed before their turn. The queue uses reusable buffers so newly scheduled work is distinct from the current pass.

A reaction's tracked expression establishes its dependencies. Its effect is untracked. Exceptions must restore tracking, batch, and policy state even if an error handler itself fails. A computed must not remain marked as computing after a failed evaluation.

## Disposal removes graph ownership

Disposing a reaction removes dependencies and cancels owned scheduled work. Unobserved computeds can suspend and release upstream edges. Lazy observer collections avoid allocating storage for atoms that never acquire observers. These optimizations are coupled to lifecycle correctness: an allocation saved by retaining a dead observer is a leak, not a performance improvement.

## Async work crosses zones and lifetimes

`AsyncAction` wraps continuations using zones. Keep the caller's zone semantics, including error handlers and unary/binary callbacks. `ObservableFuture` and `ObservableStream` publish status through their configured context. Disposing a consumer is distinct from cancelling a source operation.

Streams also distinguish single-subscription ownership, broadcast sources, pause, cancellation, error, and done. Nullable data and empty completion cannot be represented safely by a single null sentinel.

## Read the source in this order

| File under the repository root | Responsibility |
| --- | --- |
| `mobx/lib/src/api/reaction.dart` | User-facing effect helpers and options |
| `mobx/lib/src/core/atom.dart` | Dependency signals and observer ownership |
| `mobx/lib/src/core/context.dart` | Tracking, policy, batching, and reaction scheduling |
| `mobx/lib/src/core/context_extensions.dart` | Dependency reconciliation and propagation helpers |
| `mobx/lib/src/core/computed.dart` | Lazy evaluation, equality, and suspension |
| `mobx/lib/src/core/reaction.dart` | Reaction tracking and disposal |
| `mobx/lib/src/core/action.dart` | Scoped action state |
| `mobx/lib/src/api/async/` | Zone-aware actions, future and stream wrappers |
| `flutter_mobx/lib/src/observer_widget_mixin.dart` | Bridge from reaction invalidation to Flutter builds |

## Validate changes with graph-shaped tests

Test diamonds, chains, fan-out, conditional branches, reordered and duplicate reads, dispose/resubscribe during propagation, comparator failures, and exceptions during effects. Exercise custom contexts and async boundaries. The repository's `mobx/test/regressions/` and locally owned `mobx/benchmark/workloads/` contain these scenarios; benchmark changes in native and Wasm builds before claiming speedups.
