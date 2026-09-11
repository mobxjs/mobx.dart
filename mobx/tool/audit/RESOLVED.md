# Correctness follow-up: all audit specifications resolved

2026-09-11. The ten remaining failing specifications from the initial audit are
now fixed in production source. All **30 original audit/propagation probes pass**.
The regular [audit correctness suite](../../test/regressions/audit_correctness_test.dart)
contains the original 20 probes plus 13 additional edge-case tests and is included
in the coverage aggregator. The dependency suite already covers the propagation
follow-up findings.

| Specification | Fix | Additional coverage |
|---|---|---|
| F1 supplied future context | Pass the owning context to both internal status and result observables | Rejection, recovered/chained future, coherent status/result updates |
| F2 reused AsyncAction zone | Fork from the current caller for every invocation; handle binary zone callbacks | Overlapping calls completing out of order; callback errors and restored batch state |
| F5 source cancelOnError completion | Forward error and original stack, then publish terminal status and close the downstream controller | Two broadcast subscribers, exactly one error/done each, no post-error values, observing terminal properties again |
| F10 intercepted notification value | Notify the value actually committed after interception | Original reproduction checks storage and listener payload agree |
| F12 cast-view listeners | Share a notification owner across list casts and adapt events to each observing view | Casts before listener registration, nested casts, both mutation directions, disposal, element/range payloads, lazy type errors |
| F13 invalid empty ranges | Validate bounds before skipping empty work in removeRange, fillRange, setRange, replaceRange and setAll | Negative, out-of-bounds, reversed ranges and valid empty no-ops |
| F15 empty stream completion | Use nullable done values; distinguish no event from an actual null event | Empty fallback handlers are not invoked; real nullable events still reach active fallback |
| F16 scheduled timer disposal | Reaction owns and cancels its timer, including when timeout timers | Direct Reaction.dispose, canceled delayed effects, manual when disposal, synchronous scheduler with self-disposal |
| F17 when effect context | Construct the effect action in the supplied context | Context-local action spy event |
| F18 scheduled effect context | Construct the reaction effect action in the supplied context | Effect executes inside the correct context's batch |

Stream error forwarding now explicitly carries the original stack. Terminal
broadcast streams do not restart their source when properties are observed again.
Pending initial values are not inserted after cancellation/closure.

Behavioral changes are intentional: constructor-level stream cancelOnError now
ends downstream streams; disposal releases timers immediately; invalid empty list
ranges throw; cast views receive shared mutations; and custom-context effects use
their owning context. The normal Dart subscription-level cancelOnError behavior
remains distinct: a listener that cancels itself on error does not receive done.

The original results files are historical failing-baseline evidence. See
[resolved-verification.txt](resolved-verification.txt) for the completed original
probes. New full-suite logs are in
[the correctness verification directory](../../benchmark/results/correctness-verification/).
Passing these specifications does not establish that every possible asynchronous,
reentrant, or collection mutation pattern is correct.

Core regression tests now live under `test/regressions/`; benchmark smoke and harness tests live under `test/benchmark/`. The integrated suite passes 505 core tests on native Dart and Wasm, with one existing skip. All 35 workload implementations are maintained under `benchmark/workloads/` with typed results and normal static analysis.
