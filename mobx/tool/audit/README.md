# MobX performance and conditional-correctness audit

> Follow-up: all previously failing audit specifications are now fixed. See [resolved correctness audit](RESOLVED.md) for changes and verification.


> Historical baseline audit. Production fixes and native/Wasm comparisons are now recorded in [the implementation report](../../benchmark/results/README.md). Statements below about unchanged source and unexecuted checks describe the original audit snapshot.


Audited 2026-09-11 at revision `dc532481ab5d1044889e63335defd40501bee8c6`, MobX 2.6.1, using Dart 3.13.2 stable on macOS arm64. Production source was not changed. This directory contains a runnable audit, regression probes, and measured results.

The strongest performance opportunity is replacing quadratic list filtering with linear compaction. The highest-priority correctness work is context ownership, caller-zone preservation, exception-safe reactive bookkeeping, and stream lifecycle completion. These defects can produce stale UI, incorrect request context, or futures/subscriptions that never finish.

**Evidence and scope**

- Existing `mobx` suite: **439 passed, 1 skipped**.
- Audit suite: **20 probes: 17 failing desired-behavior assertions, 3 passing probes**. Failures are deliberately retained as regression specifications. Several failures share one root cause; they are not 17 independent bugs.
- Benchmarks: compiled native AOT, with assertions off. List measurements exclude construction, discard two warmups, and report the median of seven samples. Bulk timings are single samples; reaction counts are the stronger evidence.
- Inspected list, map, set, scalar observable/interceptor, future, stream, async action, computed, dependency tracking, reaction scheduling, action boundaries, relevant codegen templates, and Flutter observer integration.
- Executed the core package only. No Flutter widget suite, codegen suite, JS/Wasm benchmark, heap profile, or production workload was run. Native timing ratios are workload-specific and are not promised application speedups.

**Measured performance opportunities**

| Priority | Opportunity | Evidence | Recommended change |
|---|---|---|---|
| P1 | Linear `ObservableList.removeWhere` / `retainWhere` | Alternating removal at 10k: **12.676 ms** observable vs **0.070 ms** native; 50k: **321.743 ms** vs **0.351 ms**; 100k: **1,273.513 ms** vs **0.768 ms**. A 10× size increase costs roughly 100× in observable filtering. | Replace repeated `removeAt` with linear filtering/compaction. Preserve original-index change records and publish once. Combine with exception handling below. |
| P1 | Batch map/set bulk methods | Adding 10k entries causes **10k reactions per collection**, versus **one per collection** inside a single action. Combined insertion took 10.697 ms vs 1.507 ms with trivial length observers. | Override inherited bulk mutators and wrap the whole operation in one conditional action. Preserve direct `observe` event semantics. |
| P1 for long-lived feeds | Avoid unnecessary stream event retention | An observation-only single-subscription stream retains all **10,000** emitted events; a later `listen` receives all 10,000 while `value` only exposes the last. | Introduce an explicit latest-value-only adapter or buffering policy; do not silently remove historical replay from the existing API. |
| P2, architectural | Finer collection dependency tracking | Updating one map key reran **all 1,000** autoruns, each reading a different key. | Consider lazily allocated per-key/per-membership atoms plus structural/iteration atoms, starting with maps and sets. Reclaim unused key metadata. |
| P2 | Skip list change payloads without listeners | Every list notification allocates change records and initializes its listener holder, even with no direct listeners. `clear`, range operations, sort, and shuffle also build old/new snapshots for notification bookkeeping. | Add `_hasListeners` guards analogous to map/set. Separate atom invalidation from detailed event construction. Benchmark allocations before claiming a gain. |
| P2 | Avoid no-op invalidation | `ObservableMap.remove` reports a change for a missing key; `ObservableSet.clear` reports a change on an empty set. Range writes always notify even for equal content. | Suppress provable no-ops; benchmark whether comparison scans are worthwhile for range operations. |
| P3 | Reduce repeated tracking and action allocations | Map/set iteration reports observation per `moveNext` and `current`; dependency rebinding creates temporary sets; ordinary actions create spy events even when spying is disabled. | Profile before changing. Preserve deferred-iterator tracking semantics and lifecycle hooks; a blanket “observe only when iterator is created” change is unsafe. |

The native list comparison is a lower-overhead reference, **not a benchmark of an implemented MobX fix**. It does demonstrate an algorithmic gap of roughly 1,658× at 100k for this workload. Listener payload generation will have a cost even after compaction.

List owner: [observable_list.dart:299](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_list.dart:299). Map/set bulk behavior comes from SDK `MapMixin`/`SetMixin`, whose bulk operations call the overridden single-element methods. Scalar actions already provide an immediate batching workaround.

**Confirmed correctness findings**

1. **[P1] ObservableFuture ignores its supplied context for observable state.** [observable_future.dart:16](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/async/observable_future.dart:16). `FutureResult` creates `_status` and `_result` without `context: context`, but its action controller uses the supplied context. Probe F1 observes the future in a custom context: it sees `pending` and never sees `fulfilled`, even though the future completes. Pass the context to both observables. Verify success, error, replacement, and chained future paths, including state/result atomicity.

2. **[P1] Reused AsyncAction retains the first caller's Zone.** [async_action.dart:17](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/async/async_action.dart:17). `_zoneField` is forked once and reused indefinitely. F2 invokes one action from request zones A then B; the second invocation reads **A**. This affects zone-local tracing, dependency injection, and other caller metadata. Generated actions are cached fields, making reuse ordinary behavior. Fork from the current caller zone for each invocation, or use a design that preserves the current parent without retaining arbitrary previous callers. Test concurrent callers and distinct error zones; incorrect error routing/hangs are a risk to investigate, not demonstrated by F2.

3. **[P1] Exceptions can corrupt reactive bookkeeping after the exception is caught by application code.** [computed.dart:118](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/computed.dart:118), [context.dart:257](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/context.dart:257), [reaction.dart:79](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/reaction.dart:79). F11 throws from a computed with error boundaries disabled: `context.isWithinBatch` remains true. F19 reproduces a leaked batch under normal boundaries when a reaction's `onError` throws. Tracking, computation depth, running flags, batches, and the reaction drain lack complete `finally` restoration. Unrelated subsequent work can be blocked or inherit invalid tracking. Restore each acquired state independently in `finally`; also ensure `ActionController.endAction` restores untracked state if batch draining throws. Test recovery by running independent reactions after each failure, not only by asserting an exception.

4. **[P1] ObservableStream cancel-on-error cancels its source without completing downstream.** [observable_stream.dart:487](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/async/observable_stream.dart:487), [observable_stream.dart:525](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/async/observable_stream.dart:525). F5 configures `cancelOnError: true`, emits an error, and observes no downstream `onDone`; status remains active. Source cancellation does not supply the normal done event that `_onDone` depends on. Downstream consumers that handle errors and wait for completion can hang. Explicitly transition and close the observable controller after forwarding the terminal error. Cover both broadcast/single-subscription sources, cancellation failures, repeated close, and observing without `listen`.

5. **[P1] Throwing map/set listeners hide committed mutations from reactions.** [observable_map.dart:102](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_map.dart:102), [observable_set.dart:72](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_set.dart:72). These mutate storage, notify direct listeners, then report atom changes. If a listener throws, invalidation is skipped. F6 commits map value 2 while its autorun retains 1; F14 adds a set member while its autorun retains length 0. Invalidate before calling user code while still inside the batch, or guarantee invalidation in `finally`. Audit add/update/remove/clear together. Decide explicitly whether subsequent direct listeners continue after an exception.

6. **[P1] Throwing list predicates leave partially mutated storage with no notification.** [observable_list.dart:299](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_list.dart:299). Filtering removes elements before all predicates have completed, and only reports changes after the loop. F7 removes 4, then throws at 2; storage becomes `[1,2,3]` but the autorun remains `[1,2,3,4]`. `retainWhere` shares the pattern. Prefer a prepare-then-commit implementation: evaluate and collect retained/removed entries before mutating, with a concurrent-modification check. Alternatively guarantee publication of partial changes. Callback-bearing sort/shuffle also need exception-path review; those variants were not separately reproduced.

7. **[P2] Reaction and when effect actions use the default context.** [reaction_helper.dart:98](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/reaction_helper.dart:98), [reaction_helper.dart:183](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/reaction_helper.dart:183). Both omit `context` when constructing their effect action. F17 shows the custom context never receives the when-effect action; F18 shows a delayed reaction effect runs with the supplied context outside a batch. Synchronous execution can mask this because the surrounding reaction already batches. Custom-context writes from scheduled effects can assert in debug and lose action batching in release. Supply the same context to each effect action.

8. **[P2] An empty non-nullable stream throws in its nullable done handler.** [observable_stream.dart:146](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/async/observable_stream.dart:146). F15 observes `Stream<int>.empty()` to completion and calls `match(done: ...)`; `data as T` casts null to int even though the done callback accepts `T?`. Pass nullable data for the done state. Also define behavior when no done callback exists and no value has ever arrived; the fallback active callback has the same non-nullability concern.

9. **[P2] Scalar interceptor listeners receive the requested value instead of the committed value.** [observable.dart:99](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/observable.dart:99). F10 requests 2, an interceptor transforms it to 10, storage contains 10, but the direct listener receives 2. Populate `ChangeNotification.newValue` from the prepared/committed value. This matters for synchronization and change logs.

10. **[P2] Collection Object-accepting methods perform incompatible casts.** [observable_list.dart:246](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_list.dart:246), [observable_map.dart:82](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_map.dart:82). F8: `ObservableList<int>(...).remove('x')` throws instead of returning false. F9: a string-keyed observable map queried with 42 throws instead of returning null. Delegate the Object argument to the underlying collection rather than narrowing first. Include null and custom comparator-backed collections in compatibility tests. List removal should also report the actual removed element, not merely an equal caller-supplied object.

11. **[P2] Disposing a scheduled reaction does not promptly cancel its timer.** [reaction_helper.dart:52](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/core/reaction_helper.dart:52). F16 disposes a delayed autorun with a one-hour timer; the timer is still active. The callback checks disposal when it finally fires, preventing execution but retaining captured state until then. Tie scheduler cleanup to disposal for autorun, reaction, and when timeouts. Test disposal before the first callback and after rescheduling. Custom periodic schedulers need an explicit lifecycle contract too.

12. **[P2, API consistency] A list cast view shares storage and atom but not direct listeners.** [observable_list.dart:177](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_list.dart:177). F12 mutates through `list.cast<int>()`: the original list changes and its atom invalidates, but `list.observe` receives no event. Direct event subscriptions are wrapper-local. Establish whether collection views promise shared event delivery; if so, move notification ownership to shared backing state with safe type adaptation. Set cast views have the same source-level design. Map casts have a different wrapper path and need their own tests rather than assuming identical behavior.

13. **[P2] Empty range operations bypass argument validation.** [observable_list.dart:288](/Users/pavanpodila/Projects/mobx.dart/mobx/lib/src/api/observable_collections/observable_list.dart:288). F13 calls `removeRange(5,5)` on a one-element list and gets a silent return. Methods guard work with `end > start` before validating. Validate bounds even for empty ranges. Review fillRange/setRange/replaceRange plus empty insertAll/setAll against the SDK contract; the checked-in reproduction specifically covers removeRange.

**Additional source-confirmed context defect**

The codegen async-action template wraps observable async methods with `ObservableFuture(...)` without `context: context`: [async_action.dart:31](/Users/pavanpodila/Projects/mobx.dart/mobx_codegen/lib/src/template/async_action.dart:31). The plain observable-future template already supplies it. Fixing FutureResult alone therefore will not fix generated methods that combine observable wrapping and async actions. Update the template and generated-fixture tests together. This finding is from source inspection; generator output was not executed during this audit.

**Suspicions that did not reproduce**

- F3, a two-argument `Future.catchError` callback inside AsyncAction, **did run within the action batch** on this Dart SDK. The missing `runBinary` override alone is not sufficient evidence of a user-facing Future-handler bug.
- F4, forwarding a stream error with an explicit stack trace, **preserved the stack** in the tested controller path. Do not claim stack loss solely because `_onError` accepts one parameter.
- The third passing probe, P4, intentionally characterizes stream history retention. It is evidence of a memory/scaling concern, not an assertion that replay itself violates the existing API.

**Implementation order and acceptance criteria**

1. Correct context propagation across futures, effect actions, and codegen; preserve each async caller's zone. Run the existing async/context suites plus the new regressions with concurrent callers, success and failure, delay/scheduler variants, and nested actions.
2. Make reactive state restoration and collection invalidation exception-safe. Verify an unrelated observable/computed/reaction still works after each injected failure. Preserve listener ordering and define partial mutation behavior.
3. Repair stream cancellation/done handling and nullable completion. Test all combinations of observation, direct listening, pause/resume, early cancellation, empty completion, and repeated close. Add a separate explicit solution for latest-value-only feeds.
4. Implement linear list filtering and batch inherited bulk methods. Preserve event payloads and callback semantics; compare scaling at 10k, 50k, and 100k with no observers, autoruns, and direct listeners. Native linear filtering currently visits predicates forward while this implementation visits backward; choose and document compatible callback order deliberately.
5. Remove unnecessary allocations/no-op invalidations, then evaluate per-key atoms under real workloads. Measure retained memory as well as speed: more granular tracking must not keep every historically queried key alive.

Re-run benchmarks in Flutter release JS/Wasm before making UI latency claims. Do not spend the first optimization pass rewriting the dependency engine: the demonstrated collection algorithms and fanout offer clearer wins.

**Reproduction**

Run from `/Users/pavanpodila/Projects/mobx.dart/mobx` using the installed SDK executable if `dart` is not on PATH:

```sh
/Users/pavanpodila/sdk/flutter/bin/cache/dart-sdk/bin/dart test
/Users/pavanpodila/sdk/flutter/bin/cache/dart-sdk/bin/dart test tool/audit/audit_test.dart --reporter expanded --no-color
/Users/pavanpodila/sdk/flutter/bin/cache/dart-sdk/bin/dart compile exe tool/audit/benchmark.dart -o /private/tmp/mobx-audit-benchmark
/private/tmp/mobx-audit-benchmark
```

The audit suite intentionally exits nonzero on this revision. It lives outside the default `test/` discovery path so that the audit does not change the existing suite's result. Move confirmed regressions into the owning tests as fixes land.

Artifacts: [regression probes](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/audit_test.dart), [test output](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/results.txt), [benchmark](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/benchmark.dart), [benchmark output](/Users/pavanpodila/Projects/mobx.dart/mobx/tool/audit/benchmark-results.txt).
